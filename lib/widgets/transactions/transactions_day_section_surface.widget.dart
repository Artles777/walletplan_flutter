import "package:flutter/material.dart";

class TransactionsDaySectionSurfaceWidget extends StatelessWidget {
  const TransactionsDaySectionSurfaceWidget({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(22),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
