import 'package:cerengul_store/data/models/product.dart';
import 'package:cerengul_store/providers/build_provider.dart';
import 'package:flutter_test/flutter_test.dart';

Product _p(int id, double price, {String name = 'Ürün'}) => Product(
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
  group('BuildProvider', () {
    test('ekleme toplamı ve adedi günceller', () {
      final b = BuildProvider()..setBudget(5000);
      b.add(_p(1, 999));
      b.add(_p(1, 999));
      expect(b.totalCount, 2);
      expect(b.spent, 1998);
      expect(b.remaining, 3002);
    });

    test('bütçe aşan ürün eklenmez', () {
      final b = BuildProvider()..setBudget(1000);
      expect(b.add(_p(1, 1200)), isFalse);
      expect(b.isEmpty, isTrue);
    });

    test('decrement son adette satırı siler', () {
      final b = BuildProvider()..setBudget(5000);
      b.add(_p(1, 500));
      b.decrement(_p(1, 500));
      expect(b.contains(_p(1, 500)), isFalse);
    });

    test('setBudget kurulumu sıfırlar', () {
      final b = BuildProvider()..setBudget(5000);
      b.add(_p(1, 500));
      b.setBudget(2000);
      expect(b.isEmpty, isTrue);
      expect(b.budget, 2000);
    });

    test('skor: çeşitlilik + bütçe kullanımı', () {
      final b = BuildProvider()..setBudget(1000);
      expect(b.score, 0);
      b.add(_p(1, 500, name: 'iPhone 15'));
      b.add(_p(2, 450, name: 'iPad Air'));
      // 2 kategori * 1.2 + kullanım %95 -> +3
      expect(b.score, closeTo(2 * 1.2 + 3, 0.001));
    });

    test('toSavedBuild anlık kopya üretir', () {
      final b = BuildProvider()..setBudget(3000);
      b.add(_p(1, 1000, name: 'iMac'));
      final saved = b.toSavedBuild();
      expect(saved.budget, 3000);
      expect(saved.spent, 1000);
      expect(saved.lines.single.product.id, 1);
    });
  });
}
