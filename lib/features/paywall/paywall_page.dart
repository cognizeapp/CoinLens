import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/l10n_extensions.dart';
import '../../core/widgets/brand_mark.dart';
import '../../core/widgets/state_views.dart';
import '../../services/analytics/analytics_service.dart';
import '../../services/subscription/subscription_service.dart';

class PaywallPage extends ConsumerStatefulWidget {
  const PaywallPage({super.key});

  @override
  ConsumerState<PaywallPage> createState() => _PaywallPageState();
}

class _PaywallPageState extends ConsumerState<PaywallPage> {
  String? _selectedPlanId;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    ref
        .read(analyticsServiceProvider)
        .logEvent(AnalyticsEvent.paywallViewed);
  }

  Future<void> _subscribe(SubscriptionService service) async {
    final planId = _selectedPlanId;
    if (planId == null) return;
    setState(() => _busy = true);
    await ref
        .read(analyticsServiceProvider)
        .logEvent(AnalyticsEvent.subscriptionStarted, params: {'plan': planId});
    final status = await service.purchase(planId);
    if (!mounted) return;
    setState(() => _busy = false);
    if (status.isPremium) {
      unawaited(HapticFeedback.mediumImpact());
      unawaited(ref.read(analyticsServiceProvider).logEvent(
          AnalyticsEvent.subscriptionCompleted, params: {'plan': planId}));
      if (context.canPop()) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final service = ref.watch(subscriptionServiceProvider);
    final plansAsync = ref.watch(_plansProvider);

    final features = [
      l.featAiAnalysis,
      l.featCoinHistory,
      l.featRarityInsights,
      l.featConditionAnalysis,
      l.featSellGuide,
      l.featSellingRecs,
      l.featCollectorInsights,
      l.featAiAssistant,
      l.featAdvancedStats,
      l.featNoAds,
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.canPop() ? context.pop() : context.go('/'),
        ),
      ),
      body: SafeArea(
        child: plansAsync.when(
          loading: () => const LoadingView(),
          error: (_, __) => ErrorStateView(
            message: l.paywallLoadError,
            onRetry: () => ref.refresh(_plansProvider),
          ),
          data: (plans) {
            _selectedPlanId ??=
                plans.firstWhere((p) => p.badge != null, orElse: () => plans.first).id;
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(AppSpacing.screen),
                    children: [
                      const Center(child: BrandMark(size: 52)),
                      const SizedBox(height: AppSpacing.lg),
                      Text(l.paywallHeadline,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontSize: 26)),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        l.paywallSubheadline,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      ...features.map((f) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle_rounded,
                                    color: AppColors.gold, size: 20),
                                const SizedBox(width: AppSpacing.md),
                                Text(f,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge),
                              ],
                            ),
                          )),
                      const SizedBox(height: AppSpacing.xl),
                      ...plans.map((p) => _PlanTile(
                            plan: p,
                            selected: p.id == _selectedPlanId,
                            onTap: () =>
                                setState(() => _selectedPlanId = p.id),
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.screen),
                  child: Column(
                    children: [
                      Builder(builder: (context) {
                        final selected = plans.firstWhere(
                            (p) => p.id == _selectedPlanId,
                            orElse: () => plans.first);
                        if (selected.trialLabel == null) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding:
                              const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.card_giftcard_rounded,
                                  size: 16, color: AppColors.gold),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  l.paywallTrialFraming(selected.priceLabel),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          color: AppColors.textSecondary),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      FilledButton(
                        onPressed: _busy ? null : () => _subscribe(service),
                        child: _busy
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: AppColors.onGold),
                              )
                            : Text(
                                plans
                                            .firstWhere(
                                                (p) => p.id == _selectedPlanId,
                                                orElse: () => plans.first)
                                            .trialLabel !=
                                        null
                                    ? l.paywallStartTrial
                                    : l.actionContinue,
                              ),
                      ),
                      TextButton(
                        onPressed: _busy
                            ? null
                            : () async {
                                final status = await service.restore();
                                if (context.mounted && status.isPremium) {
                                  context.pop();
                                }
                              },
                        child: Text(l.restorePurchases),
                      ),
                      Text(
                        '${l.paywallLegal} ${l.valueDisclaimer}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

final _plansProvider = FutureProvider<List<SubscriptionPlan>>((ref) {
  return ref.watch(subscriptionServiceProvider).plans();
});

class _PlanTile extends StatelessWidget {
  const _PlanTile(
      {required this.plan, required this.selected, required this.onTap});
  final SubscriptionPlan plan;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final yearly = plan.id.contains('year');
    final title = yearly ? l.planYearly : l.planMonthly;
    final period = yearly ? l.planPerYear : l.planPerMonth;
    final badge = plan.badge != null ? l.bestValue : null;
    final trial = plan.trialLabel != null ? l.trial7Days : null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: selected ? AppColors.gold : AppColors.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: selected ? AppColors.gold : AppColors.textTertiary,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title,
                          style: Theme.of(context).textTheme.titleMedium),
                      if (badge != null) ...[
                        const SizedBox(width: AppSpacing.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.gold,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Text(badge,
                              style: const TextStyle(
                                  color: AppColors.onGold,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ],
                  ),
                  if (trial != null)
                    Text(trial,
                        style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(plan.priceLabel,
                    style: Theme.of(context).textTheme.titleLarge),
                Text(period,
                    style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
