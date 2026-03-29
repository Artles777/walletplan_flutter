import "package:intl/intl.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";

String formatTransactionsPickerMonthLabel(DateTime date, String localeTag) {
  return _capitalizeLabel(DateFormat("LLLL", localeTag).format(date));
}

String formatTransactionsPickerMonthShortLabel(
  DateTime date,
  String localeTag,
) {
  return _capitalizeLabel(DateFormat("LLL", localeTag).format(date));
}

String formatTransactionsDayPanelLabel(
  TransactionsPeriodSelection selection,
  String localeTag,
) {
  final startLabel = DateFormat(
    "dd MMMM yyyy",
    localeTag,
  ).format(selection.date);
  final endDate = periodSelectionEndDate(selection);

  if (isSameDay(selection.date, endDate)) {
    return startLabel;
  }

  final endLabel = DateFormat("dd MMMM yyyy", localeTag).format(endDate);

  return "$startLabel - $endLabel";
}

String formatTransactionsPeriodLabel(
  TransactionsPeriodSelection period,
  String localeTag,
) {
  return switch (period.mode) {
    TransactionsPeriodMode.day => _formatDayPeriodLabel(period, localeTag),
    TransactionsPeriodMode.month => _capitalizeLabel(
      DateFormat("LLLL yyyy", localeTag).format(period.date),
    ),
    TransactionsPeriodMode.year => DateFormat(
      "yyyy",
      localeTag,
    ).format(period.date),
  };
}

String _formatDayPeriodLabel(
  TransactionsPeriodSelection selection,
  String localeTag,
) {
  final startLabel = DateFormat("dd.MM.yyyy", localeTag).format(selection.date);
  final endDate = periodSelectionEndDate(selection);

  if (isSameDay(selection.date, endDate)) {
    return startLabel;
  }

  final endLabel = DateFormat("dd.MM.yyyy", localeTag).format(endDate);

  return "$startLabel - $endLabel";
}

String _capitalizeLabel(String value) {
  if (value.isEmpty) {
    return value;
  }

  return "${value[0].toUpperCase()}${value.substring(1)}";
}
