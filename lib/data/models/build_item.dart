import 'product.dart';

/// Kullanıcının kurulumundaki tek satır: bir ürün + adet.
class BuildItem {
  final Product product;
  int quantity;

  BuildItem({required this.product, this.quantity = 1});

  double get lineTotal => product.price * quantity;
}
