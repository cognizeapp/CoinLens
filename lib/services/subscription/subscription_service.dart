import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Entitlement state for the freemium gate. In Phase 5 this is backed by
/// RevenueCat; until then a mock implementation lets Premium be toggled for
/// development.
enum SubscriptionTier { free, premium }

class SubscriptionStatus {
  const SubscriptionStatus({
    required this.tier,
    this.expiresAt,
    this.isInTrial = false,
    this.productId,
  });

  final SubscriptionTier tier;
  final DateTime? expiresAt;
  final bool isInTrial;
  final String? productId;

  bool get isPremium => tier == SubscriptionTier.premium;

  static const free = SubscriptionStatus(tier: SubscriptionTier.free);
}

class SubscriptionPlan {
  const SubscriptionPlan({
    required this.id,
    required this.title,
    required this.priceLabel,
    required this.period,
    this.badge,
    this.trialLabel,
  });

  final String id;
  final String title;
  final String priceLabel;
  final String period;
  final String? badge;
  final String? trialLabel;
}

abstract interface class SubscriptionService {
  Stream<SubscriptionStatus> statusStream();
  SubscriptionStatus get current;
  Future<List<SubscriptionPlan>> plans();
  Future<SubscriptionStatus> purchase(String planId);
  Future<SubscriptionStatus> restore();

  /// Dev-only affordance; real implementations throw [UnsupportedError].
  Future<void> debugSetPremium(bool value);
}

/// Overridden in `main()` with [MockSubscriptionService] or the RevenueCat
/// implementation.
final subscriptionServiceProvider = Provider<SubscriptionService>(
  (ref) =>
      throw UnimplementedError('subscriptionServiceProvider not overridden'),
);

/// Convenience: current entitlement as a reactive value.
final subscriptionStatusProvider = StreamProvider<SubscriptionStatus>((ref) {
  return ref.watch(subscriptionServiceProvider).statusStream();
});

final isPremiumProvider = Provider<bool>((ref) {
  return ref.watch(subscriptionStatusProvider).valueOrNull?.isPremium ?? false;
});
