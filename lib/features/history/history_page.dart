import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/utils/money_provider.dart';
import '../../core/widgets/state_views.dart';
import '../coin/presentation/coin_providers.dart';
import '../coin/presentation/widgets/coin_widgets.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scans = ref.watch(recentScansProvider);
    final money = ref.watch(moneyFormatterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: scans.when(
        loading: () => ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: List.generate(
            6,
            (_) => const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: ShimmerBox(height: 64, radius: 12),
            ),
          ),
        ),
        error: (_, __) => ErrorStateView(
          message: 'Could not load your scan history.',
          onRetry: () => ref.refresh(recentScansProvider),
        ),
        data: (list) {
          if (list.isEmpty) {
            return EmptyStateView(
              title: 'Nothing scanned yet',
              subtitle: 'Scan a coin to start building your history.',
              icon: Icons.history_rounded,
              action: FilledButton(
                onPressed: () => context.go('/scan'),
                child: const Text('Scan a Coin'),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.refresh(recentScansProvider.future),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              itemCount: list.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, i) => ScanListTile(
                record: list[i],
                money: money,
                onTap: () => context.push('/result/${list[i].id}'),
              ),
            ),
          );
        },
      ),
    );
  }
}
