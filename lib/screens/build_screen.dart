import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_routes.dart';
import '../core/constants.dart';
import '../core/utils/format.dart';
import '../data/models/build_item.dart';
import '../providers/build_provider.dart';
import '../widgets/budget_bar.dart';
import '../widgets/product_image.dart';
import '../widgets/quantity_stepper.dart';

/// "Senin Kurulumun" — sepetin bu projedeki karşılığı.
class BuildScreen extends StatelessWidget {
  const BuildScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final build = context.watch<BuildProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.yourBuild)),
      body: build.isEmpty
          ? const _EmptyBuild()
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(
                      AppSizes.lg, AppSizes.md, AppSizes.lg, AppSizes.xs),
                  child: BudgetBar(),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppSizes.lg),
                    itemCount: build.items.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 24),
                    itemBuilder: (context, index) =>
                        _BuildRow(item: build.items[index]),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: build.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Toplam',
                            style: TextStyle(
                                color: AppColors.textMutedLight)),
                        Text(formatUsd(build.spent),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: AppSizes.sm),
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(
                          context, AppRoutes.result),
                      child: const Text(AppStrings.completeBuild),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _BuildRow extends StatelessWidget {
  final BuildItem item;
  const _BuildRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<BuildProvider>();
    return Row(
      children: [
        SizedBox(
          width: 56,
          height: 56,
          child: ProductImage(product: item.product, size: 56),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.product.name,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(formatUsd(item.lineTotal),
                  style:
                      const TextStyle(color: AppColors.textMutedLight)),
            ],
          ),
        ),
        QuantityStepper(
          quantity: item.quantity,
          canIncrement: provider.canAfford(item.product),
          onIncrement: () => provider.add(item.product),
          onDecrement: () => provider.decrement(item.product),
        ),
      ],
    );
  }
}

class _EmptyBuild extends StatelessWidget {
  const _EmptyBuild();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.shopping_cart_outlined, size: 56),
          const SizedBox(height: AppSizes.md),
          const Text(AppStrings.emptyBuildTitle,
              style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSizes.xs),
          const Text(AppStrings.emptyBuildBody,
              style: TextStyle(color: AppColors.textMutedLight)),
          const SizedBox(height: AppSizes.lg),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kataloğa dön'),
          ),
        ],
      ),
    );
  }
}
