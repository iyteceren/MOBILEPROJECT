import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../core/utils/format.dart';
import '../providers/build_provider.dart';

/// Bütçe göstergesi: harcanan / toplam ve kalan. %90 aşıldığında turuncuya,
/// bütçe aşımında kırmızıya döner (animasyonlu).
class BudgetBar extends StatelessWidget {
  const BudgetBar({super.key});

  @override
  Widget build(BuildContext context) {
    final build = context.watch<BuildProvider>();
    final ratio = build.utilization.clamp(0.0, 1.0);
    final over = build.remaining < 0;
    final warn = build.utilization >= 0.9;
    final color = over
        ? Colors.red
        : warn
            ? Colors.orange
            : AppColors.primary;

    return Container(
      padding: const EdgeInsets.fromLTRB(
          AppSizes.xl, AppSizes.md, AppSizes.xl, AppSizes.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Harcanan ${formatUsd(build.spent)}',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(
                over
                    ? 'Aşım ${formatUsd(build.remaining)}'
                    : 'Kalan ${formatUsd(build.remaining)}',
                style: TextStyle(color: color, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: ratio),
              duration: const Duration(milliseconds: 350),
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 8,
                backgroundColor: Colors.black12,
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text('Toplam bütçe ${formatUsd(build.budget)}',
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textMutedLight)),
        ],
      ),
    );
  }
}
