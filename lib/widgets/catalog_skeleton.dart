import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../core/constants.dart';

/// Katalog yüklenirken gösterilen shimmer iskeleti.
class CatalogSkeleton extends StatelessWidget {
  const CatalogSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).cardColor;
    final highlight = Theme.of(context).colorScheme.surface;

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: GridView.builder(
        padding: const EdgeInsets.all(AppSizes.lg),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: AppSizes.gridMaxExtent,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 0.66,
        ),
        itemCount: 6,
        itemBuilder: (context, index) => Container(
          decoration: BoxDecoration(
            color: base,
            borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          ),
        ),
      ),
    );
  }
}
