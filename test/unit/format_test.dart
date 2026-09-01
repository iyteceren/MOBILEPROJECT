import 'package:cerengul_store/core/utils/format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatUsd', () {
    test('binlik ayırıcı ekler', () {
      expect(formatUsd(0), r'$0');
      expect(formatUsd(999), r'$999');
      expect(formatUsd(4680), r'$4,680');
      expect(formatUsd(1000000), r'$1,000,000');
    });

    test('negatif değeri işaretler', () {
      expect(formatUsd(-320), r'-$320');
    });

    test('yuvarlar', () {
      expect(formatUsd(1234.7), r'$1,235');
    });
  });
}
