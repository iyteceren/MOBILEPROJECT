import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

/// Bir ürün. Alan eşlemesi `json_serializable` ile üretilir
/// (`dart run build_runner build`).
///
/// wantapi `price` alanını "$999" gibi metin döndürür; ham hali [priceLabel]'de
/// tutulur, hesaplanabilir sayısal hali [price] getter'ıyla türetilir.
@JsonSerializable()
class Product {
  final int id;
  final String name;
  final String tagline;
  final String description;

  @JsonKey(name: 'price')
  final String priceLabel;

  final String currency;

  @JsonKey(name: 'image')
  final String imageUrl;

  final Map<String, String> specs;

  const Product({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.priceLabel,
    required this.currency,
    required this.imageUrl,
    required this.specs,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  /// "$999" -> 999.0
  double get price {
    final text = priceLabel.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(text) ?? 0;
  }

  Product copyWith({
    String? tagline,
    String? imageUrl,
    Map<String, String>? specs,
  }) {
    return Product(
      id: id,
      name: name,
      tagline: tagline ?? this.tagline,
      description: description,
      priceLabel: priceLabel,
      currency: currency,
      imageUrl: imageUrl ?? this.imageUrl,
      specs: specs ?? this.specs,
    );
  }

  /// Ürün adından çıkarılan kategori; katalog filtreleri bunu kullanır.
  String get category {
    final n = name.toLowerCase();
    if (n.contains('iphone')) return 'iPhone';
    if (n.contains('macbook') || n.contains('imac')) return 'Mac';
    if (n.contains('ipad')) return 'iPad';
    if (n.contains('watch')) return 'Watch';
    if (n.contains('vision')) return 'Vision';
    if (n.contains('airpods') || n.contains('homepod')) return 'Audio';
    return 'Diğer';
  }

  /// wantapi görsellerinin yerel asset karşılığı (çevrimdışı gösterim için).
  String get assetImage {
    final file = imageUrl.isEmpty ? '' : Uri.parse(imageUrl).pathSegments.last;
    return file.isEmpty ? '' : 'assets/images/$file';
  }

  @override
  bool operator ==(Object other) => other is Product && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
