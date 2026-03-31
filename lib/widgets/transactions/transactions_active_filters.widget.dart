import "package:flutter/material.dart";
import "package:flutter_compositions/flutter_compositions.dart";
import "package:walletplan_flutter/i18n/strings.g.dart";
import "package:walletplan_flutter/stores/transactions/transactions_scope.widget.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions_filters.dart";

class TransactionsActiveFiltersWidget extends CompositionWidget {
  const TransactionsActiveFiltersWidget({super.key});

  @override
  Widget Function(BuildContext) setup() {
    final transactionsStore = inject(
      transactionsStoreKey,
      defaultValue: useTransactions(),
    );
    final viewStore = inject(
      transactionsViewStoreKey,
      defaultValue: useTransactionsViewStore(),
    );
    final accountOptions = computed(
      () => buildTransactionsAccountOptions(transactionsStore.data.value.items),
    );
    final categoryOptions = computed(
      () =>
          buildTransactionsCategoryOptions(transactionsStore.data.value.items),
    );

    return (context) {
      return _TransactionsActiveFiltersContentWidget(
        state: viewStore.appliedState.value,
        accountOptions: accountOptions.value,
        categoryOptions: categoryOptions.value,
        onReset: viewStore.resetAppliedState,
      );
    };
  }
}

class _TransactionsActiveFiltersContentWidget extends StatelessWidget {
  const _TransactionsActiveFiltersContentWidget({
    required this.state,
    required this.accountOptions,
    required this.categoryOptions,
    required this.onReset,
  });

  final TransactionsViewState state;
  final List<TransactionsFilterOption> accountOptions;
  final List<TransactionsFilterOption> categoryOptions;
  final VoidCallback onReset;

  String _labelForSingleSelection(
    List<String> ids,
    List<TransactionsFilterOption> options,
  ) {
    final optionById = {for (final option in options) option.id: option};

    return optionById[ids.single]?.label ?? ids.single;
  }

  List<String> _buildLabels(BuildContext context) {
    final labels = <String>[];
    final filters = state.filters;

    if (filters.type != TransactionsFilterType.all) {
      labels.add(
        filters.type == TransactionsFilterType.expense
            ? context.t.transactionsFiltersPage.expensesOnly
            : context.t.transactionsFiltersPage.incomeOnly,
      );
    }

    if (filters.accountIds.isNotEmpty) {
      labels.add(
        filters.accountIds.length == 1
            ? _labelForSingleSelection(filters.accountIds, accountOptions)
            : "${context.t.transactionsFiltersPage.accountsSectionTitle}: "
                  "${filters.accountIds.length}",
      );
    }

    if (filters.categoryIds.isNotEmpty) {
      labels.add(
        filters.categoryIds.length == 1
            ? _labelForSingleSelection(filters.categoryIds, categoryOptions)
            : "${context.t.transactionsFiltersPage.categoriesSectionTitle}: "
                  "${filters.categoryIds.length}",
      );
    }

    if (!filters.includeTransfers) {
      labels.add(context.t.transactionsPage.withoutTransfers);
    }

    if (state.presentation.groupBy == TransactionsGroupBy.categories) {
      labels.add(context.t.transactionsFiltersPage.byCategories);
    }

    return labels;
  }

  @override
  Widget build(BuildContext context) {
    final labels = _buildLabels(context);
    if (labels.isEmpty) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
          child: Row(
            children: [
              Icon(
                Icons.filter_alt_rounded,
                size: 16,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final label in labels) ...[
                        _TransactionsActiveFilterChipWidget(
                          label: label,
                          textStyle: textTheme.labelMedium,
                        ),
                        const SizedBox(width: 6),
                      ],
                    ],
                  ),
                ),
              ),
              IconButton(
                key: const ValueKey("transactions-active-filters-reset"),
                onPressed: onReset,
                icon: const Icon(Icons.close_rounded, size: 18),
                tooltip: context.t.common.reset,
                constraints: const BoxConstraints.tightFor(
                  width: 28,
                  height: 28,
                ),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TransactionsActiveFilterChipWidget extends StatelessWidget {
  const _TransactionsActiveFilterChipWidget({
    required this.label,
    required this.textStyle,
  });

  final String label;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(label, style: textStyle),
      ),
    );
  }
}
