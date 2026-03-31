import "package:intl/intl.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";

String formatTransactionsPickerMonthLabel(DateTime date, String localeTag) {
  return _pickerMonthLabel(
    _monthName(date.month, localeTag, style: _MonthNameStyle.standalone),
    localeTag,
  );
}

String formatTransactionsPickerMonthShortLabel(
  DateTime date,
  String localeTag,
) {
  return _pickerMonthLabel(
    _monthName(date.month, localeTag, style: _MonthNameStyle.short),
    localeTag,
  );
}

String formatTransactionsDayPanelLabel(
  TransactionsPeriodSelection selection,
  String localeTag,
) {
  final startLabel = _formatDayMonthYearLabel(selection.date, localeTag);
  final endDate = periodSelectionEndDate(selection);

  if (isSameDay(selection.date, endDate)) {
    return startLabel;
  }

  final endLabel = _formatDayMonthYearLabel(endDate, localeTag);

  return "$startLabel - $endLabel";
}

String formatTransactionsPeriodLabel(
  TransactionsPeriodSelection period,
  String localeTag,
) {
  return switch (period.mode) {
    TransactionsPeriodMode.day => _formatDayPeriodLabel(period, localeTag),
    TransactionsPeriodMode.month => _formatMonthYearLabel(
      period.date,
      localeTag,
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

String _pickerMonthLabel(String value, String localeTag) {
  final languageCode = localeTag.split("-").first.toLowerCase();
  if (languageCode == "ru") {
    return value;
  }

  return _capitalizeLabel(value);
}

String _formatMonthYearLabel(DateTime date, String localeTag) {
  final monthLabel = _monthName(
    date.month,
    localeTag,
    style: _MonthNameStyle.standalone,
  );

  return _capitalizeLabel("$monthLabel ${date.year}");
}

String _formatDayMonthYearLabel(DateTime date, String localeTag) {
  final day = date.day.toString().padLeft(2, "0");
  final monthLabel = _monthName(
    date.month,
    localeTag,
    style: _MonthNameStyle.withDay,
  );

  return "$day $monthLabel ${date.year}";
}

enum _MonthNameStyle { standalone, withDay, short }

String _monthName(
  int month,
  String localeTag, {
  required _MonthNameStyle style,
}) {
  final languageCode = localeTag.split("-").first.toLowerCase();

  return switch (languageCode) {
    "ru" => switch (style) {
      _MonthNameStyle.standalone => _ruStandaloneMonths[month - 1],
      _MonthNameStyle.withDay => _ruMonthsWithDay[month - 1],
      _MonthNameStyle.short => _ruShortMonths[month - 1],
    },
    _ => _intlMonthName(month, localeTag, style: style),
  };
}

String _intlMonthName(
  int month,
  String localeTag, {
  required _MonthNameStyle style,
}) {
  final sampleDate = DateTime(2026, month, 1);

  return switch (style) {
    _MonthNameStyle.standalone => DateFormat(
      "LLLL",
      localeTag,
    ).format(sampleDate),
    _MonthNameStyle.withDay => DateFormat("MMMM", localeTag).format(sampleDate),
    _MonthNameStyle.short => DateFormat("LLL", localeTag).format(sampleDate),
  };
}

const List<String> _ruStandaloneMonths = [
  "январь",
  "февраль",
  "март",
  "апрель",
  "май",
  "июнь",
  "июль",
  "август",
  "сентябрь",
  "октябрь",
  "ноябрь",
  "декабрь",
];

const List<String> _ruMonthsWithDay = [
  "января",
  "февраля",
  "марта",
  "апреля",
  "мая",
  "июня",
  "июля",
  "августа",
  "сентября",
  "октября",
  "ноября",
  "декабря",
];

const List<String> _ruShortMonths = [
  "янв",
  "фев",
  "мар",
  "апр",
  "май",
  "июн",
  "июл",
  "авг",
  "сен",
  "окт",
  "ноя",
  "дек",
];
