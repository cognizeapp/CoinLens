import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/l10n_extensions.dart';
import '../../core/widgets/brand_mark.dart';
import '../../services/preferences/app_preferences.dart';
import '../../services/preferences/locale_provider.dart';
import '../../services/subscription/subscription_service.dart';
import '../auth/presentation/auth_providers.dart';

const _languageNames = <String, String>{
  'en': 'English',
  'it': 'Italiano',
  'es': 'Español',
  'fr': 'Français',
  'de': 'Deutsch',
  'pt': 'Português',
  'nl': 'Nederlands',
};

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final user = ref.watch(currentUserProvider);
    final status = ref.watch(subscriptionStatusProvider).valueOrNull ??
        SubscriptionStatus.free;
    final currency = ref.watch(currencyCodeProvider);
    final locale = ref.watch(localeProvider);
    final repo = ref.read(authRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BrandMark(size: 24),
            const SizedBox(width: AppSpacing.sm),
            Text(l.profileTitle),
          ],
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: CircleAvatar(
              radius: 34,
              backgroundColor: AppColors.goldSoft,
              child: Text(
                user?.initials ?? '?',
                style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 22,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: Text(
              user?.displayName ?? user?.email ?? l.profileGuest,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          if (user?.isAnonymous ?? false)
            Center(
              child: TextButton(
                onPressed: () => context.push('/sign-up'),
                child: Text(l.authCreateSyncHint),
              ),
            ),
          const SizedBox(height: AppSpacing.lg),
          _SectionHeader(l.sectionSubscription),
          ListTile(
            leading: Icon(
              status.isPremium
                  ? Icons.workspace_premium_rounded
                  : Icons.lock_open_rounded,
              color: AppColors.gold,
            ),
            title: Text(status.isPremium ? l.coinsightPremium : l.freePlan),
            subtitle: Text(status.isPremium
                ? (status.expiresAt != null
                    ? l.renewsOn(DateFormat.yMd(l.localeName)
                        .format(status.expiresAt!.toLocal()))
                    : l.subActive)
                : l.unlockBannerTitle),
            trailing: status.isPremium
                ? null
                : const Icon(Icons.chevron_right_rounded),
            onTap: status.isPremium ? null : () => context.push('/paywall'),
          ),
          ListTile(
            leading: const Icon(Icons.restore_rounded),
            title: Text(l.restorePurchases),
            onTap: () => ref.read(subscriptionServiceProvider).restore(),
          ),
          if (status.isPremium)
            ListTile(
              leading: const Icon(Icons.tune_rounded),
              title: Text(l.manageSubscription),
              subtitle: Text(l.manageSubscriptionBody),
              trailing: const Icon(Icons.open_in_new_rounded, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l.manageSubscriptionHint)),
                );
              },
            ),
          _SectionHeader(l.sectionPreferences),
          ListTile(
            leading: const Icon(Icons.euro_rounded),
            title: Text(l.currencyLabel),
            trailing: DropdownButton<String>(
              value: currency,
              underline: const SizedBox.shrink(),
              items: const ['EUR', 'USD', 'GBP', 'CHF']
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  ref.read(currencyCodeProvider.notifier).set(v);
                }
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language_rounded),
            title: Text(l.languageLabel),
            subtitle: Text(locale == null
                ? l.languageSystem
                : _languageNames[locale.languageCode] ?? locale.languageCode),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => _pickLanguage(context, ref, locale),
          ),
          ListTile(
            leading: const Icon(Icons.slideshow_rounded),
            title: Text(l.replayTutorial),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push('/tutorial'),
          ),
          _SectionHeader(l.sectionLegal),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(l.privacyPolicy),
            trailing: const Icon(Icons.open_in_new_rounded, size: 16),
            onTap: () => _open(AppConstants.privacyPolicyUrl),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(l.termsOfService),
            trailing: const Icon(Icons.open_in_new_rounded, size: 16),
            onTap: () => _open(AppConstants.termsOfServiceUrl),
          ),
          ListTile(
            leading: const Icon(Icons.help_outline_rounded),
            title: Text(l.helpAndSupport),
            trailing: const Icon(Icons.open_in_new_rounded, size: 16),
            onTap: () => _open(AppConstants.supportUrl),
          ),
          if (kDebugMode) ...[
            _SectionHeader(l.sectionDeveloper),
            SwitchListTile(
              secondary: const Icon(Icons.bug_report_outlined),
              title: Text(l.premiumDebugOverride),
              value: status.isPremium,
              onChanged: (v) =>
                  ref.read(subscriptionServiceProvider).debugSetPremium(v),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            child: OutlinedButton(
              onPressed: () => repo.signOut(),
              child: Text(l.signOut),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: TextButton(
              onPressed: () => _confirmDelete(context, ref),
              child: Text(l.deleteAccount,
                  style: const TextStyle(color: AppColors.danger)),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: Text('${AppConstants.appName} • v1.0.0',
                style: Theme.of(context).textTheme.labelSmall),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _pickLanguage(
      BuildContext context, WidgetRef ref, Locale? current) async {
    final l = context.l10n;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.backgroundSecondary,
      builder: (_) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(l.languageLabel,
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            RadioListTile<String?>(
              value: null,
              groupValue: current?.languageCode,
              title: Text(l.languageSystem),
              activeColor: AppColors.gold,
              onChanged: (_) {
                ref.read(localeProvider.notifier).set(null);
                Navigator.pop(context);
              },
            ),
            for (final entry in _languageNames.entries)
              RadioListTile<String?>(
                value: entry.key,
                groupValue: current?.languageCode,
                title: Text(entry.value),
                activeColor: AppColors.gold,
                onChanged: (_) {
                  ref.read(localeProvider.notifier).set(Locale(entry.key));
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardElevated,
        title: Text(l.deleteAccountTitle),
        content: Text(l.deleteAccountBody),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l.actionCancel)),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.actionDelete,
                style: const TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await ref.read(authRepositoryProvider).deleteAccount();
    }
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen, AppSpacing.lg, AppSpacing.screen, AppSpacing.sm),
      child: Text(title.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall),
    );
  }
}
