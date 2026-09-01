import 'package:flutter/foundation.dart';

import '../data/favorites_repository.dart';

/// Favori ürünlerin durumu. Değişiklikler anında cihaza yazılır.
class FavoritesProvider extends ChangeNotifier {
  FavoritesProvider(this._repository);

  final FavoritesRepository _repository;
  Set<int> _ids = {};

  Set<int> get ids => _ids;
  int get count => _ids.length;
  bool isFavorite(int productId) => _ids.contains(productId);

  Future<void> load() async {
    _ids = await _repository.load();
    notifyListeners();
  }

  Future<void> toggle(int productId) async {
    if (!_ids.add(productId)) _ids.remove(productId);
    notifyListeners();
    await _repository.save(_ids);
  }
}
