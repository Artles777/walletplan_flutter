import "package:flutter/material.dart";
import "package:flutter_compositions/flutter_compositions.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";

typedef TransactionsViewStore = (
  TransactionsViewState defaultState,
  ReadonlyRef<TransactionsViewState> appliedState,
  void Function(TransactionsViewState state) applyState,
  void Function(TransactionsPeriodSelection period) setPeriod,
  void Function() resetAppliedState,
);

extension TransactionsViewStoreExt on TransactionsViewStore {
  TransactionsViewState get defaultState => this.$1;

  ReadonlyRef<TransactionsViewState> get appliedState => this.$2;

  void Function(TransactionsViewState state) get applyState => this.$3;

  void Function(TransactionsPeriodSelection period) get setPeriod => this.$4;

  void Function() get resetAppliedState => this.$5;
}

TransactionsViewState defaultTransactionsViewState({DateTime? now}) {
  final currentDate = startOfDay(now ?? DateTime.now());

  return TransactionsViewState(
    filters: TransactionsFilters(
      period: TransactionsPeriodSelection(
        date: startOfMonth(currentDate),
        endDate: currentDate,
        mode: TransactionsPeriodMode.month,
      ),
    ),
    presentation: const TransactionsPresentation(),
  );
}

TransactionsViewStore useTransactionsViewStore({DateTime? now}) {
  final defaultState = defaultTransactionsViewState(now: now);
  final appliedState = ref(defaultState);

  void applyState(TransactionsViewState state) {
    appliedState.value = state.copyWith(
      filters: state.filters.copyWith(
        period: normalizePeriodSelection(state.filters.period),
      ),
    );
  }

  void setPeriod(TransactionsPeriodSelection period) {
    appliedState.value = appliedState.value.copyWith(
      filters: appliedState.value.filters.copyWith(
        period: normalizePeriodSelection(period),
      ),
    );
  }

  void resetAppliedState() {
    appliedState.value = defaultState;
  }

  return (defaultState, appliedState, applyState, setPeriod, resetAppliedState);
}

List<TransactionsFilterOption> buildTransactionsAccountOptions(
  Iterable<Transaction> items,
) {
  final uniqueOptions = <String, TransactionsFilterOption>{};

  for (final item in items) {
    uniqueOptions.putIfAbsent(
      item.resolvedAccountId,
      () => TransactionsFilterOption(
        id: item.resolvedAccountId,
        label: item.sourceName,
        icon: Icons.account_balance_wallet_rounded,
      ),
    );
  }

  final options = uniqueOptions.values.toList(growable: false)
    ..sort((left, right) => left.label.compareTo(right.label));

  return options;
}

List<TransactionsFilterOption> buildTransactionsCategoryOptions(
  Iterable<Transaction> items,
) {
  final uniqueOptions = <String, TransactionsFilterOption>{};

  for (final item in items) {
    uniqueOptions.putIfAbsent(
      item.resolvedCategoryId,
      () => TransactionsFilterOption(
        id: item.resolvedCategoryId,
        label: item.category,
        icon: item.icon,
        type: item.type,
      ),
    );
  }

  final options = uniqueOptions.values.toList(growable: false)
    ..sort((left, right) => left.label.compareTo(right.label));

  return options;
}

List<String> _toggleSelection(List<String> current, String id) {
  if (current.contains(id)) {
    return normalizeTransactionsSelectionIds(
      current.where((currentId) => currentId != id),
    );
  }

  return normalizeTransactionsSelectionIds([...current, id]);
}

typedef TransactionsFiltersStore = ({
  ReadonlyRef<TransactionsViewState> appliedState,
  Ref<TransactionsViewState> draftState,
  ReadonlyRef<List<TransactionsFilterOption>> accountOptions,
  ReadonlyRef<List<TransactionsFilterOption>> categoryOptions,
  ReadonlyRef<double> applyButtonProgress,
  ReadonlyRef<bool> hasChanges,
  ReadonlyRef<bool> canReset,
  VoidCallback apply,
  VoidCallback resetDraft,
  void Function(TransactionsFilterType value) setType,
  void Function(TransactionsPeriodSelection period) setPeriod,
  VoidCallback selectAllAccounts,
  void Function(String id) toggleAccount,
  VoidCallback selectAllCategories,
  void Function(String id) toggleCategory,
  void Function(TransactionsGroupBy value) setGroupBy,
  void Function(bool value) setIncludeTransfers,
});

TransactionsFiltersStore useTransactionsFilters({
  required TransactionsStore transactionsStore,
  required TransactionsViewStore viewStore,
  required VoidCallback onApply,
}) {
  final draftState = ref(viewStore.appliedState.value);
  final accountOptions = computed(
    () => buildTransactionsAccountOptions(transactionsStore.data.value.items),
  );
  final categoryOptions = computed(
    () => buildTransactionsCategoryOptions(transactionsStore.data.value.items),
  );
  final hasChanges = computed(
    () => draftState.value != viewStore.appliedState.value,
  );
  final canReset = computed(() => draftState.value != viewStore.defaultState);
  final (controller, progress) = useAnimationController(
    duration: const Duration(milliseconds: 220),
    reverseDuration: const Duration(milliseconds: 180),
  );

  watch(() => hasChanges.value, (nextValue, _) {
    if (nextValue) {
      controller.forward();

      return;
    }

    controller.reverse();
  });

  void updateDraft(TransactionsViewState nextState) {
    draftState.value = nextState;
  }

  void setType(TransactionsFilterType value) {
    updateDraft(
      draftState.value.copyWith(
        filters: draftState.value.filters.copyWith(type: value),
      ),
    );
  }

  void setPeriod(TransactionsPeriodSelection period) {
    updateDraft(
      draftState.value.copyWith(
        filters: draftState.value.filters.copyWith(
          period: normalizePeriodSelection(period),
        ),
      ),
    );
  }

  void selectAllAccounts() {
    updateDraft(
      draftState.value.copyWith(
        filters: draftState.value.filters.copyWith(accountIds: const []),
      ),
    );
  }

  void toggleAccount(String id) {
    updateDraft(
      draftState.value.copyWith(
        filters: draftState.value.filters.copyWith(
          accountIds: _toggleSelection(draftState.value.filters.accountIds, id),
        ),
      ),
    );
  }

  void selectAllCategories() {
    updateDraft(
      draftState.value.copyWith(
        filters: draftState.value.filters.copyWith(categoryIds: const []),
      ),
    );
  }

  void toggleCategory(String id) {
    updateDraft(
      draftState.value.copyWith(
        filters: draftState.value.filters.copyWith(
          categoryIds: _toggleSelection(
            draftState.value.filters.categoryIds,
            id,
          ),
        ),
      ),
    );
  }

  void setGroupBy(TransactionsGroupBy value) {
    updateDraft(
      draftState.value.copyWith(
        presentation: draftState.value.presentation.copyWith(groupBy: value),
      ),
    );
  }

  void setIncludeTransfers(bool value) {
    updateDraft(
      draftState.value.copyWith(
        filters: draftState.value.filters.copyWith(includeTransfers: value),
      ),
    );
  }

  void resetDraft() {
    draftState.value = viewStore.defaultState;
  }

  void apply() {
    if (!hasChanges.value) {
      return;
    }

    viewStore.applyState(draftState.value);
    onApply();
  }

  return (
    appliedState: viewStore.appliedState,
    draftState: draftState,
    accountOptions: accountOptions,
    categoryOptions: categoryOptions,
    applyButtonProgress: progress,
    hasChanges: hasChanges,
    canReset: canReset,
    apply: apply,
    resetDraft: resetDraft,
    setType: setType,
    setPeriod: setPeriod,
    selectAllAccounts: selectAllAccounts,
    toggleAccount: toggleAccount,
    selectAllCategories: selectAllCategories,
    toggleCategory: toggleCategory,
    setGroupBy: setGroupBy,
    setIncludeTransfers: setIncludeTransfers,
  );
}
