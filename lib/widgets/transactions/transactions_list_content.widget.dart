import "package:flutter/material.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_load_error.widget.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_period_header.widget.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_scrollable_content.widget.dart";

class TransactionsListContentWidget extends StatelessWidget {
  const TransactionsListContentWidget({
    required this.loading,
    required this.period,
    required this.summary,
    required this.viewState,
    required this.padding,
    required this.onPeriodSelected,
    this.error,
    this.controller,
    super.key,
  });

  final ScrollController? controller;
  final EdgeInsets padding;
  final bool loading;
  final Object? error;
  final TransactionsPeriodSelection period;
  final TransactionsPeriodSummary summary;
  final TransactionsViewState viewState;
  final ValueChanged<TransactionsPeriodSelection> onPeriodSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (loading) const LinearProgressIndicator(minHeight: 2),
        if (error != null) const TransactionsLoadErrorWidget(),
        Padding(
          padding: EdgeInsets.only(left: padding.left, right: padding.right),
          child: TransactionsPeriodHeaderWidget(
            period: period,
            total: summary.total,
            currency: summary.currency,
            onPeriodSelected: onPeriodSelected,
          ),
        ),
        Expanded(
          child: TransactionsScrollableContentWidget(
            controller: controller,
            padding: padding,
            period: period,
            summary: summary,
            groupBy: viewState.presentation.groupBy,
          ),
        ),
      ],
    );
  }
}
