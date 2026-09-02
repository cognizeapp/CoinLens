import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../services/preferences/app_preferences.dart';
import '../../services/subscription/subscription_service.dart';
import '../auth/presentation/auth_providers.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final status = ref.watch(subscriptionStatusProvider).valueOrNull ??
        SubscriptionStatus.free;
    final currency = ref.watch(currencyCodeProvider);
    final repo = ref.read(authRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
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
              user?.displayName ?? user?.email ?? 'Guest',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          if (user?.isAnonymous ?? false)
            Center(
              child: TextButton(
                onPressed: () => context.push('/sign-up'),
                child: const Text('Create an account to sync your collection'),
              ),
            ),
          const SizedBox(height: AppSpacing.lg),

          const _SectionHeader('Subscription'),
          ListTile(
            leading: Icon(
              status.isPremium ? Icons.workspace_premium_rounded : Icons.lock_open_rounded,
              color: AppColors.gold,
            ),
            title: Text(status.isPremium ? 'CoinLens Premium' : 'Free plan'),
            subtitle: Text(status.isPremium
                ? (status.expiresAt != null
                    ? 'Renews ${status.expiresAt!.toLocal().toString().split(' ').first}'
                    : 'Active')
                : 'Unlock AI Coin Intelligence'),
            trailing: status.isPremium
                ? null
                : const Icon(Icons.chevron_right_rounded),
            onTap: status.isPremium ? null : () => context.push('/paywall'),
          ),
          ListTile(
            leading: const Icon(Icons.restore_rounded),
            title: const Text('Restore purchases'),
            onTap: () => ref.read(subscriptionServiceProvider).restore(),
          ),
          if (status.isPremium)
            ListTile(
              leading: const Icon(Icons.tune_rounded),
              title: const Text('Manage subscription'),
              subtitle: const Text('Opens your App Store / Play Store settings'),
              trailing: const Icon(Icons.open_in_new_rounded, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                          'Manage or cancel from your store account settings.')),
                );
              },
            ),

          const _SectionHeader('Preferences'),
          ListTile(
            leading: const Icon(Icons.euro_rounded),
            title: const Text('Currency'),
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
          const ListTile(
            leading: Icon(Icons.language_rounded),
            title: Text('Language'),
            subtitle: Text('English (device default)'),
          ),

          const _SectionHeader('Legal'),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.open_in_new_rounded, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.open_in_new_rounded, size: 16),
            onTap: () {},
          ),

          if (kDebugMode) ...[
            const _SectionHeader('Developer'),
            SwitchListTile(
              secondary: const Icon(Icons.bug_report_outlined),
              title: const Text('Premium (debug override)'),
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
              child: const Text('Sign out'),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: TextButton(
              onPressed: () => _confirmDelete(context, ref),
              child: const Text('Delete account',
                  style: TextStyle(color: AppColors.danger)),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: Text('${AppConstants.appName} • v0.1.0',
                style: Theme.of(context).textTheme.labelSmall),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardElevated,
        title: const Text('Delete account?'),
        content: const Text(
            'This permanently deletes your account, scans and images. This '
            'cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete',
                style: TextStyle(color: AppColors.danger)),
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
