import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../data/models/product.dart';
import '../providers/catalog_provider.dart';
import '../widgets/product_image.dart';

/// Karşılaştırma modu: en fazla 3 ürün seç, teknik özelliklerini yan yana gör.
class CompareScreen extends StatefulWidget {
  const CompareScreen({super.key});

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  final List<Product> _selected = [];
  static const _maxItems = 3;

  void _toggle(Product p) {
    setState(() {
      if (_selected.contains(p)) {
        _selected.remove(p);
      } else if (_selected.length < _maxItems) {
        _selected.add(p);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<CatalogProvider>().allProducts;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.compare)),
      body: products.isEmpty
          ? const Center(child: Text('Önce kataloğu aç'))
          : Column(
              children: [
                SizedBox(
                  height: 52,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSizes.lg),
                    itemCount: products.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: AppSizes.sm),
                    itemBuilder: (context, index) {
                      final p = products[index];
                      return Align(
                        alignment: Alignment.center,
                        child: FilterChip(
                          label: Text(p.name),
                          selected: _selected.contains(p),
                          onSelected: (_) => _toggle(p),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: _selected.isEmpty
                      ? const Center(
                          child: Text('Karşılaştırmak için ürün seç'))
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: _table(context),
                        ),
                ),
              ],
            ),
    );
  }

  Widget _table(BuildContext context) {
    final specKeys = <String>{
      for (final p in _selected) ...p.specs.keys,
    }.toList();

    return DataTable(
      headingRowHeight: 104,
      columns: [
        const DataColumn(label: Text('')),
        ..._selected.map((p) => DataColumn(
              label: SizedBox(
                width: 110,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: 44,
                        width: 44,
                        child: ProductImage(product: p, size: 44)),
                    const SizedBox(height: 4),
                    Text(p.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            )),
      ],
      rows: [
        DataRow(cells: [
          const DataCell(Text('Fiyat')),
          ..._selected.map((p) => DataCell(Text(p.priceLabel))),
        ]),
        DataRow(cells: [
          const DataCell(Text('Kategori')),
          ..._selected.map((p) => DataCell(Text(p.category))),
        ]),
        ...specKeys.map((key) => DataRow(cells: [
              DataCell(Text(key)),
              ..._selected.map((p) => DataCell(Text(p.specs[key] ?? '—'))),
            ])),
      ],
    );
  }
}
