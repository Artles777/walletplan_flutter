import "package:flutter_compositions/flutter_compositions.dart";
import "package:walletplan_flutter/stores/transactions/transactions_models.dart";

typedef TransactionsPeriodStore = (
  ReadonlyRef<TransactionsPeriodSelection> selectedPeriod,
  void Function(TransactionsPeriodSelection period) setPeriod,
);

extension TransactionsPeriodStoreExt on TransactionsPeriodStore {
  ReadonlyRef<TransactionsPeriodSelection> get selectedPeriod => this.$1;

  void Function(TransactionsPeriodSelection period) get setPeriod => this.$2;
}

DateTime startOfMonth(DateTime date) {
  return DateTime(date.year, date.month);
}

DateTime startOfDay(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

DateTime startOfYear(DateTime date) {
  return DateTime(date.year);
}

bool isSameMonth(DateTime first, DateTime second) {
  return first.year == second.year && first.month == second.month;
}

bool isSameDay(DateTime first, DateTime second) {
  return first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}

bool isSameYear(DateTime first, DateTime second) {
  return first.year == second.year;
}

DateTime endOfMonth(DateTime date) {
  return DateTime(date.year, date.month + 1, 0);
}

DateTime endOfYear(DateTime date) {
  return DateTime(date.year + 1, 1, 0);
}

List<DateTime> normalizeExcludedDates(Iterable<DateTime> excludedDates) {
  final normalized = {
    for (final date in excludedDates) startOfDay(date),
  }.toList(growable: false)..sort((left, right) => left.compareTo(right));

  return normalized;
}

bool periodExcludesDate(TransactionsPeriodSelection selection, DateTime date) {
  final normalizedDate = startOfDay(date);

  return selection.excludedDates.any(
    (excludedDate) => isSameDay(excludedDate, normalizedDate),
  );
}

DateTime periodSelectionEndDate(TransactionsPeriodSelection selection) {
  final normalizedSelection = normalizePeriodSelection(selection);
  final explicitEndDate = normalizedSelection.endDate;
  if (explicitEndDate != null) {
    return explicitEndDate;
  }

  return switch (normalizedSelection.mode) {
    TransactionsPeriodMode.day => normalizedSelection.date,
    TransactionsPeriodMode.month => endOfMonth(normalizedSelection.date),
    TransactionsPeriodMode.year => endOfYear(normalizedSelection.date),
  };
}

TransactionsPeriodSelection normalizePeriodSelection(
  TransactionsPeriodSelection selection,
) {
  final normalizedExcludedDates = normalizeExcludedDates(
    selection.excludedDates,
  );

  switch (selection.mode) {
    case TransactionsPeriodMode.day:
      final startDate = startOfDay(selection.date);
      final endDate = selection.endDate == null
          ? null
          : startOfDay(selection.endDate!);

      if (endDate != null && endDate.isBefore(startDate)) {
        return TransactionsPeriodSelection(
          date: endDate,
          endDate: startDate,
          mode: selection.mode,
          excludedDates: normalizedExcludedDates
              .where((excludedDate) {
                return !excludedDate.isBefore(endDate) &&
                    !excludedDate.isAfter(startDate);
              })
              .toList(growable: false),
        );
      }

      return TransactionsPeriodSelection(
        date: startDate,
        endDate: endDate,
        mode: selection.mode,
        excludedDates: normalizedExcludedDates
            .where((excludedDate) {
              final periodEnd = endDate ?? startDate;

              return !excludedDate.isBefore(startDate) &&
                  !excludedDate.isAfter(periodEnd);
            })
            .toList(growable: false),
      );
    case TransactionsPeriodMode.month:
      final monthStart = selection.endDate == null
          ? startOfMonth(selection.date)
          : startOfDay(selection.date);
      final monthEnd = selection.endDate == null
          ? null
          : startOfDay(selection.endDate!);

      if (monthEnd != null && monthEnd.isBefore(monthStart)) {
        return TransactionsPeriodSelection(
          date: monthEnd,
          endDate: monthStart,
          mode: selection.mode,
          excludedDates: normalizedExcludedDates
              .where((excludedDate) {
                return !excludedDate.isBefore(monthEnd) &&
                    !excludedDate.isAfter(monthStart);
              })
              .toList(growable: false),
        );
      }

      return TransactionsPeriodSelection(
        date: monthStart,
        endDate: monthEnd,
        mode: selection.mode,
        excludedDates: normalizedExcludedDates
            .where((excludedDate) {
              final periodEnd = monthEnd ?? endOfMonth(monthStart);

              return !excludedDate.isBefore(monthStart) &&
                  !excludedDate.isAfter(periodEnd);
            })
            .toList(growable: false),
      );
    case TransactionsPeriodMode.year:
      final yearStart = selection.endDate == null
          ? startOfYear(selection.date)
          : startOfDay(selection.date);
      final yearEnd = selection.endDate == null
          ? null
          : startOfDay(selection.endDate!);

      if (yearEnd != null && yearEnd.isBefore(yearStart)) {
        return TransactionsPeriodSelection(
          date: yearEnd,
          endDate: yearStart,
          mode: selection.mode,
          excludedDates: normalizedExcludedDates
              .where((excludedDate) {
                return !excludedDate.isBefore(yearEnd) &&
                    !excludedDate.isAfter(yearStart);
              })
              .toList(growable: false),
        );
      }

      return TransactionsPeriodSelection(
        date: yearStart,
        endDate: yearEnd,
        mode: selection.mode,
        excludedDates: normalizedExcludedDates
            .where((excludedDate) {
              final periodEnd = yearEnd ?? endOfYear(yearStart);

              return !excludedDate.isBefore(yearStart) &&
                  !excludedDate.isAfter(periodEnd);
            })
            .toList(growable: false),
      );
  }
}

TransactionsPeriodSelection buildDefaultTransactionsPeriodSelection({
  DateTime? now,
}) {
  final currentDate = now ?? DateTime.now();

  return TransactionsPeriodSelection(
    date: startOfMonth(currentDate),
    mode: TransactionsPeriodMode.month,
  );
}

TransactionsPeriodStore useTransactionsPeriod() {
  final selectedPeriod = ref(buildDefaultTransactionsPeriodSelection());

  void setPeriod(TransactionsPeriodSelection period) {
    selectedPeriod.value = normalizePeriodSelection(period);
  }

  return (selectedPeriod, setPeriod);
}
