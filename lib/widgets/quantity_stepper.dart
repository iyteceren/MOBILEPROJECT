import 'package:flutter/material.dart';

import '../core/constants.dart';

/// Adet artır / azalt kontrolü.
class QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final bool canIncrement;

  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.canIncrement = true,
  });

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).disabledColor;
    final fg = Theme.of(context).textTheme.bodyLarge?.color;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _btn(Icons.remove, onDecrement, fg),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
            child: Text('$quantity',
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          _btn(Icons.add, canIncrement ? onIncrement : null,
              canIncrement ? fg : muted),
        ],
      ),
    );
  }

  Widget _btn(IconData icon, VoidCallback? onTap, Color? color) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.sm),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}
