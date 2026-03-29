import "package:flutter/material.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions_period_picker.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_period_picker_day_calendar.widget.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_period_picker_keys.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_period_picker_logic.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_period_picker_month_grid.widget.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_period_picker_year_grid.widget.dart";

class TransactionsPeriodPickerBodyWidget extends StatelessWidget {
  const TransactionsPeriodPickerBodyWidget({
    required this.pickerView,
    required this.displayedDate,
    required this.constraints,
    required this.draftSelection,
    required this.localeTag,
    required this.onDateSelected,
    required this.onMonthSelected,
    required this.onYearSelected,
    super.key,
  });

  final TransactionsPeriodPickerView pickerView;
  final DateTime displayedDate;
  final TransactionsPeriodPickerConstraints constraints;
  final TransactionsPeriodSelection draftSelection;
  final String localeTag;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<DateTime> onMonthSelected;
  final ValueChanged<int> onYearSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: transactionsPeriodPickerScrollBodyKey,
      child: switch (pickerView) {
        TransactionsPeriodPickerView.day => KeyedSubtree(
          key: const ValueKey("transactions-period-picker-view-day"),
          child: TransactionsPeriodPickerDayCalendarWidget(
            displayedDate: displayedDate,
            constraints: constraints,
            selectedPeriod: draftSelection,
            onDateSelected: onDateSelected,
          ),
        ),
        TransactionsPeriodPickerView.month => KeyedSubtree(
          key: const ValueKey("transactions-period-picker-view-month"),
          child: TransactionsPeriodPickerMonthGridWidget(
            constraints: constraints,
            displayedYear: displayedDate.year,
            focusedMonth: displayedDate.month,
            localeTag: localeTag,
            onMonthSelected: onMonthSelected,
          ),
        ),
        TransactionsPeriodPickerView.year => KeyedSubtree(
          key: const ValueKey("transactions-period-picker-view-year"),
          child: TransactionsPeriodPickerYearGridWidget(
            constraints: constraints,
            focusedYear: displayedDate.year,
            onYearSelected: onYearSelected,
          ),
        ),
      },
    );
  }
}
