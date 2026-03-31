import "package:flutter_compositions/flutter_compositions.dart";
import "package:walletplan_flutter/stores/transactions/transactions_models.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions_period.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions_summary.dart";
import "package:walletplan_flutter/utils/currency_formatter.dart";

bool matchesTransactionsFilterType(
  Transaction item,
  TransactionsFilterType filterType,
) {
  return switch (filterType) {
    TransactionsFilterType.all => true,
    TransactionsFilterType.expense => item.type == TransactionType.expense,
    TransactionsFilterType.income => item.type == TransactionType.income,
  };
}

bool matchesTransactionsFilters(Transaction item, TransactionsFilters filters) {
  if (!matchesPeriod(item, filters.period)) {
    return false;
  }

  if (!matchesTransactionsFilterType(item, filters.type)) {
    return false;
  }

  if (!filters.includeTransfers && item.isTransfer) {
    return false;
  }

  if (filters.accountIds.isNotEmpty &&
      !filters.accountIds.contains(item.resolvedAccountId)) {
    return false;
  }

  if (filters.categoryIds.isNotEmpty &&
      !filters.categoryIds.contains(item.resolvedCategoryId)) {
    return false;
  }

  return true;
}

List<Transaction> filterTransactionsForView({
  required Iterable<Transaction> items,
  required TransactionsFilters filters,
}) {
  return items
      .where((item) => matchesTransactionsFilters(item, filters))
      .toList(growable: false)
    ..sort((left, right) => right.createdAt.compareTo(left.createdAt));
}

List<TransactionCategoryGroup> _groupSingleCategorySection(
  Iterable<Transaction> items,
) {
  final grouped = <String, List<Transaction>>{};

  for (final item in items) {
    final groupItems = grouped.putIfAbsent(
      item.resolvedCategoryId,
      () => <Transaction>[],
    );
    groupItems.add(item);
  }

  final groups =
      [
        for (final entry in grouped.entries)
          TransactionCategoryGroup(
            id: entry.key,
            label: entry.value.first.category,
            icon: entry.value.first.icon,
            type: entry.value.first.type,
            items: entry.value,
            total: calculateTransactionsTotal(entry.value),
            currency: entry.value.first.currency,
          ),
      ]..sort((left, right) {
        final byMagnitude = right.total.abs().compareTo(left.total.abs());
        if (byMagnitude != 0) {
          return byMagnitude;
        }

        return left.label.compareTo(right.label);
      });

  return groups;
}

List<TransactionCategorySection> groupTransactionsByCategory({
  required Iterable<Transaction> items,
  required TransactionsFilterType type,
}) {
  Iterable<TransactionType> sectionTypes() sync* {
    if (type == TransactionsFilterType.all) {
      yield TransactionType.expense;
      yield TransactionType.income;

      return;
    }

    yield type == TransactionsFilterType.expense
        ? TransactionType.expense
        : TransactionType.income;
  }

  final sections = <TransactionCategorySection>[];

  for (final sectionType in sectionTypes()) {
    final sectionItems = items.where((item) => item.type == sectionType);
    final categoryGroups = _groupSingleCategorySection(sectionItems);
    if (categoryGroups.isEmpty) {
      continue;
    }

    sections.add(
      TransactionCategorySection(
        type: sectionType,
        items: categoryGroups,
        total: categoryGroups.fold<num>(
          0,
          (runningTotal, group) => runningTotal + group.total,
        ),
      ),
    );
  }

  return sections;
}

TransactionsPeriodSummary buildTransactionsViewSummary({
  required TransactionsViewState viewState,
  required Iterable<Transaction> items,
}) {
  final filteredItems = filterTransactionsForView(
    items: items,
    filters: viewState.filters,
  );
  final currency = filteredItems.isEmpty
      ? AppCurrency.rub
      : filteredItems.first.currency;

  return TransactionsPeriodSummary(
    period: normalizePeriodSelection(viewState.filters.period).date,
    periodMode: viewState.filters.period.mode,
    items: filteredItems,
    groups: groupTransactionsByDay(filteredItems),
    categorySections: groupTransactionsByCategory(
      items: filteredItems,
      type: viewState.filters.type,
    ),
    total: calculateTransactionsTotal(filteredItems),
    currency: currency,
  );
}

ReadonlyRef<TransactionsPeriodSummary> useTransactionsViewSummary({
  required ReadonlyRef<TransactionsViewState> appliedState,
  required Ref<Transactions> data,
}) {
  return computed(
    () => buildTransactionsViewSummary(
      viewState: appliedState.value,
      items: data.value.items,
    ),
  );
}
