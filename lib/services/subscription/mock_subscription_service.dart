import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import 'subscription_service.dart';

/// In-memory + SharedPreferences-backed entitlement, so a dev-toggled Premium
/// state survives restarts. Purchases "succeed" instantly.
class MockSubscriptionService implements SubscriptionService {
  MockSubscriptionService(this._prefs) {
    final stored = _prefs.getBool(_key) ?? false;
    _status = stored ? _premiumStatus() : SubscriptionStatus.free;
  }

  static const String _key = 'mock_is_premium';
  final SharedPreferences _prefs;
  final _controller = StreamController<SubscriptionStatus>.broadcast();
  SubscriptionStatus _status = SubscriptionStatus.free;

  SubscriptionStatus _premiumStatus() => SubscriptionStatus(
        tier: SubscriptionTier.premium,
        expiresAt: DateTime.now().add(const Duration(days: 30)),
        productId: 'coinsights_premium_monthly',
      );

  @override
  SubscriptionStatus get current => _status;

  @override
  Stream<SubscriptionStatus> statusStream() async* {
    yield _status; // late subscribers still get the current entitlement
    yield* _controller.stream;
  }

  @override
  Future<List<SubscriptionPlan>> plans() async => const [
        SubscriptionPlan(
          id: 'coinsights_premium_yearly',
          title: 'Yearly',
          priceLabel: '€29.99',
          period: 'per year',
          badge: 'BEST VALUE',
          trialLabel: '7-day free trial',
        ),
        SubscriptionPlan(
          id: 'coinsights_premium_monthly',
          title: 'Monthly',
          priceLabel: '€4.99',
          period: 'per month',
        ),
      ];

  @override
  Future<SubscriptionStatus> purchase(String planId) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    _status = _premiumStatus();
    await _prefs.setBool(_key, true);
    _controller.add(_status);
    return _status;
  }

  @override
  Future<SubscriptionStatus> restore() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    _controller.add(_status);
    return _status;
  }

  @override
  Future<void> debugSetPremium(bool value) async {
    _status = value ? _premiumStatus() : SubscriptionStatus.free;
    await _prefs.setBool(_key, value);
    _controller.add(_status);
  }

  void dispose() => _controller.close();
}
