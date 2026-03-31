import "package:flutter/material.dart";
import "package:walletplan_flutter/i18n/strings.g.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions_filters.dart";
import "package:walletplan_flutter/utils/transactions_period_formatter.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_filters_chip_group.widget.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_filters_choice_group.widget.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_filters_section.widget.dart";

class TransactionsFiltersBodyWidget extends StatelessWidget {
  const TransactionsFiltersBodyWidget({
    required this.store,
    required this.onPickPeriod,
    super.key,
  });

  final TransactionsFiltersStore store;
  final VoidCallback onPickPeriod;

  @override
  Widget build(BuildContext context) {
    final state = store.draftState.value;
    final filters = state.filters;
    final localeTag = Localizations.localeOf(context).toLanguageTag();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TransactionsFiltersSectionWidget(
          title: context.t.transactionsFiltersPage.periodSectionTitle,
          compact: true,
          child: InkWell(
            key: const ValueKey("transactions-filters-period"),
            borderRadius: BorderRadius.circular(16),
            onTap: onPickPeriod,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month_rounded, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      formatTransactionsPeriodLabel(filters.period, localeTag),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TransactionsFiltersSectionWidget(
          title: context.t.transactionsFiltersPage.typeSectionTitle,
          child: TransactionsFiltersChoiceGroupWidget<TransactionsFilterType>(
            options: [
              (
                TransactionsFilterType.all,
                context.t.transactionsFiltersPage.allTypes,
              ),
              (
                TransactionsFilterType.expense,
                context.t.transactionsFiltersPage.expensesOnly,
              ),
              (
                TransactionsFilterType.income,
                context.t.transactionsFiltersPage.incomeOnly,
              ),
            ],
            selected: filters.type,
            onSelected: store.setType,
          ),
        ),
        const SizedBox(height: 12),
        TransactionsFiltersSectionWidget(
          title: context.t.transactionsFiltersPage.accountsSectionTitle,
          child: TransactionsFiltersChipGroupWidget(
            allLabel: context.t.transactionsFiltersPage.allAccounts,
            emptyLabel: context.t.transactionsFiltersPage.noOptions,
            options: store.accountOptions.value,
            selectedIds: filters.accountIds,
            onSelectAll: store.selectAllAccounts,
            onToggle: store.toggleAccount,
          ),
        ),
        const SizedBox(height: 12),
        TransactionsFiltersSectionWidget(
          title: context.t.transactionsFiltersPage.categoriesSectionTitle,
          child: TransactionsFiltersChipGroupWidget(
            allLabel: context.t.transactionsFiltersPage.allCategories,
            emptyLabel: context.t.transactionsFiltersPage.noOptions,
            options: store.categoryOptions.value,
            selectedIds: filters.categoryIds,
            onSelectAll: store.selectAllCategories,
            onToggle: store.toggleCategory,
          ),
        ),
        const SizedBox(height: 12),
        TransactionsFiltersSectionWidget(
          title: context.t.transactionsFiltersPage.presentationSectionTitle,
          child: TransactionsFiltersChoiceGroupWidget<TransactionsGroupBy>(
            options: [
              (
                TransactionsGroupBy.days,
                context.t.transactionsFiltersPage.byDays,
              ),
              (
                TransactionsGroupBy.categories,
                context.t.transactionsFiltersPage.byCategories,
              ),
            ],
            selected: state.presentation.groupBy,
            onSelected: store.setGroupBy,
          ),
        ),
        const SizedBox(height: 12),
        TransactionsFiltersSectionWidget(
          title: context.t.transactionsFiltersPage.advancedSectionTitle,
          child: SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(context.t.transactionsFiltersPage.includeTransfers),
            value: filters.includeTransfers,
            onChanged: store.setIncludeTransfers,
          ),
        ),
      ],
    );
  }
}
