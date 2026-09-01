import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/utils/format.dart';
import '../data/models/saved_build.dart';
import '../data/saved_builds_repository.dart';
import '../di.dart';

/// Kaydedilmiş kurulumlar (cihazda kalıcı).
class SavedBuildsScreen extends StatefulWidget {
  const SavedBuildsScreen({super.key});

  @override
  State<SavedBuildsScreen> createState() => _SavedBuildsScreenState();
}

class _SavedBuildsScreenState extends State<SavedBuildsScreen> {
  final _repo = locator<SavedBuildsRepository>();
  late Future<List<SavedBuild>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repo.load();
  }

  void _reload() => setState(() => _future = _repo.load());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.savedBuilds)),
      body: FutureBuilder<List<SavedBuild>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final builds = snapshot.data!;
          if (builds.isEmpty) {
            return const Center(child: Text('Kayıtlı kurulum yok'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSizes.lg),
            itemCount: builds.length,
            separatorBuilder: (context, index) => const Divider(height: 20),
            itemBuilder: (context, index) {
              final b = builds[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                    'Skor ${b.score.toStringAsFixed(1)} · ${b.itemCount} ürün'),
                subtitle: Text(
                  '${formatUsd(b.spent)} / ${formatUsd(b.budget)}'
                  '  ·  ${_date(b.savedAt)}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () async {
                    await _repo.removeById(b.id);
                    _reload();
                  },
                ),
                onTap: () => _showDetail(context, b),
              );
            },
          );
        },
      ),
    );
  }

  void _showDetail(BuildContext context, SavedBuild b) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Skor ${b.score.toStringAsFixed(1)} / 10',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: AppSizes.md),
            ...b.lines.map((l) => Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: AppSizes.xs),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text('${l.quantity}x  ${l.product.name}')),
                      Text(formatUsd(l.product.price * l.quantity)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  String _date(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
}
