import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:walletplan_flutter/i18n/strings.g.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";
import "package:walletplan_flutter/utils/currency_formatter.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_day_header_title.widget.dart";

String? markerLabelForDate(BuildContext context, DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));

  if (date == today) {
    return context.t.transactionsPage.today;
  }

  if (date == yesterday) {
    return context.t.transactionsPage.yesterday;
  }

  return null;
}

class TransactionsDayHeaderWidget extends StatelessWidget {
  const TransactionsDayHeaderWidget({required this.group, super.key});

  final TransactionDayGroup group;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final dateLabel = DateFormat("dd.MM.yyyy", localeTag).format(group.date);
    final markerLabel = markerLabelForDate(context, group.date);
    final currency = group.items.isEmpty
        ? AppCurrency.rub
        : group.items.first.currency;
    final totalText = formatSignedCurrencyAmount(
      group.total,
      currency,
      withPlusSign: true,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: TransactionsDayHeaderTitleWidget(
              dateLabel: dateLabel,
              markerLabel: markerLabel,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            totalText,
            style: textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.1,
            ),
          ),
        ],
      ),
    );
  }
}
