import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";
import "package:walletplan_flutter/utils/currency_formatter.dart";

class TransactionListItemWidget extends StatelessWidget {
  const TransactionListItemWidget({required this.transaction, super.key});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final isExpense = transaction.type == TransactionType.expense;
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final timeLabel = DateFormat(
      "HH:mm",
      localeTag,
    ).format(transaction.createdAt);
    final secondaryLine = transaction.subtitle.isEmpty
        ? timeLabel
        : "${transaction.subtitle} · $timeLabel";
    final iconBackground = isExpense
        ? Colors.indigo.withValues(alpha: 0.10)
        : Colors.teal.withValues(alpha: 0.12);
    final iconColor = isExpense
        ? const Color(0xFF5B4AA3)
        : Colors.teal.shade600;
    final amountText = formatSignedCurrencyAmount(
      transaction.signedAmount,
      transaction.currency,
      withPlusSign: true,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Icon(transaction.icon, color: iconColor, size: 20),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tt.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.15,
                    letterSpacing: -0.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  secondaryLine,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: tt.labelMedium?.copyWith(
                    color: cs.onSurfaceVariant.withValues(alpha: 0.84),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 102),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amountText,
                  textAlign: TextAlign.end,
                  style: tt.bodyMedium?.copyWith(
                    color: isExpense ? cs.onSurface : Colors.teal.shade600,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                    letterSpacing: -0.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  transaction.sourceName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: tt.labelMedium?.copyWith(
                    color: cs.onSurfaceVariant.withValues(alpha: 0.84),
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
