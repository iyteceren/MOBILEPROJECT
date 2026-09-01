import 'package:get_it/get_it.dart';

import 'data/favorites_repository.dart';
import 'data/product_repository.dart';
import 'data/saved_builds_repository.dart';

/// Servis konumlandırıcı. Repository'ler tek örnek (singleton) olarak kaydedilir
/// ve widget ağacından bağımsız erişilir; testte sahte örneklerle değiştirilir.
final locator = GetIt.instance;

void setupLocator() {
  locator
    ..registerLazySingleton<ProductRepository>(() => ProductRepository())
    ..registerLazySingleton<FavoritesRepository>(() => FavoritesRepository())
    ..registerLazySingleton<SavedBuildsRepository>(
        () => SavedBuildsRepository());
}
