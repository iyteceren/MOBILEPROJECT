import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_routes.dart';
import '../core/constants.dart';
import '../core/utils/format.dart';
import '../providers/build_provider.dart';

/// Giriş ekranı: banner + bütçe seviyesi seçimi.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _levels = <double>[2000, 5000, 10000];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            tooltip: AppStrings.favorites,
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.favorites),
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            tooltip: AppStrings.savedBuilds,
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.savedBuilds),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: AppStrings.settings,
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.settings),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(AppStrings.homeSubtitle,
                  style: TextStyle(color: AppColors.textMutedLight)),
              const SizedBox(height: AppSizes.xl),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                child: AspectRatio(
                  aspectRatio: 16 / 7,
                  child: Image.asset(
                    'assets/images/banner.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) => Container(
                      color: Theme.of(context).cardColor,
                      alignment: Alignment.center,
                      child: const Icon(Icons.image_outlined),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.xxl),
              const Text(AppStrings.chooseBudget,
                  style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: AppSizes.md),
              ..._levels.map((level) => _BudgetOption(level: level)),
            ],
          ),
        ),
      ),
    );
  }
}

class _BudgetOption extends StatelessWidget {
  final double level;
  const _BudgetOption({required this.level});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.radius),
        onTap: () {
          context.read<BuildProvider>().setBudget(level);
          Navigator.pushNamed(context, AppRoutes.catalog);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 18, vertical: AppSizes.xl),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(AppSizes.radius),
          ),
          child: Row(
            children: [
              Text(formatUsd(level),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(width: AppSizes.md),
              Text(_labelFor(level),
                  style: const TextStyle(color: AppColors.textMutedLight)),
              const Spacer(),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  String _labelFor(double level) {
    if (level <= 2000) return 'Başlangıç';
    if (level <= 5000) return 'Dengeli';
    return 'Sınırsız hayal';
  }
}
