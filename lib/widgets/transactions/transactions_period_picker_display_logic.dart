part of "transactions_period_picker_logic.dart";

DateTime clampDisplayedMonthDay(
  TransactionsPeriodSelection selection,
  DateTime displayedDate,
) {
  final normalizedSelection = normalizePeriodSelection(selection);
  final selectionStart = normalizedSelection.date;
  final selectionEnd = periodSelectionEndDate(normalizedSelection);
  if (selectionEnd.year == selectionStart.year &&
      selectionEnd.month == selectionStart.month) {
    return DateTime(selectionStart.year, selectionStart.month);
  }

  final displayedMonth = DateTime(displayedDate.year, displayedDate.month);
  final clampedMonth = math.max(
    monthIndex(selectionStart),
    math.min(monthIndex(displayedMonth), monthIndex(selectionEnd)),
  );

  return DateTime(clampedMonth ~/ 12, clampedMonth % 12 + 1);
}

int monthIndex(DateTime date) {
  return date.year * 12 + date.month - 1;
}
