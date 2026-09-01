import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/catalog.dart';
import '../models/product.dart';
import 'product_source.dart';

/// dummyjson.com/products — alternatif kaynak. Şeması wantapi'den farklı
/// (`title`, `thumbnail`, sayısal `price`, `brand`, `category` ...); burada
/// uygulamanın [Product] modeline uyarlanır (adapter deseni).
class DummyJsonSource implements ProductSource {
  final http.Client _client;

  DummyJsonSource({http.Client? client}) : _client = client ?? http.Client();

  static final Uri _endpoint =
      Uri.parse('https://dummyjson.com/products?limit=30');

  @override
  String get label => 'DummyJSON';

  @override
  Future<Catalog> fetch() async {
    final response =
        await _client.get(_endpoint).timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      throw Exception('DummyJSON HTTP ${response.statusCode}');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final list = (json['products'] as List<dynamic>? ?? const []);
    final products = list
        .map((e) => _mapProduct(e as Map<String, dynamic>))
        .toList();
    return Catalog(
      meta: CatalogMeta(
        title: 'DummyJSON',
        description: 'dummyjson.com test verisi',
        count: products.length,
      ),
      products: products,
    );
  }

  Product _mapProduct(Map<String, dynamic> json) {
    final price = (json['price'] as num?)?.toDouble() ?? 0;
    final dims = json['dimensions'] as Map<String, dynamic>? ?? const {};
    return Product(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['title'] ?? '').toString(),
      tagline: (json['brand'] ?? json['category'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      priceLabel: '\$${price.round()}',
      currency: 'USD',
      imageUrl: (json['thumbnail'] ?? '').toString(),
      specs: {
        if (json['brand'] != null) 'brand': json['brand'].toString(),
        if (json['category'] != null) 'category': json['category'].toString(),
        if (json['rating'] != null) 'rating': json['rating'].toString(),
        if (dims['width'] != null)
          'size':
              '${dims['width']} x ${dims['height']} x ${dims['depth']}',
      },
    );
  }
}
