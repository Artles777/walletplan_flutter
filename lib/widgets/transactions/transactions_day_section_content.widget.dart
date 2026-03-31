import "package:flutter/material.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_day_section_empty.widget.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_day_section_items.widget.dart";

class TransactionsDaySectionContentWidget extends StatelessWidget {
  const TransactionsDaySectionContentWidget({
    required this.group,
    this.emptyLabel,
    super.key,
  });

  final TransactionDayGroup group;
  final String? emptyLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
      child: group.items.isEmpty
          ? TransactionsDaySectionEmptyWidget(label: emptyLabel)
          : TransactionsDaySectionItemsWidget(items: group.items),
    );
  }
}
