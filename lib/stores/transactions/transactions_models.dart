import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:walletplan_flutter/utils/currency_formatter.dart";

enum TransactionType { expense, income }

enum TransactionsPeriodMode { day, month, year }

enum TransactionsFilterType { all, expense, income }

enum TransactionsGroupBy { days, categories }

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

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TransactionsPeriodSelection &&
            runtimeType == other.runtimeType &&
            date == other.date &&
            mode == other.mode &&
            endDate == other.endDate &&
            listEquals(excludedDates, other.excludedDates);
  }

  @override
  int get hashCode {
    return Object.hash(date, mode, endDate, Object.hashAll(excludedDates));
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
    this.accountId,
    this.categoryId,
    this.isTransfer = false,
    this.merchant,
    this.tags = const [],
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
  final String? accountId;
  final String? categoryId;
  final bool isTransfer;
  final String? merchant;
  final List<String> tags;

  num get signedAmount {
    return type == TransactionType.expense ? -amount : amount;
  }

  String get resolvedAccountId => accountId ?? sourceName;

  String get resolvedCategoryId => categoryId ?? category;
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

class TransactionCategoryGroup {
  const TransactionCategoryGroup({
    required this.id,
    required this.label,
    required this.icon,
    required this.type,
    required this.items,
    required this.total,
    required this.currency,
  });

  final String id;
  final String label;
  final IconData icon;
  final TransactionType type;
  final List<Transaction> items;
  final num total;
  final AppCurrency currency;

  int get count => items.length;
}

class TransactionCategorySection {
  const TransactionCategorySection({
    required this.type,
    required this.items,
    required this.total,
  });

  final TransactionType type;
  final List<TransactionCategoryGroup> items;
  final num total;
}

List<String> normalizeTransactionsSelectionIds(Iterable<String> ids) {
  final normalized = ids.toSet().toList(growable: false)..sort();

  return normalized;
}

class TransactionsFilters {
  const TransactionsFilters({
    required this.period,
    this.type = TransactionsFilterType.all,
    this.accountIds = const [],
    this.categoryIds = const [],
    this.includeTransfers = true,
  });

  final TransactionsPeriodSelection period;
  final TransactionsFilterType type;
  final List<String> accountIds;
  final List<String> categoryIds;
  final bool includeTransfers;

  TransactionsFilters copyWith({
    TransactionsPeriodSelection? period,
    TransactionsFilterType? type,
    List<String>? accountIds,
    List<String>? categoryIds,
    bool? includeTransfers,
  }) {
    return TransactionsFilters(
      period: period ?? this.period,
      type: type ?? this.type,
      accountIds: normalizeTransactionsSelectionIds(
        accountIds ?? this.accountIds,
      ),
      categoryIds: normalizeTransactionsSelectionIds(
        categoryIds ?? this.categoryIds,
      ),
      includeTransfers: includeTransfers ?? this.includeTransfers,
    );
  }

  bool get hasAccountFilter => accountIds.isNotEmpty;

  bool get hasCategoryFilter => categoryIds.isNotEmpty;

  bool get hasActiveSelectionFilters {
    return type != TransactionsFilterType.all ||
        hasAccountFilter ||
        hasCategoryFilter ||
        !includeTransfers;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TransactionsFilters &&
            runtimeType == other.runtimeType &&
            period == other.period &&
            type == other.type &&
            includeTransfers == other.includeTransfers &&
            listEquals(accountIds, other.accountIds) &&
            listEquals(categoryIds, other.categoryIds);
  }

  @override
  int get hashCode {
    return Object.hash(
      period,
      type,
      includeTransfers,
      Object.hashAll(accountIds),
      Object.hashAll(categoryIds),
    );
  }
}

class TransactionsPresentation {
  const TransactionsPresentation({this.groupBy = TransactionsGroupBy.days});

  final TransactionsGroupBy groupBy;

  TransactionsPresentation copyWith({TransactionsGroupBy? groupBy}) {
    return TransactionsPresentation(groupBy: groupBy ?? this.groupBy);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TransactionsPresentation &&
            runtimeType == other.runtimeType &&
            groupBy == other.groupBy;
  }

  @override
  int get hashCode => groupBy.hashCode;
}

class TransactionsViewState {
  const TransactionsViewState({
    required this.filters,
    required this.presentation,
  });

  final TransactionsFilters filters;
  final TransactionsPresentation presentation;

  TransactionsViewState copyWith({
    TransactionsFilters? filters,
    TransactionsPresentation? presentation,
  }) {
    return TransactionsViewState(
      filters: filters ?? this.filters,
      presentation: presentation ?? this.presentation,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TransactionsViewState &&
            runtimeType == other.runtimeType &&
            filters == other.filters &&
            presentation == other.presentation;
  }

  @override
  int get hashCode => Object.hash(filters, presentation);
}

int countAppliedTransactionsFilters({
  required TransactionsViewState state,
  required TransactionsViewState defaultState,
}) {
  int count = 0;

  if (state.filters.period != defaultState.filters.period) {
    count += 1;
  }

  if (state.filters.type != defaultState.filters.type) {
    count += 1;
  }

  if (state.filters.accountIds.isNotEmpty) {
    count += 1;
  }

  if (state.filters.categoryIds.isNotEmpty) {
    count += 1;
  }

  if (state.filters.includeTransfers != defaultState.filters.includeTransfers) {
    count += 1;
  }

  return count;
}

class TransactionsFilterState {
  const TransactionsFilterState({required this.applied, required this.draft});

  final TransactionsViewState applied;
  final TransactionsViewState draft;

  TransactionsFilterState copyWith({
    TransactionsViewState? applied,
    TransactionsViewState? draft,
  }) {
    return TransactionsFilterState(
      applied: applied ?? this.applied,
      draft: draft ?? this.draft,
    );
  }
}

class TransactionsFilterOption {
  const TransactionsFilterOption({
    required this.id,
    required this.label,
    this.icon,
    this.type,
  });

  final String id;
  final String label;
  final IconData? icon;
  final TransactionType? type;
}

class TransactionsPeriodSummary {
  const TransactionsPeriodSummary({
    required this.period,
    required this.periodMode,
    required this.items,
    required this.groups,
    required this.total,
    required this.currency,
    this.categorySections = const [],
  });

  final DateTime period;
  final TransactionsPeriodMode periodMode;
  final List<Transaction> items;
  final List<TransactionDayGroup> groups;
  final List<TransactionCategorySection> categorySections;
  final num total;
  final AppCurrency currency;
}
