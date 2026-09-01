import 'package:flutter/foundation.dart';

import '../data/models/build_item.dart';
import '../data/models/product.dart';
import '../data/models/saved_build.dart';

/// Seçilen bütçe ve kullanıcının kurulumu — uygulamanın ana durumu.
class BuildProvider extends ChangeNotifier {
  double _budget = 5000;
  final Map<int, BuildItem> _items = {};

  double get budget => _budget;
  List<BuildItem> get items => _items.values.toList(growable: false);
  bool get isEmpty => _items.isEmpty;

  int get totalCount =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get spent =>
      _items.values.fold(0.0, (sum, item) => sum + item.lineTotal);

  double get remaining => _budget - spent;

  /// Bütçenin ne kadarı kullanıldı (0..1+).
  double get utilization => _budget == 0 ? 0 : spent / _budget;

  void setBudget(double value) {
    _budget = value;
    _items.clear();
    notifyListeners();
  }

  bool contains(Product product) => _items.containsKey(product.id);
  int quantityOf(Product product) => _items[product.id]?.quantity ?? 0;
  bool canAfford(Product product) => product.price <= remaining;

  bool add(Product product) {
    if (!canAfford(product)) return false;
    final existing = _items[product.id];
    if (existing == null) {
      _items[product.id] = BuildItem(product: product);
    } else {
      existing.quantity++;
    }
    notifyListeners();
    return true;
  }

  void decrement(Product product) {
    final existing = _items[product.id];
    if (existing == null) return;
    if (existing.quantity > 1) {
      existing.quantity--;
    } else {
      _items.remove(product.id);
    }
    notifyListeners();
  }

  void remove(Product product) {
    _items.remove(product.id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  int get distinctCategories =>
      _items.values.map((e) => e.product.category).toSet().length;

  /// 0-10 arası "setup skoru": kategori çeşitliliği + bütçe kullanımı.
  double get score {
    if (_items.isEmpty) return 0;
    double s = distinctCategories * 1.2;
    if (utilization >= 0.8 && utilization <= 1.0) {
      s += 3;
    } else if (utilization >= 0.5) {
      s += 1.5;
    }
    return s.clamp(0, 10).toDouble();
  }

  SavedBuild toSavedBuild() {
    return SavedBuild(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      budget: _budget,
      spent: spent,
      score: score,
      savedAt: DateTime.now(),
      lines: _items.values
          .map((i) => SavedBuildLine(product: i.product, quantity: i.quantity))
          .toList(),
    );
  }
}
