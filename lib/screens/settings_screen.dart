import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../data/sources/product_source.dart';
import '../providers/catalog_provider.dart';
import '../providers/theme_provider.dart';

/// Ayarlar: veri kaynağı ve tema modu.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogProvider>();
    final theme = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.settings)),
      body: ListView(
        children: [
          const _SectionHeader('Veri kaynağı'),
          RadioGroup<ProductSourceKind>(
            groupValue: catalog.sourceKind,
            onChanged: (value) {
              if (value != null) catalog.setSource(value);
            },
            child: Column(
              children: ProductSourceKind.values
                  .map((kind) => RadioListTile<ProductSourceKind>(
                        title: Text(kind.label),
                        value: kind,
                      ))
                  .toList(),
            ),
          ),
          const Divider(),
          const _SectionHeader('Tema'),
          RadioGroup<ThemeMode>(
            groupValue: theme.mode,
            onChanged: (value) {
              if (value != null) theme.setMode(value);
            },
            child: Column(
              children: ThemeMode.values
                  .map((mode) => RadioListTile<ThemeMode>(
                        title: Text(_themeLabel(mode)),
                        value: mode,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _themeLabel(ThemeMode mode) => switch (mode) {
        ThemeMode.system => 'Sistem',
        ThemeMode.light => 'Açık',
        ThemeMode.dark => 'Koyu',
      };
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSizes.lg, AppSizes.lg, AppSizes.lg, AppSizes.sm),
      child: Text(text,
          style: const TextStyle(
              fontWeight: FontWeight.w700, color: AppColors.textMutedLight)),
    );
  }
}
