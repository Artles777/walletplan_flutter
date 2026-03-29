import "package:flutter/material.dart";
import "package:walletplan_flutter/i18n/strings.g.dart";

class TransactionsDaySectionEmptyWidget extends StatelessWidget {
  const TransactionsDaySectionEmptyWidget({this.label, super.key});

  final String? label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label ?? context.t.transactionsPage.empty,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
