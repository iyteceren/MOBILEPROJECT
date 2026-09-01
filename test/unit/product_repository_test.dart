import 'package:cerengul_store/core/result.dart';
import 'package:cerengul_store/data/models/catalog.dart';
import 'package:cerengul_store/data/product_repository.dart';
import 'package:cerengul_store/data/sources/dummyjson_source.dart';
import 'package:cerengul_store/data/sources/product_source.dart';
import 'package:cerengul_store/data/sources/wantapi_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const _wantApiBody = '''
{
  "status": "success",
  "meta": { "title": "T", "description": "D", "count": 1 },
  "data": [
    { "id": 1, "name": "iPhone 15 Pro", "tagline": "t", "description": "d",
      "price": "\$999", "currency": "USD",
      "image": "https://wantapi.com/assets/images/iphone.png",
      "specs": { "chip": "A17 Pro" } }
  ]
}
''';

const _dummyBody = '''
{ "products": [
  { "id": 5, "title": "Phone X", "description": "d", "category": "smartphones",
    "price": 499.99, "brand": "Acme", "rating": 4.5,
    "thumbnail": "https://x/y.jpg",
    "dimensions": { "width": 1, "height": 2, "depth": 3 } }
] }
''';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('WantApiSource yanıtı ayrıştırır', () async {
    final source = WantApiSource(
      client: MockClient((_) async => http.Response(_wantApiBody, 200)),
    );
    final catalog = await source.fetch();
    expect(catalog.meta.count, 1);
    expect(catalog.products.single.name, 'iPhone 15 Pro');
    expect(catalog.products.single.price, 999.0);
  });

  test('DummyJsonSource farklı şemayı Product\'a uyarlar', () async {
    final source = DummyJsonSource(
      client: MockClient((_) async => http.Response(_dummyBody, 200)),
    );
    final catalog = await source.fetch();
    final p = catalog.products.single;
    expect(p.id, 5);
    expect(p.name, 'Phone X');
    expect(p.priceLabel, r'$500');
    expect(p.specs['brand'], 'Acme');
  });

  test('uzak kaynak hata verince yerel asset\'e düşer', () async {
    final repo = ProductRepository(
      wantApi: _ThrowingSource(),
    );
    final result = await repo.getCatalog();
    expect(result, isA<Success<Catalog>>());
    final success = result as Success<Catalog>;
    expect(success.fromCache, isTrue);
    expect(success.data.products, isNotEmpty);
  });
}

class _ThrowingSource implements ProductSource {
  @override
  String get label => 'throwing';
  @override
  Future<Catalog> fetch() async => throw Exception('network down');
}
