// ignore_for_file: always_use_package_imports

import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";
import "package:walletplan_flutter/utils/currency_formatter.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_period_header.widget.dart";

final DateTime defaultToday = DateTime(2026, 3, 20);

TransactionsPeriodSelection buildDefaultPeriod() {
  return TransactionsPeriodSelection(
    date: DateTime(2026, 3, 1),
    mode: TransactionsPeriodMode.month,
  );
}

Future<void> pumpHeader(
  WidgetTester tester, {
  required TransactionsPeriodSelection period,
  required ValueChanged<TransactionsPeriodSelection> onSelected,
  DateTime? today,
  DateTime? minDate,
  DateTime? maxDate,
  List<DateTime> blockedDates = const [],
  Locale locale = const Locale("en"),
}) {
  return tester.pumpWidget(
    MaterialApp(
      locale: locale,
      supportedLocales: const [Locale("en"), Locale("ru")],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: Scaffold(
        body: TransactionsPeriodHeaderWidget(
          period: period,
          total: 0,
          currency: AppCurrency.rub,
          onPeriodSelected: onSelected,
          today: today,
          minDate: minDate,
          maxDate: maxDate,
          blockedDates: blockedDates,
        ),
      ),
    ),
  );
}

Future<void> pumpDefaultHeader(
  WidgetTester tester, {
  required ValueChanged<TransactionsPeriodSelection> onSelected,
  Locale locale = const Locale("en"),
}) {
  return pumpHeader(
    tester,
    period: buildDefaultPeriod(),
    today: defaultToday,
    onSelected: onSelected,
    locale: locale,
  );
}

Future<void> openPicker(WidgetTester tester) async {
  await tester.tap(
    find.byKey(const ValueKey("transactions-period-picker-open")),
  );
  await tester.pumpAndSettle();
}

Future<void> openMonthPicker(WidgetTester tester) async {
  await tester.tap(
    find.byKey(const ValueKey("transactions-period-picker-header-month")),
  );
  await tester.pumpAndSettle();
}

Future<void> openYearPicker(WidgetTester tester) async {
  await tester.tap(
    find.byKey(const ValueKey("transactions-period-picker-header-year")),
  );
  await tester.pumpAndSettle();
}

Future<void> tapOk(WidgetTester tester) async {
  final okButton = find.byKey(const ValueKey("transactions-period-picker-ok"));
  await tester.ensureVisible(okButton);
  await tester.tap(okButton);
  await tester.pumpAndSettle();
}

Future<void> tapCancel(WidgetTester tester) async {
  final cancelButton = find.byKey(
    const ValueKey("transactions-period-picker-cancel"),
  );
  await tester.ensureVisible(cancelButton);
  await tester.tap(cancelButton);
  await tester.pumpAndSettle();
}

String dateKey(DateTime date) {
  final normalizedDate = startOfDay(date);

  return "${normalizedDate.year.toString().padLeft(4, "0")}-"
      "${normalizedDate.month.toString().padLeft(2, "0")}-"
      "${normalizedDate.day.toString().padLeft(2, "0")}";
}

Finder dayCell(DateTime date) {
  return find.byKey(
    ValueKey("transactions-period-picker-day-${dateKey(date)}"),
  );
}

Finder selectedDay(DateTime date) {
  return find.byKey(
    ValueKey("transactions-period-picker-day-${dateKey(date)}-selected"),
  );
}

Finder dayLabel(DateTime date) {
  return find.byKey(
    ValueKey("transactions-period-picker-day-${dateKey(date)}-label"),
  );
}

Finder monthButton(int month) {
  return find.byKey(ValueKey("transactions-period-picker-month-$month"));
}

Finder yearButton(int year) {
  return find.byKey(ValueKey("transactions-period-picker-year-$year"));
}

Finder focusedMonth(int month) {
  return find.byKey(
    ValueKey("transactions-period-picker-month-$month-focused"),
  );
}

Finder focusedYear(int year) {
  return find.byKey(ValueKey("transactions-period-picker-year-$year-focused"));
}

Finder scrollBody() {
  return find.byKey(const ValueKey("transactions-period-picker-scroll-body"));
}
