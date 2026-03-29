import "package:flutter/material.dart";
import "package:walletplan_flutter/utils/currency_formatter.dart";

enum TransactionType { expense, income }

enum TransactionsPeriodMode { day, month, year }

const Object unsetEndDate = Object();
const Object unsetExcludedDates = Object();

class TransactionsPeriodSelection {
  const TransactionsPeriodSelection({
    required this.date,
    required this.mode,
    this.endDate,
    this.excludedDates = const [],
  });

  final DateTime date;
  final TransactionsPeriodMode mode;
  final DateTime? endDate;
  final List<DateTime> excludedDates;

  TransactionsPeriodSelection copyWith({
    DateTime? date,
    TransactionsPeriodMode? mode,
    Object? endDate = unsetEndDate,
    Object? excludedDates = unsetExcludedDates,
  }) {
    return TransactionsPeriodSelection(
      date: date ?? this.date,
      mode: mode ?? this.mode,
      endDate: identical(endDate, unsetEndDate)
          ? this.endDate
          : endDate as DateTime?,
      excludedDates: identical(excludedDates, unsetExcludedDates)
          ? this.excludedDates
          : excludedDates as List<DateTime>,
    );
  }
}

class Transactions {
  Transactions({required this.items, required this.count});

  final List<Transaction> items;
  final int count;

  Transactions copyWith({List<Transaction>? items, int? count}) {
    return Transactions(items: items ?? this.items, count: count ?? this.count);
  }
}

class Transaction {
  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.currency,
    required this.category,
    required this.title,
    required this.subtitle,
    required this.sourceName,
    required this.icon,
    required this.createdAt,
  });

  final String id;
  final TransactionType type;
  final num amount;
  final AppCurrency currency;
  final String category;
  final String title;
  final String subtitle;
  final String sourceName;
  final IconData icon;
  final DateTime createdAt;

  num get signedAmount {
    return type == TransactionType.expense ? -amount : amount;
  }
}

class TransactionDayGroup {
  const TransactionDayGroup({
    required this.date,
    required this.items,
    required this.total,
  });

  final DateTime date;
  final List<Transaction> items;
  final num total;
}

class TransactionsPeriodSummary {
  const TransactionsPeriodSummary({
    required this.period,
    required this.periodMode,
    required this.items,
    required this.groups,
    required this.total,
    required this.currency,
  });

  final DateTime period;
  final TransactionsPeriodMode periodMode;
  final List<Transaction> items;
  final List<TransactionDayGroup> groups;
  final num total;
  final AppCurrency currency;
}
