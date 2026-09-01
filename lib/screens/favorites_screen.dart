import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_routes.dart';
import '../core/constants.dart';
import '../providers/catalog_provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/product_image.dart';

/// Favori ürünler. Ürün bilgisi katalogdan gelir; favori id'leri kalıcı.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>();
    final catalog = context.watch<CatalogProvider>();
    final products = catalog.allProducts
        .where((p) => favorites.isFavorite(p.id))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.favorites)),
      body: catalog.allProducts.isEmpty
          ? const Center(child: Text('Önce kataloğu aç'))
          : products.isEmpty
              ? const Center(child: Text('Henüz favori yok'))
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  itemCount: products.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 20),
                  itemBuilder: (context, index) {
                    final p = products[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: SizedBox(
                          width: 48,
                          height: 48,
                          child: ProductImage(product: p, size: 48)),
                      title: Text(p.name),
                      subtitle: Text(p.priceLabel),
                      trailing: IconButton(
                        icon: const Icon(Icons.favorite,
                            color: Colors.redAccent),
                        onPressed: () => favorites.toggle(p.id),
                      ),
                      onTap: () => Navigator.pushNamed(
                          context, AppRoutes.detail,
                          arguments: p),
                    );
                  },
                ),
    );
  }
}
