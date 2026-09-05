import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../../../l10n/app_localizations.dart';
import '../../coin/domain/catalog_entry.dart';
import '../../coin/domain/coin_models.dart';
import '../../coin/presentation/coin_providers.dart';
import '../../../services/analytics/analytics_service.dart';

/// Lets the user correct what the scan thinks the coin is. They pick the
/// country, the coin type and the year; the value is then recomputed from the
/// verified catalogue entry instead of a low-confidence guess. The corrected
/// identification replaces the one on the scan record.
Future<void> showCoinCorrectionSheet(
  BuildContext context,
  WidgetRef ref,
  ScanRecord record,
) async {
  final catalog = await ref.read(coinCatalogProvider).all();
  if (!context.mounted) return;
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.backgroundSecondary,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
    ),
    builder: (_) => _CorrectionSheet(record: record, catalog: catalog),
  );
}

class _CorrectionSheet extends ConsumerStatefulWidget {
  const _CorrectionSheet({required this.record, required this.catalog});
  final ScanRecord record;
  final List<CatalogEntry> catalog;

  @override
  ConsumerState<_CorrectionSheet> createState() => _CorrectionSheetState();
}

class _CorrectionSheetState extends ConsumerState<_CorrectionSheet> {
  String _query = '';
  String? _country;
  CatalogEntry? _entry;
  final _yearCtrl = TextEditingController();
  bool _saving = false;
  String? _yearError;

  @override
  void initState() {
    super.initState();
    final y = widget.record.identification.year;
    if (y != null) _yearCtrl.text = '$y';
  }

  @override
  void dispose() {
    _yearCtrl.dispose();
    super.dispose();
  }

  List<String> get _countries {
    final set = {for (final e in widget.catalog) e.country}.toList()..sort();
    if (_query.isEmpty) return set;
    final q = _query.toLowerCase();
    return set.where((c) => c.toLowerCase().contains(q)).toList();
  }

  List<CatalogEntry> get _typesForCountry {
    final list =
        widget.catalog.where((e) => e.country == _country).toList()
          ..sort((a, b) => a.name.compareTo(b.name));
    return list;
  }

  Future<void> _save() async {
    final entry = _entry!;
    final raw = _yearCtrl.text.trim();
    int? year;
    if (raw.isNotEmpty) {
      year = int.tryParse(raw);
      if (year == null ||
          year < entry.yearFrom ||
          year > entry.yearTo) {
        setState(() => _yearError =
            context.l10n.correctYearRange('${entry.yearFrom}', '${entry.yearTo}'));
        return;
      }
    }

    setState(() {
      _saving = true;
      _yearError = null;
    });

    final rarity = _rarityFor(entry, year);
    final condition = widget.record.identification.condition;
    final value = ref.read(valueEstimationServiceProvider).estimate(
          entry: entry,
          year: year,
          condition: condition,
          rarity: rarity,
          mint: null,
        );

    final corrected = CoinIdentification(
      coinName: year != null ? '${entry.name} · $year' : entry.name,
      country: entry.country,
      year: year,
      denomination: entry.denomination,
      material: entry.material,
      condition: condition,
      rarity: rarity,
      confidence: 1.0,
      value: value,
      diameterMm: entry.diameterMm,
      weightG: entry.weightG,
    );

    final repo = ref.read(scanRepositoryProvider);
    await repo.saveScan(widget.record.copyWith(identification: corrected));
    ref.invalidate(scanByIdProvider(widget.record.id));
    ref.invalidate(collectionProvider);
    ref.invalidate(recentScansProvider);
    unawaited(ref.read(analyticsServiceProvider).logEvent(
          AnalyticsEvent.coinIdentified,
          params: const {'corrected': true},
        ));

    if (mounted) {
      unawaited(HapticFeedback.mediumImpact());
      Navigator.pop(context);
    }
  }

  static CoinRarity _rarityFor(CatalogEntry entry, int? year) {
    if (entry.isKeyDate(year)) {
      final next = entry.baseRarity.index + 1;
      return CoinRarity.values[
          next.clamp(0, CoinRarity.values.length - 1)];
    }
    return entry.baseRarity;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.92,
        builder: (context, scrollController) {
          return Column(
            children: [
              const SizedBox(height: AppSpacing.sm),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md,
                    AppSpacing.lg, AppSpacing.sm),
                child: Row(
                  children: [
                    if (_country != null)
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded),
                        onPressed: () => setState(() {
                          if (_entry != null) {
                            _entry = null;
                          } else {
                            _country = null;
                          }
                        }),
                      ),
                    Expanded(
                      child: Text(
                        _entry != null
                            ? l.correctYearTitle
                            : _country != null
                                ? l.correctTypeTitle
                                : l.correctCountryTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: _body(context, scrollController, l)),
            ],
          );
        },
      ),
    );
  }

  Widget _body(BuildContext context, ScrollController sc, AppLocalizations l) {
    if (_entry != null) {
      return SingleChildScrollView(
        controller: sc,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_entry!.name,
                style: Theme.of(context).textTheme.titleLarge),
            Text('${_entry!.country} · ${_entry!.denomination}',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _yearCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              decoration: InputDecoration(
                labelText: l.correctYearLabel,
                hintText: '${_entry!.yearFrom}–${_entry!.yearTo}',
                errorText: _yearError,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppColors.onGold))
                    : Text(l.correctSave),
              ),
            ),
          ],
        ),
      );
    }

    if (_country != null) {
      final types = _typesForCountry;
      return ListView.builder(
        controller: sc,
        itemCount: types.length,
        itemBuilder: (context, i) {
          final e = types[i];
          return ListTile(
            title: Text(e.name),
            subtitle: Text('${e.denomination} · ${e.material}',
                maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => setState(() => _entry = e),
          );
        },
      );
    }

    final countries = _countries;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: TextField(
            onChanged: (v) => setState(() => _query = v),
            decoration: InputDecoration(
              hintText: l.correctSearchCountry,
              prefixIcon: const Icon(Icons.search_rounded),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Expanded(
          child: ListView.builder(
            controller: sc,
            itemCount: countries.length,
            itemBuilder: (context, i) => ListTile(
              title: Text(countries[i]),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => setState(() {
                _country = countries[i];
                _query = '';
              }),
            ),
          ),
        ),
      ],
    );
  }
}
