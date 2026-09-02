import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../coin/domain/coin_models.dart';
import '../../ai/ai_providers.dart';
import '../../ai/coin_intelligence.dart';

/// Premium result content (product spec §14). The AI analysis is generated only
/// after the user explicitly asks (product spec §32 — never auto-run), from the
/// structured identification.
class PremiumAnalysisSection extends ConsumerWidget {
  const PremiumAnalysisSection({super.key, required this.record});
  final ScanRecord record;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requested =
        ref.watch(aiAnalysisRequestedProvider(record.id));

    if (!requested) {
      return _GenerateCta(
        onGenerate: () => ref
            .read(aiAnalysisRequestedProvider(record.id).notifier)
            .state = true,
        onAssistant: () => context.push('/result/${record.id}/assistant'),
      );
    }

    final analysis = ref.watch(coinIntelligenceProvider(record.identification));

    return analysis.when(
      loading: () => const _GeneratingCard(),
      error: (_, __) => Column(
        children: [
          Text('AI analysis is temporarily unavailable.',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton(
            onPressed: () =>
                ref.refresh(coinIntelligenceProvider(record.identification)),
            child: const Text('Retry'),
          ),
        ],
      ),
      data: (ci) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(title: 'Coin Story', body: ci.historicalContext),
          _Section(title: 'Why It Has Value', body: ci.valueAnalysis),
          _Section(
            title: 'Rarity Analysis',
            body: ci.rarityExplanation,
            badge: record.identification.rarity.label,
          ),
          _Section(
            title: 'Condition Estimate',
            body: ci.conditionExplanation,
            badge: record.identification.condition.label,
          ),
          _SellingCard(strategy: ci.sellingStrategy),
          _Section(title: 'Collector Insights', body: ci.collectorInsights),
          const SizedBox(height: AppSpacing.sm),
          FilledButton.icon(
            onPressed: () => context.push('/result/${record.id}/assistant'),
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            label: const Text('Ask the AI assistant'),
          ),
        ],
      ),
    );
  }
}

class _GenerateCta extends StatelessWidget {
  const _GenerateCta({required this.onGenerate, required this.onAssistant});
  final VoidCallback onGenerate;
  final VoidCallback onAssistant;

  @override
  Widget build(BuildContext context) {
    const bullets = [
      ('📜', 'Coin story & historical context'),
      ('💎', 'Why it has value, factor by factor'),
      ('📊', 'Rarity & condition analysis'),
      ('💰', 'Selling strategy & pricing'),
    ];
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
        gradient: const LinearGradient(
          colors: [Color(0xFF211C0E), AppColors.card],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.auto_awesome_rounded, color: AppColors.gold),
            const SizedBox(width: AppSpacing.sm),
            Text('AI Coin Intelligence',
                style: Theme.of(context).textTheme.titleLarge),
          ]),
          const SizedBox(height: AppSpacing.md),
          for (final (e, t) in bullets)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(children: [
                Text(e),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                    child: Text(t,
                        style: Theme.of(context).textTheme.bodyMedium)),
              ]),
            ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: onGenerate,
            child: const Text('Generate AI analysis'),
          ),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton.icon(
            onPressed: onAssistant,
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            label: const Text('Ask the AI assistant'),
          ),
        ],
      ),
    );
  }
}

class _GeneratingCard extends StatelessWidget {
  const _GeneratingCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child:
                CircularProgressIndicator(strokeWidth: 2, color: AppColors.gold),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text('Generating your AI coin analysis…',
                style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body, this.badge});
  final String title;
  final String body;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title,
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.goldSoft,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(badge!,
                      style: const TextStyle(
                          color: AppColors.gold,
                          fontWeight: FontWeight.w600,
                          fontSize: 12)),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(body, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class _SellingCard extends StatelessWidget {
  const _SellingCard({required this.strategy});
  final SellingStrategy strategy;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Selling Recommendations',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.md),
          _kv(context, 'Estimated selling price', strategy.estimatedSaleRange),
          _kv(context, 'Suggested listing price', strategy.suggestedListPrice),
          _kv(context, 'Minimum reasonable price', strategy.minimumPrice),
          _kv(context, 'Where to sell', strategy.recommendedPlatforms),
          _kv(context, 'Auction suitable?', strategy.auctionAdvice),
          _kv(context, 'Professional appraisal', strategy.appraisalAdvice),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.danger.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.warning_amber_rounded,
                    color: AppColors.danger, size: 18),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(strategy.cleaningWarning,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.textPrimary)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _kv(BuildContext context, String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(k, style: Theme.of(context).textTheme.labelSmall),
            Text(v, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      );
}
