import "package:flutter/material.dart";

class TransactionsDayHeaderDelegate extends SliverPersistentHeaderDelegate {
  TransactionsDayHeaderDelegate({required this.child});

  final Widget child;

  @override
  double get minExtent => 42;

  @override
  double get maxExtent => 42;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final cs = Theme.of(context).colorScheme;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final borderSide = BorderSide(
      color: cs.outlineVariant.withValues(alpha: 0.55),
    );
    final borderRadius = BorderRadius.vertical(
      top: const Radius.circular(22),
      bottom: Radius.circular(overlapsContent ? 18 : 0),
    );
    final border = Border(
      top: borderSide,
      left: borderSide,
      right: borderSide,
      bottom: overlapsContent ? borderSide : BorderSide.none,
    );

    return ColoredBox(
      color: scaffoldBackgroundColor,
      child: Material(
        color: Colors.transparent,
        elevation: overlapsContent ? 2 : 0,
        shadowColor: Colors.black.withValues(alpha: 0.06),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              border: border,
              borderRadius: borderRadius,
            ),
            child: Align(alignment: Alignment.bottomCenter, child: child),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(TransactionsDayHeaderDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}
