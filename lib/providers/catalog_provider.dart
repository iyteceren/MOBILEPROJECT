import 'package:flutter/foundation.dart';

import '../core/result.dart';
import '../data/models/catalog.dart';
import '../data/models/product.dart';
import '../data/product_repository.dart';
import '../data/sources/product_source.dart';

/// Katalog ekranının durumu: yükleme, sonuç, arama metni, kategori ve sıralama.
class CatalogProvider extends ChangeNotifier {
  CatalogProvider(this._repository);

  final ProductRepository _repository;

  bool _loading = false;
  Result<Catalog>? _result;
  String _query = '';
  String _category = 'Hepsi';
  ProductSort _sort = ProductSort.none;

  bool get loading => _loading;
  Result<Catalog>? get result => _result;
  String get query => _query;
  String get category => _category;
  ProductSort get sort => _sort;
  ProductSourceKind get sourceKind => _repository.sourceKind;

  CatalogMeta get meta => switch (_result) {
        Success(data: final c) => c.meta,
        _ => CatalogMeta.empty,
      };

  bool get fromCache =>
      _result is Success<Catalog> && (_result as Success<Catalog>).fromCache;

  List<Product> get allProducts => switch (_result) {
        Success(data: final c) => c.products,
        _ => const [],
      };

  List<String> get categories => [
        'Hepsi',
        ...{for (final p in allProducts) p.category},
      ];

  List<Product> get visibleProducts => applySearchAndSort(
        allProducts,
        query: _query,
        category: _category,
        sort: _sort,
      );

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    _result = await _repository.getCatalog();
    _loading = false;
    notifyListeners();
  }

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void setCategory(String value) {
    _category = value;
    notifyListeners();
  }

  void setSort(ProductSort value) {
    _sort = value;
    notifyListeners();
  }

  Future<void> setSource(ProductSourceKind kind) async {
    _repository.setSource(kind);
    await load();
  }
}
