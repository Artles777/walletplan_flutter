import "package:flutter/material.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_period_picker_logic.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_period_picker_keys.dart";

class TransactionsPeriodPickerDayCellWidget extends StatelessWidget {
  const TransactionsPeriodPickerDayCellWidget({
    required this.cellDate,
    required this.displayedDate,
    required this.constraints,
    required this.selectedPeriod,
    required this.onDateSelected,
    super.key,
  });

  final DateTime cellDate;
  final DateTime displayedDate;
  final TransactionsPeriodPickerConstraints constraints;
  final TransactionsPeriodSelection selectedPeriod;
  final ValueChanged<DateTime> onDateSelected;

  bool get isInDisplayedMonth {
    return cellDate.year == displayedDate.year &&
        cellDate.month == displayedDate.month;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final previousDate = cellDate.subtract(const Duration(days: 1));
    final nextDate = cellDate.add(const Duration(days: 1));
    final isSelectable = isPickerDateSelectable(constraints, cellDate);
    final isSelected = periodSelectionContainsDate(selectedPeriod, cellDate);
    final isRangeStart =
        isSelected &&
        !periodSelectionContainsDate(selectedPeriod, previousDate);
    final isRangeEnd =
        isSelected && !periodSelectionContainsDate(selectedPeriod, nextDate);
    final isSingleDayRange = isRangeStart && isRangeEnd;
    final isSelectedDay =
        isSelected && (isSingleDayRange || isRangeStart || isRangeEnd);
    final isRangeHighlighted =
        isSelected && !isSelectedDay && !isSingleDayRange;
    final rangeBorderRadius = BorderRadius.horizontal(
      left: Radius.circular(isRangeStart ? 12 : 0),
      right: Radius.circular(isRangeEnd ? 12 : 0),
    );
    final selectedDayBorderRadius = isSingleDayRange
        ? BorderRadius.circular(12)
        : BorderRadius.horizontal(
            left: Radius.circular(isRangeStart ? 12 : 0),
            right: Radius.circular(isRangeEnd ? 12 : 0),
          );
    final foregroundColor = isSelectedDay
        ? colorScheme.onPrimary
        : isRangeHighlighted
        ? colorScheme.onPrimaryContainer
        : !isSelectable || !isInDisplayedMonth
        ? colorScheme.outline
        : colorScheme.onSurface;
    final dateKey = transactionsPeriodPickerDateKey(cellDate);

    return InkWell(
      key: ValueKey("transactions-period-picker-day-$dateKey"),
      onTap: !isSelectable ? null : () => onDateSelected(cellDate),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (isSelected)
            SizedBox.shrink(
              key: ValueKey("transactions-period-picker-day-$dateKey-selected"),
            ),
          if (isRangeHighlighted)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: rangeBorderRadius,
                ),
              ),
            ),
          if (isSelectedDay)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: selectedDayBorderRadius,
                ),
              ),
            ),
          Center(
            child: DecoratedBox(
              decoration: const BoxDecoration(color: Colors.transparent),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                child: Text(
                  cellDate.day.toString(),
                  key: ValueKey(
                    "transactions-period-picker-day-$dateKey-label",
                  ),
                  style: textTheme.bodyMedium?.copyWith(
                    color: foregroundColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
