import 'package:json_annotation/json_annotation.dart';

import 'product.dart';

part 'catalog.g.dart';

/// products.php yanıtındaki `meta` bloğu.
@JsonSerializable(createToJson: false)
class CatalogMeta {
  final String title;
  final String description;
  final int count;

  const CatalogMeta({
    required this.title,
    required this.description,
    required this.count,
  });

  factory CatalogMeta.fromJson(Map<String, dynamic> json) =>
      _$CatalogMetaFromJson(json);

  static const empty = CatalogMeta(title: '', description: '', count: 0);
}

/// Katalog = meta + ürün listesi.
class Catalog {
  final CatalogMeta meta;
  final List<Product> products;

  const Catalog({required this.meta, required this.products});

  factory Catalog.fromWantApi(Map<String, dynamic> json) {
    final metaJson = json['meta'];
    final data = (json['data'] as List<dynamic>? ?? const []);
    return Catalog(
      meta: metaJson is Map<String, dynamic>
          ? CatalogMeta.fromJson(metaJson)
          : CatalogMeta.empty,
      products: data
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
