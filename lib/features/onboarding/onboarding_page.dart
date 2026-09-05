import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/l10n_extensions.dart';
import '../../core/widgets/brand_mark.dart';
import '../../l10n/app_localizations.dart';
import '../../services/analytics/analytics_service.dart';
import '../../services/preferences/app_preferences.dart';
import 'widgets/rarity_meter.dart';

class _Slide {
  const _Slide({
    required this.title,
    required this.accent,
    required this.subtitle,
    required this.hero,
  });

  /// Full headline; [accent] is the substring drawn in the brand colour.
  final String title;
  final String accent;
  final String subtitle;
  final WidgetBuilder hero;
}

List<_Slide> _slidesFor(AppLocalizations l) => [
      _Slide(
        title: l.ob1Title,
        accent: l.ob1Accent,
        subtitle: l.ob1Sub,
        hero: (_) => const _ValueCardHero(),
      ),
      _Slide(
        title: l.ob2Title,
        accent: l.ob2Accent,
        subtitle: l.ob2Sub,
        hero: (context) => RarityMeter(
          label: context.l10n.ob2MeterLabel,
          lowLabel: context.l10n.ob2MeterLow,
          highLabel: context.l10n.ob2MeterHigh,
        ),
      ),
      _Slide(
        title: l.ob3Title,
        accent: l.ob3Accent,
        subtitle: l.ob3Sub,
        hero: (_) => const _PortfolioHero(),
      ),
      _Slide(
        title: l.ob4Title,
        accent: l.ob4Accent,
        subtitle: l.ob4Sub,
        hero: (_) => const _StepsHero(),
      ),
    ];

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _complete() async {
    await ref.read(onboardingCompleteProvider.notifier).complete();
    await ref
        .read(analyticsServiceProvider)
        .logEvent(AnalyticsEvent.onboardingCompleted);
  }

  Future<void> _skip() async {
    await _complete();
    if (mounted) context.go('/');
  }

  Future<void> _next(int count) async {
    if (_index == count - 1) {
      await _complete();
      if (mounted) context.go('/paywall');
    } else {
      unawaited(_controller.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final slides = _slidesFor(l);
    final isLast = _index == slides.length - 1;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, 1.1),
            radius: 1.3,
            colors: [Color(0xFF3A2400), AppColors.background],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                child: Row(
                  children: [
                    const BrandWordmark(height: 22),
                    const Spacer(),
                    TextButton(onPressed: _skip, child: Text(l.actionSkip)),
                  ],
                ),
              ),
              _Progress(count: slides.length, index: _index),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: slides.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (context, i) => _SlideView(slide: slides[i]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.screen),
                child: FilledButton(
                  onPressed: () => _next(slides.length),
                  child: Text(isLast ? l.ob4Cta : l.actionContinue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Progress extends StatelessWidget {
  const _Progress({required this.count, required this.index});
  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: List.generate(count, (i) {
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: i <= index ? AppColors.gold : AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _SlideView extends StatelessWidget {
  const _SlideView({required this.slide});
  final _Slide slide;

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).textTheme.headlineMedium!.copyWith(
          fontSize: 30,
          height: 1.15,
          fontWeight: FontWeight.w800,
        );
    final parts = slide.title.split(slide.accent);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.lg),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: base,
              children: [
                if (parts.isNotEmpty) TextSpan(text: parts[0]),
                TextSpan(
                    text: slide.accent,
                    style: base.copyWith(color: AppColors.gold)),
                if (parts.length > 1) TextSpan(text: parts[1]),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            slide.subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: AppColors.textSecondary),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(child: slide.hero(context)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Heroes ──────────────────────────────────────────────────────────────────

class _ValueCardHero extends StatelessWidget {
  const _ValueCardHero();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Container(
      width: 300,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.15),
            blurRadius: 40,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                child: Image.asset('assets/coins/gb-sovereign.jpg',
                    width: 52, height: 52, fit: BoxFit.cover),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(l.ob1CoinName,
                    style: Theme.of(context).textTheme.titleMedium),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(l.ob1RefLabel,
              style: Theme.of(context).textTheme.labelSmall),
          const Text('€ 480',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AppColors.gold)),
        ],
      ),
    );
  }
}

class _PortfolioHero extends StatelessWidget {
  const _PortfolioHero();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Container(
      width: 300,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A1E08), AppColors.card],
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.portfolioLabel,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: AppColors.gold, letterSpacing: 1)),
          const SizedBox(height: 4),
          const Text('€ 3.240',
              style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary)),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _MiniStat(value: '128', label: l.portfolioCoins),
              const SizedBox(width: AppSpacing.xl),
              _MiniStat(value: '19', label: l.portfolioCountries),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.value, required this.label});
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      );
}

class _StepsHero extends StatelessWidget {
  const _StepsHero();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final steps = [
      (Icons.center_focus_strong_rounded, l.ob4Step1),
      (Icons.search_rounded, l.ob4Step2),
      (Icons.trending_up_rounded, l.ob4Step3),
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final (icon, text) in steps)
          Container(
            width: 300,
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: AppColors.goldSoft,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: AppColors.gold, size: 20),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(text,
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
