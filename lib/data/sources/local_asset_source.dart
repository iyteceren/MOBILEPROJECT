import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/catalog.dart';
import 'product_source.dart';

/// Uygulamayla birlikte gelen `assets/data/products.json`. Ağ erişilemediğinde
/// repository buna düşer; demo internetsiz de çalışır (asset yönetimi örneği).
class LocalAssetSource implements ProductSource {
  static const _path = 'assets/data/products.json';

  @override
  String get label => 'Yerel veri';

  @override
  Future<Catalog> fetch() async {
    final raw = await rootBundle.loadString(_path);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return Catalog.fromWantApi(json);
  }
}
