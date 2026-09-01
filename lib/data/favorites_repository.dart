import 'package:shared_preferences/shared_preferences.dart';

/// Favori ürün id'lerini cihazda kalıcı saklar (`shared_preferences`).
class FavoritesRepository {
  static const _key = 'favorite_product_ids';

  Future<Set<int>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? const [];
    return raw.map(int.tryParse).whereType<int>().toSet();
  }

  Future<void> save(Set<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, ids.map((e) => e.toString()).toList());
  }
}
