import "package:flutter/material.dart";
import "package:flutter_compositions/flutter_compositions.dart";
import "package:walletplan_flutter/stores/transactions/transactions_scope.widget.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions_filters.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions_view_summary.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_list_content.widget.dart";

class TransactionsListViewWidget extends CompositionWidget {
  const TransactionsListViewWidget({
    this.controller,
    this.padding = const EdgeInsets.fromLTRB(16, 0, 16, 24),
    super.key,
  });

  final ScrollController? controller;
  final EdgeInsets padding;

  @override
  Widget Function(BuildContext) setup() {
    final transactionsState = inject(
      transactionsStoreKey,
      defaultValue: useTransactions(),
    );
    final viewStore = inject(
      transactionsViewStoreKey,
      defaultValue: useTransactionsViewStore(),
    );
    final viewSummary = useTransactionsViewSummary(
      appliedState: viewStore.appliedState,
      data: transactionsState.data,
    );

    onMounted(() {
      transactionsState.getData(refresh: true);
    });

    return (context) {
      return TransactionsListContentWidget(
        controller: controller,
        padding: padding,
        loading: transactionsState.loading.value,
        error: transactionsState.error.value,
        period: viewStore.appliedState.value.filters.period,
        summary: viewSummary.value,
        viewState: viewStore.appliedState.value,
        onPeriodSelected: viewStore.setPeriod,
      );
    };
  }
}
