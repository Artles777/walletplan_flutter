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

    return Material(
      color: Colors.transparent,
      elevation: overlapsContent ? 1 : 0,
      shadowColor: Colors.black.withValues(alpha: 0.06),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: Align(alignment: Alignment.bottomCenter, child: child),
      ),
    );
  }

  @override
  bool shouldRebuild(TransactionsDayHeaderDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}
