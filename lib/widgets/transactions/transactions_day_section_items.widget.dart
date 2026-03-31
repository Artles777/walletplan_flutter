import "package:flutter/material.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";
import "package:walletplan_flutter/widgets/transactions/transaction_list_item.widget.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_day_section_divider.widget.dart";

class TransactionsDaySectionItemsWidget extends StatelessWidget {
  const TransactionsDaySectionItemsWidget({required this.items, super.key});

  final List<Transaction> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int index = 0; index < items.length; index++) ...[
          if (index > 0) const TransactionsDaySectionDividerWidget(),
          TransactionListItemWidget(transaction: items[index]),
        ],
      ],
    );
  }
}
