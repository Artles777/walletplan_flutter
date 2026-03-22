import "package:flutter/material.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_list_view.widget.dart";

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: const TransactionsListViewWidget(),
    );
  }
}
