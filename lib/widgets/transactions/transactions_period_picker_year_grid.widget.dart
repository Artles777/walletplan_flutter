import "package:flutter/material.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_period_picker_choice_button.widget.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_period_picker_logic.dart";

class TransactionsPeriodPickerYearGridWidget extends StatelessWidget {
  const TransactionsPeriodPickerYearGridWidget({
    required this.constraints,
    required this.focusedYear,
    required this.onYearSelected,
    super.key,
  });

  final TransactionsPeriodPickerConstraints constraints;
  final int focusedYear;
  final ValueChanged<int> onYearSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final startYear = focusedYear - 5;

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
        final year = startYear + index;
        final isEnabled = yearHasSelectableDate(constraints, year);
        final isFocusedYear = year == focusedYear && isEnabled;

        return TransactionsPeriodPickerChoiceButtonWidget(
          buttonKey: ValueKey("transactions-period-picker-year-$year"),
          isEnabled: isEnabled,
          isFocused: isFocusedYear,
          onPressed: () => onYearSelected(year),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (isFocusedYear)
                SizedBox.shrink(
                  key: ValueKey(
                    "transactions-period-picker-year-$year-focused",
                  ),
                ),
              Text(
                year.toString(),
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
