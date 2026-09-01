import 'package:cerengul_store/data/models/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Map<String, dynamic> sample({String price = r'$999'}) => {
        'id': 1,
        'name': 'iPhone 15 Pro',
        'tagline': 'Titanium.',
        'description': 'desc',
        'price': price,
        'currency': 'USD',
        'image': 'https://wantapi.com/assets/images/iphone.png',
        'specs': {'chip': 'A17 Pro'},
      };

  test('fromJson alanları eşler', () {
    final p = Product.fromJson(sample());
    expect(p.id, 1);
    expect(p.name, 'iPhone 15 Pro');
    expect(p.priceLabel, r'$999');
    expect(p.imageUrl, contains('iphone.png'));
    expect(p.specs['chip'], 'A17 Pro');
  });

  test(r'"$999" -> 999.0 sayısal fiyat', () {
    expect(Product.fromJson(sample()).price, 999.0);
    expect(Product.fromJson(sample(price: r'$1,299')).price, 1299.0);
    expect(Product.fromJson(sample(price: '')).price, 0);
  });

  test('kategori isimden çıkarılır', () {
    Product withName(String name) => Product.fromJson(sample()..['name'] = name);
    expect(withName('iPhone 15').category, 'iPhone');
    expect(withName('MacBook Air 13"').category, 'Mac');
    expect(withName('iMac').category, 'Mac');
    expect(withName('Apple Watch Ultra 2').category, 'Watch');
    expect(withName('AirPods Max').category, 'Audio');
    expect(withName('Apple Vision Pro').category, 'Vision');
  });

  test('assetImage yerel yolu üretir', () {
    expect(Product.fromJson(sample()).assetImage, 'assets/images/iphone.png');
  });

  test('eşitlik id üzerinden', () {
    final a = Product.fromJson(sample());
    final b = Product.fromJson(sample()..['name'] = 'Farklı');
    expect(a, equals(b));
  });
}
