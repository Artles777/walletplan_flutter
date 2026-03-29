import "package:flutter_compositions/flutter_compositions.dart";
import "package:walletplan_flutter/stores/transactions/transactions_models.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions_period.dart";
import "package:walletplan_flutter/utils/currency_formatter.dart";

bool matchesPeriod(Transaction item, TransactionsPeriodSelection selection) {
  final normalized = normalizePeriodSelection(selection);
  final itemDate = startOfDay(item.createdAt);
  final periodEnd = periodSelectionEndDate(normalized);

  if (itemDate.isBefore(normalized.date) || itemDate.isAfter(periodEnd)) {
    return false;
  }

  if (periodExcludesDate(normalized, itemDate)) {
    return false;
  }

  switch (selection.mode) {
    case TransactionsPeriodMode.day:
      return true;
    case TransactionsPeriodMode.month:
      return true;
    case TransactionsPeriodMode.year:
      return true;
  }
}

num calculateTransactionsTotal(Iterable<Transaction> items) {
  return items.fold<num>(0, (total, item) => total + item.signedAmount);
}

List<TransactionDayGroup> groupTransactionsByDay(Iterable<Transaction> items) {
  final grouped = <DateTime, List<Transaction>>{};
  final sorted = items.toList(growable: false)
    ..sort((left, right) => right.createdAt.compareTo(left.createdAt));

  for (final item in sorted) {
    final key = startOfDay(item.createdAt);
    final dayItems = grouped.putIfAbsent(key, () => <Transaction>[]);
    dayItems.add(item);
  }

  final entries = grouped.entries.toList(growable: false)
    ..sort((left, right) => right.key.compareTo(left.key));

  return [
    for (final entry in entries)
      TransactionDayGroup(
        date: entry.key,
        items: entry.value,
        total: calculateTransactionsTotal(entry.value),
      ),
  ];
}

TransactionsPeriodSummary buildTransactionsPeriodSummary({
  required TransactionsPeriodSelection period,
  required Iterable<Transaction> items,
}) {
  final normalizedPeriod = normalizePeriodSelection(period);
  final periodItems =
      items.where((item) => matchesPeriod(item, period)).toList(growable: false)
        ..sort((left, right) => right.createdAt.compareTo(left.createdAt));

  final currency = periodItems.isEmpty
      ? AppCurrency.rub
      : periodItems.first.currency;

  return TransactionsPeriodSummary(
    period: normalizedPeriod.date,
    periodMode: period.mode,
    items: periodItems,
    groups: groupTransactionsByDay(periodItems),
    total: calculateTransactionsTotal(periodItems),
    currency: currency,
  );
}

ReadonlyRef<TransactionsPeriodSummary> useTransactionsSummary({
  required ReadonlyRef<TransactionsPeriodSelection> selectedPeriod,
  required Ref<Transactions> data,
}) {
  return computed(
    () => buildTransactionsPeriodSummary(
      period: selectedPeriod.value,
      items: data.value.items,
    ),
  );
}
