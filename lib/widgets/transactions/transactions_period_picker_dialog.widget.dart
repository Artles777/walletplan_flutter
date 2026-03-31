import "dart:math" as math;

import "package:flutter/material.dart";
import "package:flutter_compositions/flutter_compositions.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions_period_picker.dart";
import "package:walletplan_flutter/utils/transactions_period_formatter.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_period_picker_actions.widget.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_period_picker_body.widget.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_period_picker_logic.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_period_picker_navigation.widget.dart";

class TransactionsPeriodPickerDialogWidget extends CompositionWidget {
  const TransactionsPeriodPickerDialogWidget({
    required this.initialSelection,
    required this.initialView,
    required this.constraints,
    super.key,
  });

  final TransactionsPeriodSelection initialSelection;
  final TransactionsPeriodPickerView initialView;
  final TransactionsPeriodPickerConstraints constraints;

  @override
  Widget Function(BuildContext) setup() {
    final pickerStore = useTransactionsPeriodPicker(
      initialSelection: initialSelection,
      initialView: initialView,
      constraints: constraints,
    );
    return (context) {
      final textTheme = Theme.of(context).textTheme;
      final colorScheme = Theme.of(context).colorScheme;
      final localeTag = Localizations.localeOf(context).toLanguageTag();
      final localizations = MaterialLocalizations.of(context);
      final draftSelection = pickerStore.draftSelection.value;
      final pickerView = pickerStore.pickerView.value;
      final displayedDate = pickerStore.displayedDate.value;
      final appliedSelection = pickerStore.appliedSelection.value;

      return Dialog(
        key: const ValueKey("transactions-period-picker-dialog"),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height - 48,
          ),
          child: SizedBox(
            height: math.min(
              MediaQuery.sizeOf(context).height - 48,
              pickerView == TransactionsPeriodPickerView.day ? 444 : 360,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  TransactionsPeriodPickerNavigationWidget(
                    localeTag: localeTag,
                    pickerStore: pickerStore,
                  ),
                  SizedBox(
                    height: pickerView == TransactionsPeriodPickerView.day
                        ? 14
                        : 12,
                  ),
                  if (pickerView == TransactionsPeriodPickerView.day)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          formatTransactionsDayPanelLabel(
                            draftSelection,
                            localeTag,
                          ),
                          style: textTheme.labelLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: TransactionsPeriodPickerBodyWidget(
                      pickerView: pickerView,
                      displayedDate: displayedDate,
                      constraints: constraints,
                      draftSelection: draftSelection,
                      localeTag: localeTag,
                      onDateSelected: pickerStore.selectDate,
                      onMonthSelected: pickerStore.openDayViewForMonth,
                      onYearSelected: pickerStore.selectYear,
                    ),
                  ),
                  TransactionsPeriodPickerActionsWidget(
                    localizations: localizations,
                    appliedSelection: appliedSelection,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    };
  }
}
