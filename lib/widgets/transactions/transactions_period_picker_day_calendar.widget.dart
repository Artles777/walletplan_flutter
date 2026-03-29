import "dart:math" as math;

import "package:flutter/material.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_period_picker_day_cell.widget.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_period_picker_logic.dart";

class TransactionsPeriodPickerDayCalendarWidget extends StatelessWidget {
  const TransactionsPeriodPickerDayCalendarWidget({
    required this.displayedDate,
    required this.constraints,
    required this.selectedPeriod,
    required this.onDateSelected,
    super.key,
  });

  final DateTime displayedDate;
  final TransactionsPeriodPickerConstraints constraints;
  final TransactionsPeriodSelection selectedPeriod;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = MaterialLocalizations.of(context);
    final firstDayOffset = DateUtils.firstDayOffset(
      displayedDate.year,
      displayedDate.month,
      localizations,
    );
    final daysInMonth = DateUtils.getDaysInMonth(
      displayedDate.year,
      displayedDate.month,
    );
    final weekCount = (firstDayOffset + daysInMonth + 6) ~/ 7;
    final totalCells = weekCount * 7;
    final firstVisibleDate = DateTime(
      displayedDate.year,
      displayedDate.month,
      1,
    ).subtract(Duration(days: firstDayOffset));
    final weekdayLabels = List<String>.generate(7, (index) {
      final weekdayIndex =
          (localizations.firstDayOfWeekIndex + index) %
          localizations.narrowWeekdays.length;

      return localizations.narrowWeekdays[weekdayIndex];
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        const maxCalendarWidth = 304.0;
        const weekdayBottomPadding = 6.0;
        const gridSpacing = 4.0;
        const dayCellHeightFactor = 0.8;
        final calendarWidth = math.min(constraints.maxWidth, maxCalendarWidth);
        final dayCellWidth = math.max(
          0,
          (calendarWidth - (gridSpacing * 6)) / 7,
        );
        final dayCellHeight = dayCellWidth * dayCellHeightFactor;
        final weekdayTextStyle = textTheme.labelSmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        );
        final weekdayHeight =
            (weekdayTextStyle?.fontSize ?? 11) *
                (weekdayTextStyle?.height ?? 1.0) +
            weekdayBottomPadding;
        final gridHeight =
            (dayCellHeight * weekCount) + (gridSpacing * (weekCount - 1));
        final calendarHeight = (weekdayHeight + gridHeight).ceilToDouble();

        return Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: calendarWidth,
            height: calendarHeight,
            child: Column(
              children: [
                Row(
                  children: [
                    for (final label in weekdayLabels)
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: weekdayBottomPadding,
                            ),
                            child: Text(
                              label.toUpperCase(),
                              style: weekdayTextStyle,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(
                  height: gridHeight,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: totalCells,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: gridSpacing,
                      crossAxisSpacing: 0,
                      mainAxisExtent: dayCellHeight,
                    ),
                    itemBuilder: (context, index) {
                      final cellDate = firstVisibleDate.add(
                        Duration(days: index),
                      );

                      return TransactionsPeriodPickerDayCellWidget(
                        cellDate: cellDate,
                        displayedDate: displayedDate,
                        constraints: this.constraints,
                        selectedPeriod: selectedPeriod,
                        onDateSelected: onDateSelected,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
