import "package:flutter/material.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";

class TransactionsPeriodPickerActionsWidget extends StatelessWidget {
  const TransactionsPeriodPickerActionsWidget({
    required this.localizations,
    required this.appliedSelection,
    super.key,
  });

  final MaterialLocalizations localizations;
  final TransactionsPeriodSelection? appliedSelection;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            key: const ValueKey("transactions-period-picker-cancel"),
            onPressed: () => Navigator.of(context).pop(),
            child: Text(localizations.cancelButtonLabel),
          ),
          const SizedBox(width: 8),
          FilledButton(
            key: const ValueKey("transactions-period-picker-ok"),
            onPressed: appliedSelection == null
                ? null
                : () => Navigator.of(context).pop(appliedSelection),
            child: Text(localizations.okButtonLabel),
          ),
        ],
      ),
    );
  }
}
