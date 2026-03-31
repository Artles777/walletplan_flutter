import "package:flutter/widgets.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";

const ValueKey<String> transactionsPeriodPickerHeaderMonthKey = ValueKey(
  "transactions-period-picker-header-month",
);
const ValueKey<String> transactionsPeriodPickerHeaderYearKey = ValueKey(
  "transactions-period-picker-header-year",
);
const ValueKey<String> transactionsPeriodPickerScrollBodyKey = ValueKey(
  "transactions-period-picker-scroll-body",
);

String transactionsPeriodPickerDateKey(DateTime date) {
  final normalizedDate = startOfDay(date);

  return "${normalizedDate.year.toString().padLeft(4, "0")}-"
      "${normalizedDate.month.toString().padLeft(2, "0")}-"
      "${normalizedDate.day.toString().padLeft(2, "0")}";
}
