import "package:flutter/material.dart";
import "package:walletplan_flutter/i18n/strings.g.dart";
import "package:walletplan_flutter/stores/transactions/transactions_models.dart";
import "package:walletplan_flutter/utils/currency_formatter.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_day_group_card.widget.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_day_section_divider.widget.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_day_section_surface.widget.dart";

class TransactionsCategorySectionWidget extends StatelessWidget {
  const TransactionsCategorySectionWidget({
    required this.section,
    required this.isLast,
    super.key,
  });

  final TransactionCategorySection section;
  final bool isLast;

  String _sectionTitle(BuildContext context) {
    return section.type == TransactionType.expense
        ? context.t.transactionsPage.expenseCategories
        : context.t.transactionsPage.incomeCategories;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: TransactionsDaySectionSurfaceWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text(
                _sectionTitle(context),
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            TransactionsDayGroupCardWidget(
              child: Column(
                children: [
                  for (
                    int index = 0;
                    index < section.items.length;
                    index++
                  ) ...[
                    if (index > 0) const TransactionsDaySectionDividerWidget(),
                    _TransactionsCategoryItemWidget(
                      group: section.items[index],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionsCategoryItemWidget extends StatelessWidget {
  const _TransactionsCategoryItemWidget({required this.group});

  final TransactionCategoryGroup group;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final totalText = formatSignedCurrencyAmount(
      group.total,
      group.currency,
      withPlusSign: true,
    );
    final iconBackground = group.type == TransactionType.expense
        ? Colors.indigo.withValues(alpha: 0.10)
        : Colors.teal.withValues(alpha: 0.12);
    final iconColor = group.type == TransactionType.expense
        ? const Color(0xFF5B4AA3)
        : Colors.teal.shade600;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Icon(group.icon, color: iconColor, size: 20),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "${group.count} "
                  "${context.t.transactionsPage.operationsLabel}",
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            totalText,
            style: textTheme.bodyMedium?.copyWith(
              color: group.total < 0 ? colorScheme.onSurface : iconColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
