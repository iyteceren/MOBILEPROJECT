import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../data/models/product.dart';

/// Ürün görselini gösterir. Sırayla: pakete gömülü asset → ağ görseli → ikon.
/// Bu sayede uygulama çevrimdışıyken ve web'de (CORS) de görseller görünür.
class ProductImage extends StatelessWidget {
  final Product product;
  final double? size;
  final BoxFit fit;

  const ProductImage({
    super.key,
    required this.product,
    this.size,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    final asset = product.assetImage;
    if (asset.isNotEmpty) {
      return Image.asset(
        asset,
        width: size,
        height: size,
        fit: fit,
        errorBuilder: (context, error, stack) => _network(),
      );
    }
    return _network();
  }

  Widget _network() {
    if (product.imageUrl.isEmpty) return _fallback();
    return Image.network(
      product.imageUrl,
      width: size,
      height: size,
      fit: fit,
      loadingBuilder: (context, child, progress) => progress == null
          ? child
          : const Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
      errorBuilder: (context, error, stack) => _fallback(),
    );
  }

  Widget _fallback() => Center(
        child: Icon(
          Icons.devices_other,
          size: (size ?? 48) * 0.6,
          color: AppColors.textMutedLight,
        ),
      );
}
