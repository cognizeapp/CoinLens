import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/l10n_extensions.dart';
import '../../services/connectivity/connectivity_service.dart';

/// Bottom-navigation scaffold hosting the five primary tabs. Uses go_router's
/// [StatefulNavigationShell] so each tab keeps its own navigation stack.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _icons = <(IconData, IconData)>[
    (Icons.home_rounded, Icons.home_outlined),
    (Icons.grid_view_rounded, Icons.grid_view_outlined),
    (Icons.center_focus_strong_rounded, Icons.center_focus_strong_outlined),
    (Icons.history_rounded, Icons.history_outlined),
    (Icons.person_rounded, Icons.person_outline_rounded),
  ];

  void _goto(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = navigationShell.currentIndex;
    final online = ref.watch(isOnlineProvider);
    final l = context.l10n;
    final labels = [l.navHome, l.navCollection, l.navScan, l.navHistory, l.navProfile];
    return Scaffold(
      body: Column(
        children: [
          if (!online)
            Material(
              color: AppColors.warning.withValues(alpha: 0.15),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cloud_off_rounded,
                          size: 14, color: AppColors.warning),
                      const SizedBox(width: 6),
                      Text(l.offlineBanner,
                          style: Theme.of(context).textTheme.labelSmall),
                    ],
                  ),
                ),
              ),
            ),
          Expanded(child: navigationShell),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.divider)),
        ),
        child: NavigationBar(
          selectedIndex: current,
          onDestinationSelected: _goto,
          backgroundColor: AppColors.backgroundSecondary,
          indicatorColor: AppColors.goldSoft,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            for (var i = 0; i < _icons.length; i++)
              NavigationDestination(
                icon: Icon(_icons[i].$2, color: AppColors.textTertiary),
                selectedIcon: Icon(_icons[i].$1, color: AppColors.gold),
                label: labels[i],
              ),
          ],
        ),
      ),
    );
  }
}
