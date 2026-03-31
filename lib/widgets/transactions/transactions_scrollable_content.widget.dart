import "package:flutter/material.dart";
import "package:walletplan_flutter/i18n/strings.g.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_category_section.widget.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_list_slivers.widget.dart";

class TransactionsScrollableContentWidget extends StatelessWidget {
  const TransactionsScrollableContentWidget({
    required this.period,
    required this.summary,
    required this.groupBy,
    required this.padding,
    this.controller,
    super.key,
  });

  final ScrollController? controller;
  final EdgeInsets padding;
  final TransactionsPeriodSelection period;
  final TransactionsPeriodSummary summary;
  final TransactionsGroupBy groupBy;

  List<TransactionDayGroup> get displayGroups {
    if (summary.groups.isNotEmpty) {
      return summary.groups;
    }

    return [TransactionDayGroup(date: period.date, items: const [], total: 0)];
  }

  @override
  Widget build(BuildContext context) {
    final groups = displayGroups;

    return CustomScrollView(
      controller: controller,
      slivers: [
        if (groupBy == TransactionsGroupBy.days)
          for (int index = 0; index < groups.length; index++)
            TransactionsDayGroupSliverWidget(
              group: groups[index],
              isLast: index == groups.length - 1,
              showTopSpacing: index > 0,
              emptyLabel: summary.groups.isEmpty
                  ? context.t.transactionsPage.empty
                  : null,
              padding: padding,
            )
        else if (summary.categorySections.isEmpty)
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              padding.left,
              8,
              padding.right,
              padding.bottom,
            ),
            sliver: SliverToBoxAdapter(
              child: TransactionsSummaryEmptyWidget(
                label: context.t.transactionsPage.empty,
              ),
            ),
          )
        else
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              padding.left,
              8,
              padding.right,
              padding.bottom,
            ),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  for (
                    int index = 0;
                    index < summary.categorySections.length;
                    index++
                  )
                    TransactionsCategorySectionWidget(
                      section: summary.categorySections[index],
                      isLast: index == summary.categorySections.length - 1,
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
