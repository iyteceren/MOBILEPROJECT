import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../app_routes.dart';
import '../core/constants.dart';
import '../data/models/product.dart';
import '../providers/build_provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/product_image.dart';

/// Ürün detayı. Ürün nesnesi named route'tan `arguments` ile gelir
/// (`AppRoutes` çözer). Alternatif okuma:
/// `ModalRoute.of(context)!.settings.arguments as Product`.
class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final build = context.watch<BuildProvider>();
    final favorites = context.watch<FavoritesProvider>();
    final inBuild = build.contains(product);
    final affordable = build.canAfford(product);
    final isFav = favorites.isFavorite(product.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          IconButton(
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.redAccent : null),
            onPressed: () => favorites.toggle(product.id),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.xl),
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(AppSizes.xl),
              ),
              padding: const EdgeInsets.all(24),
              child: ProductImage(product: product),
            ),
          ),
          const SizedBox(height: AppSizes.xl),
          Text(product.name,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSizes.xs),
          Text(product.tagline,
              style: const TextStyle(color: AppColors.textMutedLight)),
          const SizedBox(height: AppSizes.md),
          Text(product.priceLabel,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              )),
          const SizedBox(height: AppSizes.xl),
          const Text('Açıklama',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(product.description, style: const TextStyle(height: 1.5)),
          if (product.specs.isNotEmpty) ...[
            const SizedBox(height: AppSizes.xl),
            const Text('Teknik Özellikler',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: AppSizes.sm),
            ...product.specs.entries.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSizes.xs),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(e.key,
                          style: const TextStyle(
                              color: AppColors.textMutedLight)),
                    ),
                    Expanded(
                      child: Text(e.value,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSizes.xxl),
          if (inBuild)
            OutlinedButton.icon(
              onPressed: () => context.read<BuildProvider>().remove(product),
              icon: const Icon(Icons.remove_shopping_cart_outlined),
              label: const Text(AppStrings.removeFromBuild),
              style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(AppSizes.buttonHeight)),
            )
          else
            ElevatedButton(
              onPressed: affordable
                  ? () {
                      context.read<BuildProvider>().add(product);
                      HapticFeedback.selectionClick();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('${product.name} kuruluma eklendi'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    }
                  : null,
              child: Text(
                  affordable ? AppStrings.addToBuild : AppStrings.budgetTooLow),
            ),
          const SizedBox(height: AppSizes.sm),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.build),
            child: const Text('Kurulumu gör'),
          ),
        ],
      ),
    );
  }
}
