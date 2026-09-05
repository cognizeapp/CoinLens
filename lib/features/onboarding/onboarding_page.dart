import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/l10n_extensions.dart';
import '../../core/widgets/brand_mark.dart';
import '../../core/widgets/glow_coin.dart';
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
        hero: (_) => const _CoinValueHero(),
      ),
      _Slide(
        title: l.ob2Title,
        accent: l.ob2Accent,
        subtitle: l.ob2Sub,
        hero: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _Art('assets/brand/coin_hero.png', size: 100),
            const SizedBox(height: AppSpacing.sm),
            _HeroCard(
              child: RarityMeter(
                label: context.l10n.ob2MeterLabel,
                lowLabel: context.l10n.ob2MeterLow,
                highLabel: context.l10n.ob2MeterHigh,
              ),
            ),
          ],
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
  const OnboardingPage({super.key, this.replay = false});

  /// `true` when opened from Profile → "Replay intro": nothing to persist,
  /// and finishing/skipping just returns to where the user came from.
  final bool replay;

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
    if (widget.replay) return;
    await ref.read(onboardingCompleteProvider.notifier).complete();
    await ref
        .read(analyticsServiceProvider)
        .logEvent(AnalyticsEvent.onboardingCompleted);
  }

  void _leave() {
    if (widget.replay) {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/');
      }
    } else {
      context.go('/paywall');
    }
  }

  Future<void> _skip() async {
    await _complete();
    if (!mounted) return;
    if (widget.replay) {
      _leave();
    } else {
      context.go('/');
    }
  }

  Future<void> _next(int count) async {
    if (_index == count - 1) {
      await _complete();
      if (mounted) _leave();
    } else {
      unawaited(_controller.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final slides = _slidesFor(l);
    final isLast = _index == slides.length - 1;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Layered brand backdrop.
          const Positioned.fill(child: _Backdrop()),
          Positioned.fill(
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
                        TextButton(
                          onPressed: _skip,
                          child: Text(l.actionSkip,
                              style: const TextStyle(
                                  color: AppColors.textSecondary)),
                        ),
                      ],
                    ),
                  ),
                  _Progress(count: slides.length, index: _index),
                  const SizedBox(height: AppSpacing.sm),
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: slides.length,
                      onPageChanged: (i) => setState(() => _index = i),
                      itemBuilder: (context, i) =>
                          _SlideView(slide: slides[i], active: i == _index),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.screen,
                        AppSpacing.sm, AppSpacing.screen, AppSpacing.lg),
                    child: _CtaButton(
                      label: isLast ? l.ob4Cta : l.actionContinue,
                      onPressed: () => _next(slides.length),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Backdrop extends StatelessWidget {
  const _Backdrop();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: AppColors.background),
      child: Stack(
        children: [
          // Warm bloom rising from the bottom.
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, 1.15),
                  radius: 1.25,
                  colors: [Color(0xFF3E2600), AppColors.background],
                  stops: [0.0, 0.85],
                ),
              ),
            ),
          ),
          // Faint top-right accent.
          Positioned(
            top: -120,
            right: -120,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.gold.withValues(alpha: 0.14),
                    AppColors.gold.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
        ],
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
          final done = i <= index;
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              height: 5,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: done ? AppColors.gold : AppColors.border,
                borderRadius: BorderRadius.circular(3),
                boxShadow: done
                    ? [
                        BoxShadow(
                          color: AppColors.gold.withValues(alpha: 0.4),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _SlideView extends StatelessWidget {
  const _SlideView({required this.slide, required this.active});
  final _Slide slide;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).textTheme.headlineMedium!.copyWith(
          fontSize: 31,
          height: 1.12,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
        );
    final parts = slide.title.split(slide.accent);

    return AnimatedSlide(
      offset: active ? Offset.zero : const Offset(0, 0.05),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: active ? 1 : 0.35,
        duration: const Duration(milliseconds: 380),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: Center(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      child: slide.hero(context),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
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
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CtaButton extends StatelessWidget {
  const _CtaButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            gradient: const LinearGradient(
              colors: [AppColors.goldLight, AppColors.gold],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.3),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.onGold,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                const Icon(Icons.arrow_forward_rounded,
                    color: AppColors.onGold, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Heroes ──────────────────────────────────────────────────────────────────

/// A brand illustration (coin / stack / trio) on a soft orange halo.
class _Art extends StatelessWidget {
  const _Art(this.asset, {this.size = 150, this.aspect = 1});
  final String asset;
  final double size;

  /// width / height of the source art, so the glow behind it is proportioned.
  final double aspect;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            AppColors.gold.withValues(alpha: 0.20),
            AppColors.gold.withValues(alpha: 0),
          ],
          stops: const [0.05, 0.75],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size * 0.12, vertical: size * 0.12 / aspect),
        child: Image.asset(asset, width: size, fit: BoxFit.contain),
      ),
    );
  }
}

/// Shared framing for the flat "info card" heroes (rarity meter, portfolio).
class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF241A0A), AppColors.card],
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.12),
            blurRadius: 44,
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Slide 1 — the hero coin with a floating reference-value tag.
class _CoinValueHero extends StatelessWidget {
  const _CoinValueHero();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final w = MediaQuery.sizeOf(context).width;
    final coin = (w - 120).clamp(150.0, 210.0);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: coin * 1.38,
          height: coin * 1.12,
          child: Stack(
            alignment: Alignment.center,
            children: [
              GlowCoin(size: coin),
              Align(
                alignment: const Alignment(1, -0.5),
                child: _Tag(label: l.ob1RefLabel, value: '€ 480'),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _Pill(text: l.ob1CoinName),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 148),
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              maxLines: 2,
              style: const TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 8.5,
                  height: 1.15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5)),
          const SizedBox(height: 2),
          Text(value,
              style: const TextStyle(
                  color: AppColors.gold,
                  fontSize: 19,
                  fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.verified_rounded,
              size: 13, color: AppColors.success),
          const SizedBox(width: 5),
          Text(text,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const _Art('assets/brand/coin_stack.png', size: 128),
        const SizedBox(height: AppSpacing.sm),
        _PortfolioCard(l: l),
      ],
    );
  }
}

class _PortfolioCard extends StatelessWidget {
  const _PortfolioCard({required this.l});
  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    return _HeroCard(
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
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5)),
          const SizedBox(height: AppSpacing.lg),
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
                  fontSize: 17,
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
        const _Art('assets/brand/coin_trio.png', size: 150, aspect: 1.28),
        const SizedBox(height: AppSpacing.sm),
        for (final (icon, text) in steps)
          Container(
            width: 300,
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: 10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF20180A), AppColors.card],
              ),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.goldSoft,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: AppColors.gold, size: 18),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child:
                      Text(text, style: Theme.of(context).textTheme.bodyMedium),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
