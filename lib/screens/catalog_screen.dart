import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_routes.dart';
import '../core/constants.dart';
import '../core/result.dart';
import '../data/product_repository.dart';
import '../providers/build_provider.dart';
import '../providers/catalog_provider.dart';
import '../widgets/budget_bar.dart';
import '../widgets/catalog_skeleton.dart';
import '../widgets/product_card.dart';

/// Ürün listesi: arama, sıralama, kategori filtresi, shimmer yükleme,
/// pull-to-refresh ve GridView kart tasarımı.
class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  @override
  void initState() {
    super.initState();
    final catalog = context.read<CatalogProvider>();
    if (catalog.result == null && !catalog.loading) {
      WidgetsBinding.instance.addPostFrameCallback((_) => catalog.load());
    }
  }

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          catalog.meta.count > 0
              ? '${AppStrings.catalog} · ${catalog.meta.count} ürün'
              : AppStrings.catalog,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.compare_arrows),
            tooltip: AppStrings.compare,
            onPressed: () => Navigator.pushNamed(context, AppRoutes.compare),
          ),
          _CartButton(),
        ],
      ),
      body: Column(
        children: [
          if (catalog.fromCache) const _OfflineNotice(),
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSizes.lg, AppSizes.sm, AppSizes.lg, 0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: catalog.setQuery,
                    decoration: InputDecoration(
                      hintText: AppStrings.searchHint,
                      prefixIcon: const Icon(Icons.search, size: 20),
                      isDense: true,
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSizes.md),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                _SortButton(current: catalog.sort, onChanged: catalog.setSort),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(
                AppSizes.lg, AppSizes.sm, AppSizes.lg, 0),
            child: BudgetBar(),
          ),
          if (catalog.categories.length > 1)
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
                itemCount: catalog.categories.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(width: AppSizes.sm),
                itemBuilder: (context, index) {
                  final cat = catalog.categories[index];
                  return ChoiceChip(
                    label: Text(cat),
                    selected: cat == catalog.category,
                    onSelected: (_) => catalog.setCategory(cat),
                  );
                },
              ),
            ),
          Expanded(child: _body(context, catalog)),
        ],
      ),
    );
  }

  Widget _body(BuildContext context, CatalogProvider catalog) {
    if (catalog.loading && catalog.result == null) {
      return const CatalogSkeleton();
    }
    final result = catalog.result;
    if (result is Failure) {
      return _ErrorView(onRetry: catalog.load);
    }
    final products = catalog.visibleProducts;
    if (products.isEmpty) {
      return const Center(child: Text('Sonuç yok'));
    }
    return RefreshIndicator(
      onRefresh: catalog.load,
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(
            AppSizes.lg, AppSizes.sm, AppSizes.lg, AppSizes.xl),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: AppSizes.gridMaxExtent,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 0.66,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCard(
            product: product,
            onTap: () => Navigator.pushNamed(
              context,
              AppRoutes.detail,
              arguments: product,
            ),
          );
        },
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  final ProductSort current;
  final ValueChanged<ProductSort> onChanged;
  const _SortButton({required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ProductSort>(
      icon: const Icon(Icons.sort),
      initialValue: current,
      onSelected: onChanged,
      itemBuilder: (context) => const [
        PopupMenuItem(value: ProductSort.none, child: Text('Varsayılan')),
        PopupMenuItem(
            value: ProductSort.priceAsc, child: Text('Fiyat artan')),
        PopupMenuItem(
            value: ProductSort.priceDesc, child: Text('Fiyat azalan')),
        PopupMenuItem(value: ProductSort.nameAsc, child: Text('İsim A-Z')),
      ],
    );
  }
}

class _CartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final count = context.watch<BuildProvider>().totalCount;
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_bag_outlined),
          onPressed: () => Navigator.pushNamed(context, AppRoutes.build),
        ),
        if (count > 0)
          Positioned(
            right: 6,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(AppSizes.xs),
              decoration: const BoxDecoration(
                  color: AppColors.primary, shape: BoxShape.circle),
              constraints:
                  const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text('$count',
                  textAlign: TextAlign.center,
                  style:
                      const TextStyle(color: Colors.white, fontSize: 10)),
            ),
          ),
      ],
    );
  }
}

class _OfflineNotice extends StatelessWidget {
  const _OfflineNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.orange.withValues(alpha: 0.15),
      padding: const EdgeInsets.symmetric(
          vertical: 6, horizontal: AppSizes.lg),
      child: const Text(
        AppStrings.offlineNotice,
        style: TextStyle(fontSize: 12),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final Future<void> Function() onRetry;
  const _ErrorView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off, size: 40),
          const SizedBox(height: AppSizes.md),
          const Text(AppStrings.loadError),
          const SizedBox(height: AppSizes.md),
          OutlinedButton(
            onPressed: () => onRetry(),
            child: const Text(AppStrings.retry),
          ),
        ],
      ),
    );
  }
}
