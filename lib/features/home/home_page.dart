import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/l10n_extensions.dart';
import '../../core/utils/money_provider.dart';
import '../../core/widgets/banner_ad_slot.dart';
import '../../core/widgets/brand_mark.dart';
import '../../core/widgets/glow_coin.dart';
import '../../core/widgets/gradient_scan_button.dart';
import '../../core/widgets/state_views.dart';
import '../../features/auth/presentation/auth_providers.dart';
import '../../features/coin/data/reference_coin_images.dart';
import '../../features/coin/presentation/coin_providers.dart';
import '../../features/coin/presentation/widgets/coin_widgets.dart';
import '../../features/rankings/rankings_providers.dart';
import '../../features/rankings/widgets/ranking_detail_sheet.dart';
import '../../services/subscription/subscription_service.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final isPremium = ref.watch(isPremiumProvider);
    final recent = ref.watch(recentScansProvider);
    final money = ref.watch(moneyFormatterProvider);
    final l = context.l10n;
    final greetingName = (user?.displayName?.trim().isNotEmpty ?? false)
        ? user!.displayName!.split(' ').first
        : null;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.gold,
          onRefresh: () async => ref.refresh(recentScansProvider.future),
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.screen),
            children: [
              Row(
                children: [
                  const BrandWordmark(height: 26),
                  if (isPremium) ...[
                    const Spacer(),
                    const _ProBadge(),
                  ],
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              _CoinHero(
                greeting: greetingName == null
                    ? l.homeWelcome
                    : l.homeWelcomeNamed(greetingName),
                tagline: l.appTagline,
              ),
              const SizedBox(height: AppSpacing.xl),
              GradientScanButton(onPressed: () => context.go('/scan')),
              const SizedBox(height: AppSpacing.xl),
              const _HowItWorks(),
              const SizedBox(height: AppSpacing.xl),
              const _RankingsPreview(),
              if (!isPremium) ...[
                const SizedBox(height: AppSpacing.xl),
                _PremiumBanner(onTap: () => context.push('/paywall')),
              ],
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l.recentScans,
                      style: Theme.of(context).textTheme.titleLarge),
                  TextButton(
                    onPressed: () => context.go('/history'),
                    child: Text(l.seeAll),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              recent.when(
                loading: () => Column(
                  children: List.generate(
                    3,
                    (_) => const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      child: ShimmerBox(height: 64, radius: 12),
                    ),
                  ),
                ),
                error: (_, __) => ErrorStateView(
                  message: l.historyLoadError,
                  onRetry: () => ref.refresh(recentScansProvider),
                ),
                data: (scans) {
                  if (scans.isEmpty) {
                    return EmptyStateView(
                      title: l.noScansYet,
                      subtitle: l.noScansYetBody,
                      icon: Icons.paid_outlined,
                    );
                  }
                  return Column(
                    children: [
                      for (final s in scans.take(4))
                        Card(
                          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: ScanListTile(
                            record: s,
                            money: money,
                            onTap: () => context.push('/result/${s.id}'),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                l.valueDisclaimer,
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const BannerAdSlot(),
            ],
          ),
        ),
      ),
    );
  }
}

/// The home banner: a warm greeting beside the Coinsights hero coin. The coin
/// is the "big graphic" of the screen — a soft glow with a slow float.
class _CoinHero extends StatelessWidget {
  const _CoinHero({required this.greeting, required this.tagline});

  final String greeting;
  final String tagline;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.lg, AppSpacing.md, AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF241A0A), AppColors.card],
        ),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontSize: 24),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  tagline,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          const GlowCoin(size: 96),
        ],
      ),
    );
  }
}

class _RankingsPreview extends ConsumerWidget {
  const _RankingsPreview();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final top = ref.watch(rankingProvider(RankingCategory.mostValuable));
    final money = ref.watch(moneyFormatterProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const Icon(Icons.emoji_events_rounded,
                      color: AppColors.gold, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Text(context.l10n.mostValuableCoins,
                      style: Theme.of(context).textTheme.titleMedium),
                ]),
                TextButton(
                  onPressed: () => context.push('/rankings'),
                  child: Text(context.l10n.seeAll),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            top.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: ShimmerBox(height: 40, radius: 8),
              ),
              error: (_, __) => const SizedBox.shrink(),
              data: (entries) => Column(
                children: [
                  for (var i = 0; i < entries.take(3).length; i++)
                    InkWell(
                      onTap: () => showRankingDetailSheet(context, entries[i]),
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                        child: Row(
                          children: [
                            Text('${i + 1}',
                                style: const TextStyle(
                                    color: AppColors.gold,
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(width: AppSpacing.sm),
                            CoinThumb(
                              size: 32,
                              material: entries[i].material,
                              rarity: entries[i].baseRarity,
                              label: shortDenomination(entries[i].denomination),
                              seed: entries[i].id,
                              referenceImageAsset:
                                  referenceCoinImageAsset(entries[i].id),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Text(entries[i].name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(money.compact(entries[i].baseValueEur),
                                style: const TextStyle(
                                    color: AppColors.gold,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProBadge extends StatelessWidget {
  const _ProBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.goldLight, AppColors.gold],
        ),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        context.l10n.premiumBadge,
        style: const TextStyle(
          color: AppColors.onGold,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _HowItWorks extends StatelessWidget {
  const _HowItWorks();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final steps = [
      ('1', l.howItWorksScan, l.howItWorksScanBody),
      ('2', l.howItWorksIdentify, l.howItWorksIdentifyBody),
      ('3', l.howItWorksValue, l.howItWorksValueBody),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.howItWorks, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.md),
            for (final (n, title, body) in steps)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 13,
                      backgroundColor: AppColors.goldSoft,
                      child: Text(n,
                          style: const TextStyle(
                              color: AppColors.gold,
                              fontWeight: FontWeight.w700,
                              fontSize: 12)),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title,
                              style: Theme.of(context).textTheme.titleMedium),
                          Text(body,
                              style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PremiumBanner extends StatelessWidget {
  const _PremiumBanner({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
          gradient: const LinearGradient(
            colors: [Color(0xFF211C0E), AppColors.card],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              const Icon(Icons.auto_awesome_rounded, color: AppColors.gold),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.l10n.unlockBannerTitle,
                        style: Theme.of(context).textTheme.titleMedium),
                    Text(context.l10n.unlockBannerBody,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
