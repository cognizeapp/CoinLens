import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
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
      unawaited(ref.read(analyticsServiceProvider).logEvent(
          AnalyticsEvent.subscriptionCompleted, params: {'plan': planId}));
      if (context.canPop()) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = ref.watch(subscriptionServiceProvider);
    final plansAsync = ref.watch(_plansProvider);

    const features = [
      'Detailed AI analysis',
      'Coin history',
      'Rarity insights',
      'Condition analysis',
      'Selling recommendations',
      'Collector insights',
      'AI coin assistant',
      'Advanced collection statistics',
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
            message: 'Could not load subscription options.',
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
                      const Icon(Icons.auto_awesome_rounded,
                          color: AppColors.gold, size: 36),
                      const SizedBox(height: AppSpacing.md),
                      Text('Unlock the Full Story Behind Every Coin',
                          style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Discover the history, rarity and best way to sell your coins.',
                        style: Theme.of(context).textTheme.bodyMedium,
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
                      FilledButton(
                        onPressed: _busy ? null : () => _subscribe(service),
                        child: _busy
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Color(0xFF1A1400)),
                              )
                            : const Text('Continue'),
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
                        child: const Text('Restore purchases'),
                      ),
                      Text(
                        'Subscription renews automatically until cancelled. '
                        'Manage or cancel anytime in your store account. '
                        '${AppConstants.valueDisclaimer}',
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
                      Text(plan.title,
                          style: Theme.of(context).textTheme.titleMedium),
                      if (plan.badge != null) ...[
                        const SizedBox(width: AppSpacing.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.gold,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Text(plan.badge!,
                              style: const TextStyle(
                                  color: Color(0xFF1A1400),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ],
                  ),
                  if (plan.trialLabel != null)
                    Text(plan.trialLabel!,
                        style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(plan.priceLabel,
                    style: Theme.of(context).textTheme.titleLarge),
                Text(plan.period,
                    style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
