import "package:flutter/material.dart";

class TransactionsDayHeaderTitleWidget extends StatelessWidget {
  const TransactionsDayHeaderTitleWidget({
    required this.dateLabel,
    this.markerLabel,
    super.key,
  });

  final String dateLabel;
  final String? markerLabel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Text(
          dateLabel,
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
        if (markerLabel != null) ...[
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              markerLabel!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.85),
                fontWeight: FontWeight.w500,
                letterSpacing: -0.1,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
