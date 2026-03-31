import "package:flutter/material.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";

class TransactionsFiltersChipGroupWidget extends StatelessWidget {
  const TransactionsFiltersChipGroupWidget({
    required this.allLabel,
    required this.emptyLabel,
    required this.options,
    required this.selectedIds,
    required this.onSelectAll,
    required this.onToggle,
    super.key,
  });

  final String allLabel;
  final String emptyLabel;
  final List<TransactionsFilterOption> options;
  final List<String> selectedIds;
  final VoidCallback onSelectAll;
  final void Function(String id) onToggle;

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) {
      return Text(emptyLabel, style: Theme.of(context).textTheme.bodyMedium);
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        FilterChip(
          key: ValueKey("transactions-filters-all-$allLabel"),
          label: Text(allLabel),
          selected: selectedIds.isEmpty,
          onSelected: (_) => onSelectAll(),
        ),
        for (final option in options)
          FilterChip(
            key: ValueKey("transactions-filters-option-${option.id}"),
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (option.icon != null) ...[
                  Icon(option.icon, size: 16),
                  const SizedBox(width: 6),
                ],
                Text(option.label),
              ],
            ),
            selected: selectedIds.contains(option.id),
            onSelected: (_) => onToggle(option.id),
          ),
      ],
    );
  }
}
