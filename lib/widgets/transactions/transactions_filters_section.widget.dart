import "package:flutter/material.dart";

class TransactionsFiltersSectionWidget extends StatelessWidget {
  const TransactionsFiltersSectionWidget({
    required this.title,
    required this.child,
    this.compact = false,
    super.key,
  });

  final String title;
  final Widget child;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          compact ? 12 : 14,
          16,
          compact ? 12 : 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: compact ? 8 : 12),
            child,
          ],
        ),
      ),
    );
  }
}
