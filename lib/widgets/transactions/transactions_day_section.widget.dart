import "package:flutter/material.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_day_group_card.widget.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_day_header.widget.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_day_section_content.widget.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_day_section_surface.widget.dart";

class TransactionsDaySectionWidget extends StatelessWidget {
  const TransactionsDaySectionWidget({
    required this.group,
    this.emptyLabel,
    this.showHeader = true,
    this.headerKey,
    super.key,
  });

  final TransactionDayGroup group;
  final String? emptyLabel;
  final bool showHeader;
  final Key? headerKey;

  @override
  Widget build(BuildContext context) {
    return TransactionsDaySectionSurfaceWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showHeader)
            TransactionsDayHeaderWidget(key: headerKey, group: group),
          TransactionsDayGroupCardWidget(
            child: TransactionsDaySectionContentWidget(
              group: group,
              emptyLabel: emptyLabel,
            ),
          ),
        ],
      ),
    );
  }
}
