import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../services/connectivity/connectivity_service.dart';

/// Bottom-navigation scaffold hosting the five primary tabs. Uses go_router's
/// [StatefulNavigationShell] so each tab keeps its own navigation stack.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _tabs = <_TabSpec>[
    _TabSpec(Icons.home_rounded, Icons.home_outlined, 'Home'),
    _TabSpec(Icons.grid_view_rounded, Icons.grid_view_outlined, 'Collection'),
    _TabSpec(Icons.center_focus_strong_rounded,
        Icons.center_focus_strong_outlined, 'Scan'),
    _TabSpec(Icons.history_rounded, Icons.history_outlined, 'History'),
    _TabSpec(Icons.person_rounded, Icons.person_outline_rounded, 'Profile'),
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
                      Text('Offline — cached scans still work',
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
            for (var i = 0; i < _tabs.length; i++)
              NavigationDestination(
                icon: Icon(_tabs[i].outlined, color: AppColors.textTertiary),
                selectedIcon: Icon(_tabs[i].filled, color: AppColors.gold),
                label: _tabs[i].label,
              ),
          ],
        ),
      ),
    );
  }
}

class _TabSpec {
  const _TabSpec(this.filled, this.outlined, this.label);
  final IconData filled;
  final IconData outlined;
  final String label;
}
