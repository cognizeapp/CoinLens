import 'dart:async';

import 'package:purchases_flutter/purchases_flutter.dart';

import 'subscription_service.dart';

/// Production subscription management via RevenueCat.
///
/// Configured in `bootstrap()` whenever a platform API key is present
/// (`REVENUECAT_API_KEY_IOS` / `REVENUECAT_API_KEY_ANDROID` — see
/// `AppConfig.fromEnvironment`); [MockSubscriptionService] remains the
/// fallback so the app still runs without a RevenueCat project.
///
/// The store is the source of truth for prices and the free trial; the labels
/// shown in the paywall come from the fetched offering, not hard-coded strings.
class RevenueCatSubscriptionService implements SubscriptionService {
  RevenueCatSubscriptionService({
    required this.apiKey,
    required this.entitlementId,
  });

  final String apiKey;

  /// The entitlement identifier configured in the RevenueCat dashboard
  /// (e.g. "premium").
  final String entitlementId;

  final _controller = StreamController<SubscriptionStatus>.broadcast();
  SubscriptionStatus _status = SubscriptionStatus.free;

  Future<void> init() async {
    await Purchases.setLogLevel(LogLevel.warn);
    await Purchases.configure(PurchasesConfiguration(apiKey));
    Purchases.addCustomerInfoUpdateListener(_onCustomerInfo);
    try {
      final info = await Purchases.getCustomerInfo();
      _onCustomerInfo(info);
    } catch (_) {
      _controller.add(_status);
    }
  }

  /// Ties the RevenueCat app-user-id to our own account id (e.g. Firebase
  /// uid) so entitlements follow the signed-in user across devices, and
  /// resets to an anonymous id on sign-out.
  Future<void> identify(String? appUserId) async {
    if (appUserId == null) {
      await Purchases.logOut();
    } else {
      await Purchases.logIn(appUserId);
    }
  }

  void _onCustomerInfo(CustomerInfo info) {
    final ent = info.entitlements.active[entitlementId];
    _status = ent == null
        ? SubscriptionStatus.free
        : SubscriptionStatus(
            tier: SubscriptionTier.premium,
            expiresAt: DateTime.tryParse(ent.expirationDate ?? ''),
            isInTrial: ent.periodType == PeriodType.trial,
            productId: ent.productIdentifier,
          );
    _controller.add(_status);
  }

  @override
  SubscriptionStatus get current => _status;

  @override
  Stream<SubscriptionStatus> statusStream() async* {
    yield _status;
    yield* _controller.stream;
  }

  SubscriptionPlan _toPlan(Package pkg) {
    final product = pkg.storeProduct;
    final isAnnual = pkg.packageType == PackageType.annual ||
        pkg.identifier.toLowerCase().contains('year');
    return SubscriptionPlan(
      id: pkg.identifier,
      title: product.title.isNotEmpty
          ? product.title
          : (isAnnual ? 'Yearly' : 'Monthly'),
      priceLabel: product.priceString,
      period: isAnnual ? '/year' : '/month',
      badge: isAnnual ? 'BEST VALUE' : null,
      trialLabel: product.introductoryPrice != null
          ? '${product.introductoryPrice!.periodNumberOfUnits}-day free trial'
          : null,
    );
  }

  @override
  Future<List<SubscriptionPlan>> plans() async {
    final offerings = await Purchases.getOfferings();
    final current = offerings.current;
    if (current == null) return const [];
    return current.availablePackages.map(_toPlan).toList()
      ..sort((a, b) => b.period.compareTo(a.period)); // yearly first
  }

  @override
  Future<SubscriptionStatus> purchase(String planId) async {
    final offerings = await Purchases.getOfferings();
    final pkg = offerings.current?.availablePackages
        .where((p) => p.identifier == planId)
        .firstOrNull;
    if (pkg == null) {
      throw StateError('Unknown plan "$planId".');
    }
    final info = await Purchases.purchasePackage(pkg);
    _onCustomerInfo(info);
    return _status;
  }

  @override
  Future<SubscriptionStatus> restore() async {
    final info = await Purchases.restorePurchases();
    _onCustomerInfo(info);
    return _status;
  }

  @override
  Future<void> debugSetPremium(bool value) => throw UnsupportedError(
      'Not available with the real subscription service.');

  void dispose() => _controller.close();
}
