import "package:flutter/material.dart";
import "package:walletplan_flutter/utils/transactions_period_formatter.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_period_picker_choice_button.widget.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_period_picker_logic.dart";

class TransactionsPeriodPickerMonthGridWidget extends StatelessWidget {
  const TransactionsPeriodPickerMonthGridWidget({
    required this.constraints,
    required this.displayedYear,
    required this.focusedMonth,
    required this.localeTag,
    required this.onMonthSelected,
    super.key,
  });

  final TransactionsPeriodPickerConstraints constraints;
  final int displayedYear;
  final int focusedMonth;
  final String localeTag;
  final ValueChanged<DateTime> onMonthSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GridView.builder(
      shrinkWrap: true,
      itemCount: 12,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.35,
      ),
      itemBuilder: (context, index) {
        final month = index + 1;
        final monthDate = DateTime(displayedYear, month);
        final monthSelection = buildFullMonthPeriodSelection(
          constraints,
          monthDate,
        );
        final isEnabled = monthSelection != null;
        final isFocusedMonth = month == focusedMonth && isEnabled;
        final monthLabel = formatTransactionsPickerMonthShortLabel(
          monthDate,
          localeTag,
        );

        return TransactionsPeriodPickerChoiceButtonWidget(
          buttonKey: ValueKey("transactions-period-picker-month-$month"),
          isEnabled: isEnabled,
          isFocused: isFocusedMonth,
          onPressed: () => onMonthSelected(monthDate),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (isFocusedMonth)
                SizedBox.shrink(
                  key: ValueKey(
                    "transactions-period-picker-month-$month-focused",
                  ),
                ),
              Text(
                monthLabel,
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
