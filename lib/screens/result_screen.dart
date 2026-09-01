import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_routes.dart';
import '../core/constants.dart';
import '../core/utils/format.dart';
import '../data/models/saved_build.dart';
import '../data/saved_builds_repository.dart';
import '../di.dart';
import '../providers/build_provider.dart';

/// Sonuç ekranı: setup skoru, bütçe özeti, ürün listesi; kaydet / yeni kurulum.
class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late final SavedBuild _snapshot;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    // Kurulum "Yeni kurulum" ile temizlenince kaybolmasın diye anlık kopya.
    _snapshot = context.read<BuildProvider>().toSavedBuild();
  }

  Future<void> _save() async {
    await locator<SavedBuildsRepository>().add(_snapshot);
    if (mounted) setState(() => _saved = true);
  }

  @override
  Widget build(BuildContext context) {
    final b = _snapshot;
    final saved = b.budget - b.spent;

    return Scaffold(
      appBar: AppBar(
          title: const Text(AppStrings.result),
          automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.xl),
        children: [
          const SizedBox(height: AppSizes.sm),
          Center(
            child: Column(
              children: [
                Text('${b.score.toStringAsFixed(1)} / 10',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    )),
                const SizedBox(height: AppSizes.xs),
                Text(_comment(b.score),
                    style:
                        const TextStyle(color: AppColors.textMutedLight)),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.xl),
          _row('Bütçe', formatUsd(b.budget)),
          _row('Harcanan', formatUsd(b.spent)),
          _row(saved >= 0 ? 'Kalan' : 'Aşım', formatUsd(saved),
              highlight: true),
          _row('Kategori çeşitliliği',
              '${b.lines.map((l) => l.product.category).toSet().length}'),
          const Divider(height: 32),
          const Text('Kurulumun',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSizes.sm),
          ...b.lines.map(
            (l) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(
                      child: Text('${l.quantity}x  ${l.product.name}')),
                  Text(formatUsd(l.product.price * l.quantity)),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSizes.xxl),
          OutlinedButton.icon(
            onPressed: _saved ? null : _save,
            icon: Icon(_saved ? Icons.check : Icons.bookmark_add_outlined),
            label: Text(_saved ? 'Kaydedildi' : AppStrings.saveBuild),
            style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(AppSizes.buttonHeight)),
          ),
          const SizedBox(height: AppSizes.sm),
          ElevatedButton(
            onPressed: () {
              context.read<BuildProvider>().clear();
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.home, (route) => false);
            },
            child: const Text(AppStrings.newBuild),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: AppColors.textMutedLight)),
          Text(value,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: highlight ? AppColors.primary : null,
              )),
        ],
      ),
    );
  }

  String _comment(double score) {
    if (score >= 8) return 'Harika bir denge kurdun!';
    if (score >= 5) return 'Fena değil, biraz daha çeşitlilik ekleyebilirsin.';
    if (score > 0) return 'Bütçeni daha verimli kullanabilirsin.';
    return 'Henüz ürün eklemedin.';
  }
}
