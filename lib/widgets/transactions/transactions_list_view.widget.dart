import "package:flutter/material.dart";
import "package:flutter_compositions/flutter_compositions.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";

class TransactionsListViewWidget extends CompositionWidget {
  const TransactionsListViewWidget({
    this.controller,
    this.padding = const EdgeInsets.all(16),
    super.key,
  });

  final ScrollController? controller;
  final EdgeInsets padding;

  @override
  Widget Function(BuildContext) setup() {
    final (data, loading, error, getData, loadMore, _, _) = useTransactions();

    onMounted(() {
      getData(refresh: true);
    });

    return (context) => Column(
      children: [
        if (loading.value) const LinearProgressIndicator(),
        if (error.value != null) Text("Ошибка: ${error.value}"),
        Expanded(
          child: ListView.builder(
            itemCount: data.value.count,
            itemBuilder: (_, i) => Text(data.value.items[i].title),
          ),
        ),
      ],
    );
  }
}
