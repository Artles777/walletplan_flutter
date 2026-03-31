import "package:flutter/material.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";
import "package:walletplan_flutter/utils/currency_formatter.dart";
import "package:walletplan_flutter/utils/transactions_period_formatter.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_period_picker_dialog.widget.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_period_picker_logic.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions_period_picker.dart";

class TransactionsPeriodHeaderWidget extends StatelessWidget {
  const TransactionsPeriodHeaderWidget({
    required this.period,
    required this.total,
    required this.currency,
    required this.onPeriodSelected,
    this.today,
    this.minDate,
    this.maxDate,
    this.blockedDates = const [],
    super.key,
  });

  final TransactionsPeriodSelection period;
  final num total;
  final AppCurrency currency;
  final ValueChanged<TransactionsPeriodSelection> onPeriodSelected;
  final DateTime? today;
  final DateTime? minDate;
  final DateTime? maxDate;
  final List<DateTime> blockedDates;

  Future<void> _pickPeriod(BuildContext context) async {
    final picked = await showTransactionsPeriodPicker(
      context,
      period: period,
      today: today,
      minDate: minDate,
      maxDate: maxDate,
      blockedDates: blockedDates,
    );

    if (picked != null && context.mounted) {
      onPeriodSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final periodLabel = formatTransactionsPeriodLabel(period, localeTag);
    final totalText = formatSignedCurrencyAmount(
      total,
      currency,
      withPlusSign: true,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 6),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 12, 5),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  key: const ValueKey("transactions-period-picker-open"),
                  borderRadius: BorderRadius.circular(999),
                  onTap: () => _pickPeriod(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 5,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_month_rounded,
                          size: 15,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            periodLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.1,
                              height: 1.0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          Icons.expand_more_rounded,
                          size: 15,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                totalText,
                style: textTheme.bodyMedium?.copyWith(
                  color: total < 0 ? colorScheme.error : colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<TransactionsPeriodSelection?> showTransactionsPeriodPicker(
  BuildContext context, {
  required TransactionsPeriodSelection period,
  DateTime? today,
  DateTime? minDate,
  DateTime? maxDate,
  List<DateTime> blockedDates = const [],
}) async {
  final constraints = TransactionsPeriodPickerConstraints(
    today: today ?? DateTime.now(),
    minDate: minDate,
    maxDate: maxDate,
    blockedDates: blockedDates,
  );
  final normalizedAppliedSelection =
      clampPeriodSelectionToConstraints(constraints, period) ??
      fallbackPeriodSelection(constraints);

  if (normalizedAppliedSelection == null) {
    return null;
  }

  final initialView = period.mode == TransactionsPeriodMode.year
      ? TransactionsPeriodPickerView.year
      : TransactionsPeriodPickerView.day;

  return showDialog<TransactionsPeriodSelection>(
    context: context,
    builder: (context) {
      return TransactionsPeriodPickerDialogWidget(
        initialSelection: normalizedAppliedSelection,
        initialView: initialView,
        constraints: constraints,
      );
    },
  );
}
