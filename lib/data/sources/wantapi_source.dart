import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/catalog.dart';
import 'product_source.dart';

/// wantapi.com/products.php — projenin varsayılan kaynağı. Yanıt:
/// `{ "status": "...", "meta": {...}, "data": [ ...product... ] }`
class WantApiSource implements ProductSource {
  final http.Client _client;

  WantApiSource({http.Client? client}) : _client = client ?? http.Client();

  static final Uri _endpoint = Uri.parse('https://wantapi.com/products.php');

  @override
  String get label => 'WANTAPI';

  @override
  Future<Catalog> fetch() async {
    final response =
        await _client.get(_endpoint).timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      throw Exception('WANTAPI HTTP ${response.statusCode}');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return Catalog.fromWantApi(json);
  }
}
