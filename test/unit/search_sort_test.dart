import 'package:cerengul_store/data/models/product.dart';
import 'package:cerengul_store/data/product_repository.dart';
import 'package:flutter_test/flutter_test.dart';

Product _p(int id, String name, double price) => Product(
      id: id,
      name: name,
      tagline: '',
      description: '',
      priceLabel: '\$${price.round()}',
      currency: 'USD',
      imageUrl: '',
      specs: const {},
    );

void main() {
  final products = [
    _p(1, 'iPhone 15 Pro', 999),
    _p(2, 'MacBook Air 13"', 1099),
    _p(3, 'iPad Air', 599),
    _p(4, 'AirPods Max', 549),
  ];

  test('arama isme göre filtreler', () {
    final r = applySearchAndSort(products, query: 'air');
    expect(r.map((p) => p.id), containsAll([2, 3, 4]));
    expect(r.any((p) => p.id == 1), isFalse);
  });

  test('kategori filtresi', () {
    final r = applySearchAndSort(products, category: 'Mac');
    expect(r.single.id, 2);
  });

  test('fiyat artan sıralama', () {
    final r = applySearchAndSort(products, sort: ProductSort.priceAsc);
    expect(r.map((p) => p.id).toList(), [4, 3, 1, 2]);
  });

  test('fiyat azalan sıralama', () {
    final r = applySearchAndSort(products, sort: ProductSort.priceDesc);
    expect(r.first.id, 2);
  });
}
