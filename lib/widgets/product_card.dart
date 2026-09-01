import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../data/models/product.dart';
import '../providers/build_provider.dart';
import '../providers/favorites_provider.dart';
import 'product_image.dart';

/// Katalog GridView'inde bir ürün kartı: görsel, favori kalbi, "eklenebilir /
/// kilitli" rozeti, ad, tagline ve fiyat.
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final build = context.watch<BuildProvider>();
    final favorites = context.watch<FavoritesProvider>();
    final inBuild = build.contains(product);
    final affordable = build.canAfford(product) || inBuild;
    final isFav = favorites.isFavorite(product.id);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          border: Border.all(
            color: inBuild ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppSizes.md),
                    child: ProductImage(product: product),
                  ),
                  Positioned(
                    top: AppSizes.sm,
                    left: AppSizes.sm,
                    child: _badge(inBuild, affordable),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                        color: isFav ? Colors.redAccent : null,
                      ),
                      onPressed: () => favorites.toggle(product.id),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSizes.md, 0, AppSizes.md, AppSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(product.tagline,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textMutedLight)),
                  const SizedBox(height: 6),
                  Text(product.priceLabel,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(bool inBuild, bool affordable) {
    final IconData icon;
    final Color color;
    if (inBuild) {
      icon = Icons.check_circle;
      color = AppColors.primary;
    } else if (affordable) {
      icon = Icons.add_circle_outline;
      color = Colors.green;
    } else {
      icon = Icons.lock_outline;
      color = AppColors.textMutedLight;
    }
    return Container(
      padding: const EdgeInsets.all(AppSizes.xs),
      decoration: const BoxDecoration(
          color: Colors.white, shape: BoxShape.circle),
      child: Icon(icon, size: 16, color: color),
    );
  }
}
