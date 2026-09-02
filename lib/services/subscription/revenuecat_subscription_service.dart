import 'dart:async';

import 'subscription_service.dart';

/// Production subscription management via RevenueCat.
///
/// INTEGRATION POINT (Phase 5). To enable:
///  1. add `purchases_flutter: ^8.x` to pubspec
///  2. set `ENABLE_REVENUECAT=true` and the public SDK keys in `.env`
///  3. uncomment the `Purchases` calls below
///  4. in `bootstrap()`, when `config.enableRevenueCat`, use this class instead
///     of `MockSubscriptionService`
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
  // Reassigned by _onCustomerInfo once the purchases_flutter listener is wired.
  // ignore: prefer_final_fields
  SubscriptionStatus _status = SubscriptionStatus.free;

  Future<void> init() async {
    // await Purchases.configure(PurchasesConfiguration(apiKey));
    // Purchases.addCustomerInfoUpdateListener(_onCustomerInfo);
    // final info = await Purchases.getCustomerInfo();
    // _onCustomerInfo(info);
    _controller.add(_status);
  }

  // void _onCustomerInfo(CustomerInfo info) {
  //   final ent = info.entitlements.active[entitlementId];
  //   _status = ent == null
  //       ? SubscriptionStatus.free
  //       : SubscriptionStatus(
  //           tier: SubscriptionTier.premium,
  //           expiresAt: DateTime.tryParse(ent.expirationDate ?? ''),
  //           isInTrial: ent.periodType == PeriodType.trial,
  //           productId: ent.productIdentifier,
  //         );
  //   _controller.add(_status);
  // }

  @override
  SubscriptionStatus get current => _status;

  @override
  Stream<SubscriptionStatus> statusStream() => _controller.stream;

  @override
  Future<List<SubscriptionPlan>> plans() async {
    // final offerings = await Purchases.getOfferings();
    // return offerings.current!.availablePackages.map(_toPlan).toList();
    throw UnimplementedError('Wire purchases_flutter to fetch offerings.');
  }

  @override
  Future<SubscriptionStatus> purchase(String planId) async {
    // final offerings = await Purchases.getOfferings();
    // final pkg = offerings.current!.availablePackages
    //     .firstWhere((p) => p.identifier == planId);
    // await Purchases.purchasePackage(pkg);
    // return _status;
    throw UnimplementedError('Wire purchases_flutter purchasePackage.');
  }

  @override
  Future<SubscriptionStatus> restore() async {
    // final info = await Purchases.restorePurchases();
    // _onCustomerInfo(info);
    return _status;
  }

  @override
  Future<void> debugSetPremium(bool value) =>
      throw UnsupportedError('Not available with the real subscription service.');

  void dispose() => _controller.close();
}
