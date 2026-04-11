import "package:flutter/material.dart";

class TransactionsDaySectionSurfaceWidget extends StatelessWidget {
  const TransactionsDaySectionSurfaceWidget({
    required this.child,
    this.includeTopBorder = true,
    this.includeTopRadius = true,
    super.key,
  });

  final Widget child;
  final bool includeTopBorder;
  final bool includeTopRadius;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderSide = BorderSide(
      color: colorScheme.outlineVariant.withValues(alpha: 0.38),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(includeTopRadius ? 22 : 0),
          topRight: Radius.circular(includeTopRadius ? 22 : 0),
          bottomLeft: const Radius.circular(22),
          bottomRight: const Radius.circular(22),
        ),
        border: Border(
          top: includeTopBorder ? borderSide : BorderSide.none,
          left: borderSide,
          right: borderSide,
          bottom: borderSide,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(includeTopRadius ? 21 : 0),
            topRight: Radius.circular(includeTopRadius ? 21 : 0),
            bottomLeft: const Radius.circular(21),
            bottomRight: const Radius.circular(21),
          ),
          child: ColoredBox(
            color: colorScheme.surfaceContainerLow,
            child: child,
          ),
        ),
      ),
    );
  }
}
