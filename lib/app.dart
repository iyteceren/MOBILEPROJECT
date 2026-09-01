import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_routes.dart';
import 'core/constants.dart';
import 'data/favorites_repository.dart';
import 'data/product_repository.dart';
import 'di.dart';
import 'providers/build_provider.dart';
import 'providers/catalog_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/theme_provider.dart';
import 'theme/app_theme.dart';

class BudgetBuildApp extends StatelessWidget {
  const BudgetBuildApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BuildProvider()),
        ChangeNotifierProvider(
          create: (_) =>
              CatalogProvider(locator<ProductRepository>()),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              FavoritesProvider(locator<FavoritesRepository>())..load(),
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()..load()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _) => MaterialApp(
          title: AppStrings.appTitle,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: theme.mode,
          initialRoute: AppRoutes.home,
          onGenerateRoute: AppRoutes.onGenerateRoute,
          builder: (context, child) {
            final mq = MediaQuery.of(context);
            return MediaQuery(
              data: mq.copyWith(
                textScaler: mq.textScaler
                    .clamp(minScaleFactor: 0.9, maxScaleFactor: 1.3),
              ),
              child: child!,
            );
          },
        ),
      ),
    );
  }
}
