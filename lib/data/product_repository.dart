import '../core/result.dart';
import 'models/catalog.dart';
import 'models/product.dart';
import 'sources/dummyjson_source.dart';
import 'sources/local_asset_source.dart';
import 'sources/product_source.dart';
import 'sources/wantapi_source.dart';

/// Ürün verisinin tek giriş noktası.
///
/// Seçili uzak kaynağı (wantapi / DummyJSON) dener; hata olursa yerel asset
/// kaynağına düşer ve sonucu `fromCache: true` ile işaretler. UI kaynakların
/// varlığından habersizdir, yalnızca [Result] alır.
class ProductRepository {
  ProductRepository({
    ProductSource? wantApi,
    ProductSource? dummyJson,
    ProductSource? local,
  })  : _wantApi = wantApi ?? WantApiSource(),
        _dummyJson = dummyJson ?? DummyJsonSource(),
        _local = local ?? LocalAssetSource();

  final ProductSource _wantApi;
  final ProductSource _dummyJson;
  final ProductSource _local;

  ProductSourceKind _kind = ProductSourceKind.wantApi;

  ProductSourceKind get sourceKind => _kind;

  void setSource(ProductSourceKind kind) => _kind = kind;

  ProductSource get _active => switch (_kind) {
        ProductSourceKind.wantApi => _wantApi,
        ProductSourceKind.dummyJson => _dummyJson,
      };

  Future<Result<Catalog>> getCatalog() async {
    try {
      final catalog = await _active.fetch();
      return Success(catalog);
    } catch (remoteError) {
      try {
        final fallback = await _local.fetch();
        return Success(fallback, fromCache: true);
      } catch (localError) {
        return Failure('Veri yüklenemedi', error: localError);
      }
    }
  }
}

/// Katalogta arama + sıralama yardımcıları (saf fonksiyonlar; test edilebilir).
enum ProductSort { none, priceAsc, priceDesc, nameAsc }

List<Product> applySearchAndSort(
  List<Product> products, {
  String query = '',
  String category = 'Hepsi',
  ProductSort sort = ProductSort.none,
}) {
  final q = query.trim().toLowerCase();
  var list = products.where((p) {
    final matchesQuery = q.isEmpty ||
        p.name.toLowerCase().contains(q) ||
        p.tagline.toLowerCase().contains(q);
    final matchesCategory = category == 'Hepsi' || p.category == category;
    return matchesQuery && matchesCategory;
  }).toList();

  switch (sort) {
    case ProductSort.priceAsc:
      list.sort((a, b) => a.price.compareTo(b.price));
    case ProductSort.priceDesc:
      list.sort((a, b) => b.price.compareTo(a.price));
    case ProductSort.nameAsc:
      list.sort((a, b) => a.name.compareTo(b.name));
    case ProductSort.none:
      break;
  }
  return list;
}
