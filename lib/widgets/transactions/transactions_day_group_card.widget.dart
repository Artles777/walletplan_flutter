import "package:flutter/material.dart";

class TransactionsDayGroupCardWidget extends StatelessWidget {
  const TransactionsDayGroupCardWidget({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.indigo.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withValues(alpha: 0.04),
            spreadRadius: 4,
            blurRadius: 4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: ColoredBox(color: cs.surface, child: child),
      ),
    );
  }
}
