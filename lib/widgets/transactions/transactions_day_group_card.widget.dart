import "package:flutter/material.dart";

class TransactionsDayGroupCardWidget extends StatelessWidget {
  const TransactionsDayGroupCardWidget({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
