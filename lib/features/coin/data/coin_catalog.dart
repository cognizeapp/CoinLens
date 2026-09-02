import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../domain/catalog_entry.dart';

/// Read access to the structured coin reference data. Backed by a bundled
/// JSON asset today; a networked catalog (with far more entries and live
/// pricing) drops in behind the same interface later.
abstract interface class CoinCatalog {
  Future<List<CatalogEntry>> all();
  Future<CatalogEntry?> byId(String id);
}

class AssetCoinCatalog implements CoinCatalog {
  AssetCoinCatalog({this.assetPath = 'assets/mock/coin_catalog.json'});

  final String assetPath;
  List<CatalogEntry>? _cache;

  Future<List<CatalogEntry>> _load() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString(assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final entries = (json['entries'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(CatalogEntry.fromJson)
        .toList(growable: false);
    return _cache = entries;
  }

  @override
  Future<List<CatalogEntry>> all() => _load();

  @override
  Future<CatalogEntry?> byId(String id) async {
    final entries = await _load();
    for (final e in entries) {
      if (e.id == id) return e;
    }
    return null;
  }
}
