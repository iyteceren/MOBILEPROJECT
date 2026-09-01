import 'package:flutter/material.dart';

import 'data/models/product.dart';
import 'screens/build_screen.dart';
import 'screens/catalog_screen.dart';
import 'screens/compare_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/result_screen.dart';
import 'screens/saved_builds_screen.dart';
import 'screens/settings_screen.dart';

/// Named route tanımları. Geçişler `Navigator.pushNamed` ile; veri
/// `arguments` üzerinden taşınır (Route Arguments örneği).
class AppRoutes {
  AppRoutes._();

  static const home = '/';
  static const catalog = '/catalog';
  static const detail = '/detail';
  static const build = '/build';
  static const result = '/result';
  static const compare = '/compare';
  static const favorites = '/favorites';
  static const savedBuilds = '/saved-builds';
  static const settings = '/settings';

  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    final Widget page = switch (routeSettings.name) {
      home => const HomeScreen(),
      catalog => const CatalogScreen(),
      detail => ProductDetailScreen(
          product: routeSettings.arguments as Product),
      build => const BuildScreen(),
      result => const ResultScreen(),
      compare => const CompareScreen(),
      favorites => const FavoritesScreen(),
      savedBuilds => const SavedBuildsScreen(),
      settings => const SettingsScreen(),
      _ => Scaffold(
          body: Center(
              child: Text('Sayfa bulunamadı: ${routeSettings.name}')),
        ),
    };
    return MaterialPageRoute(builder: (_) => page, settings: routeSettings);
  }
}
