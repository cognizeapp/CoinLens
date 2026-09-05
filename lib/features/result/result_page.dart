import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/l10n_extensions.dart';
import '../../core/utils/money_provider.dart';
import '../../core/widgets/state_views.dart';
import '../coin/domain/coin_models.dart';
import '../coin/presentation/coin_providers.dart';
import '../coin/presentation/widgets/coin_widgets.dart';
import '../sell/sell_guide_section.dart';
import '../../services/analytics/analytics_service.dart';
import '../../services/subscription/subscription_service.dart';
import 'widgets/locked_premium_section.dart';
import 'widgets/premium_analysis_section.dart';

class ResultPage extends ConsumerWidget {
  const ResultPage({super.key, required this.scanId});
  final String scanId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final scan = ref.watch(scanByIdProvider(scanId));
    final money = ref.watch(moneyFormatterProvider);
    final isPremium = ref.watch(isPremiumProvider);
    final loaded = scan.valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.resultTitle),
        actions: [
          if (loaded != null)
            IconButton(
              icon: const Icon(Icons.ios_share_rounded),
              tooltip: l.actionShare,
              onPressed: () {
                final id = loaded.identification;
                Share.share(l.shareCoinText(
                  id.coinName,
                  money.range(id.value.min, id.value.max),
                ));
              },
            ),
        ],
      ),
      body: scan.when(
        loading: () => LoadingView(message: l.loadingResult),
        error: (_, __) => ErrorStateView(
          message: l.resultOpenError,
          onRetry: () => ref.refresh(scanByIdProvider(scanId)),
        ),
        data: (record) {
          final id = record.identification;
          ref.listen(scanByIdProvider(scanId), (_, __) {});
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref
                .read(analyticsServiceProvider)
                .logEvent(AnalyticsEvent.valueResultViewed);
          });

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.screen),
            children: [
              Center(
                child: CoinThumb(
                  size: 112,
                  imagePath: record.frontImagePath,
                  material: id.material,
                  rarity: id.rarity,
                  label: shortDenomination(id.denomination),
                  seed: id.coinName,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: Text(id.coinName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  '${id.country}${id.year != null ? ' • ${id.year}' : ''}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Center(child: ConfidenceBadge(confidence: id.confidence)),
              const SizedBox(height: AppSpacing.xl),

              if (!id.isConfident) _LowConfidence(id: id),

              _ValueCard(id: id, money: money),
              if (id.value.factors.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                _ValueFactors(
                  factors: id.value.factors,
                  showAll: isPremium,
                  onUnlock: () => context.push('/paywall'),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              _DetailsCard(id: id),
              const SizedBox(height: AppSpacing.lg),

              SellGuideSection(
                typicalValueEur: id.value.typical,
                money: money,
                isPremium: isPremium,
                onUnlock: () => context.push('/paywall'),
              ),
              const SizedBox(height: AppSpacing.xl),

              _SaveToCollectionButton(record: record),
              const SizedBox(height: AppSpacing.xl),

              if (isPremium)
                PremiumAnalysisSection(record: record)
              else
                LockedPremiumSection(
                  onUnlock: () {
                    ref
                        .read(analyticsServiceProvider)
                        .logEvent(AnalyticsEvent.premiumPreviewViewed);
                    context.push('/paywall');
                  },
                ),

              const SizedBox(height: AppSpacing.xl),
              Text(l.valueDisclaimer,
                  style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: AppSpacing.sm),
              Text(l.gradingDisclaimer,
                  style: Theme.of(context).textTheme.labelSmall),
            ],
          );
        },
      ),
    );
  }
}

class _SaveToCollectionButton extends ConsumerStatefulWidget {
  const _SaveToCollectionButton({required this.record});
  final ScanRecord record;

  @override
  ConsumerState<_SaveToCollectionButton> createState() =>
      _SaveToCollectionButtonState();
}

class _SaveToCollectionButtonState
    extends ConsumerState<_SaveToCollectionButton> {
  late bool _saved = widget.record.savedToCollection;
  bool _busy = false;

  Future<void> _toggle() async {
    setState(() => _busy = true);
    final repo = ref.read(scanRepositoryProvider);
    final result = _saved
        ? await repo.removeFromCollection(widget.record.id)
        : await repo.addToCollection(widget.record.id);
    if (!mounted) return;
    result.when(
      ok: (_) {
        HapticFeedback.selectionClick();
        setState(() {
          _saved = !_saved;
          _busy = false;
        });
        ref.invalidate(collectionProvider);
        ref.invalidate(recentScansProvider);
        ref.invalidate(scanByIdProvider(widget.record.id));
        if (_saved) {
          ref
              .read(analyticsServiceProvider)
              .logEvent(AnalyticsEvent.collectionItemSaved);
        }
      },
      err: (f) {
        setState(() => _busy = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(f.localized(context.l10n))));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return _saved
        ? OutlinedButton.icon(
            onPressed: _busy ? null : _toggle,
            icon: const Icon(Icons.check_rounded, color: AppColors.success),
            label: Text(l.savedToCollection),
          )
        : FilledButton.icon(
            onPressed: _busy ? null : _toggle,
            icon: const Icon(Icons.add_rounded),
            label: Text(l.saveToCollection),
          );
  }
}

class _LowConfidence extends StatelessWidget {
  const _LowConfidence({required this.id});
  final CoinIdentification id;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.help_outline_rounded,
                color: AppColors.warning, size: 18),
            const SizedBox(width: AppSpacing.sm),
            Text(l.notConfidentMatch,
                style: Theme.of(context).textTheme.titleMedium),
          ]),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l.notConfidentBody,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final m in id.alternativeMatches)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Text(m.name)),
                  Text('${(m.confidence * 100).round()}%',
                      style: const TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ValueCard extends StatelessWidget {
  const _ValueCard({required this.id, required this.money});
  final CoinIdentification id;
  final MoneyFormatter money;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.35)),
        gradient: const LinearGradient(
          colors: [Color(0xFF1E1B10), AppColors.card],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          Text(context.l10n.estimatedMarketValue,
              style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: AppSpacing.sm),
          Text(money.range(id.value.min, id.value.max),
              style: AppTypography.valueHero),
          const SizedBox(height: AppSpacing.xs),
          Text(
              context.l10n.typicalEstimate(money.single(id.value.typical)),
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _ValueFactors extends StatelessWidget {
  const _ValueFactors({
    required this.factors,
    required this.showAll,
    required this.onUnlock,
  });

  final List<ValueFactor> factors;
  final bool showAll;
  final VoidCallback onUnlock;

  IconData _icon(ValueImpact i) => switch (i) {
        ValueImpact.positive => Icons.trending_up_rounded,
        ValueImpact.negative => Icons.trending_down_rounded,
        ValueImpact.neutral => Icons.remove_rounded,
      };

  Color _color(ValueImpact i) => switch (i) {
        ValueImpact.positive => AppColors.success,
        ValueImpact.negative => AppColors.danger,
        ValueImpact.neutral => AppColors.textTertiary,
      };

  @override
  Widget build(BuildContext context) {
    final visible = showAll ? factors : factors.take(2).toList();
    final hidden = factors.length - visible.length;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.whatAffectsValue,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          for (final f in visible)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(_icon(f.impact), size: 16, color: _color(f.impact)),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: '${f.label}. ',
                            style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600),
                          ),
                          TextSpan(text: f.detail),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (!showAll && hidden > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            InkWell(
              onTap: onUnlock,
              child: Row(
                children: [
                  const Icon(Icons.lock_outline_rounded,
                      size: 15, color: AppColors.gold),
                  const SizedBox(width: 6),
                  Text(context.l10n.moreInFullAnalysis(hidden),
                      style: const TextStyle(
                          color: AppColors.gold,
                          fontSize: 13,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.id});
  final CoinIdentification id;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final rows = <(String, String)>[
      (l.detailCountry, id.country),
      if (id.year != null) (l.detailYear, '${id.year}'),
      (l.detailDenomination, id.denomination),
      (l.detailMaterial, id.material),
      if (id.mint != null) (l.detailMint, id.mint!),
      if (id.diameterMm != null) (l.detailDiameter, '${id.diameterMm} mm'),
      if (id.weightG != null) (l.detailWeight, '${id.weightG} g'),
      (l.detailConditionEst, id.condition.localizedLabel(l)),
    ];
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          for (final (k, v) in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(k, style: Theme.of(context).textTheme.bodyMedium),
                  Text(v, style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l.detailRarityEst,
                  style: Theme.of(context).textTheme.bodyMedium),
              RarityChip(rarity: id.rarity),
            ],
          ),
        ],
      ),
    );
  }
}
