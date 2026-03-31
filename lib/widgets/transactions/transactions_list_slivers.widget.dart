import "package:flutter/material.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_day_group_card.widget.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_day_header_delegate.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_day_header.widget.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_day_section.widget.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_day_section_surface.widget.dart";

class TransactionsSummaryEmptyWidget extends StatelessWidget {
  const TransactionsSummaryEmptyWidget({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return TransactionsDaySectionSurfaceWidget(
      child: TransactionsDayGroupCardWidget(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ),
    );
  }
}

class TransactionsDayGroupSliverWidget extends StatelessWidget {
  const TransactionsDayGroupSliverWidget({
    required this.group,
    required this.isLast,
    required this.showTopSpacing,
    required this.padding,
    this.emptyLabel,
    super.key,
  });

  final TransactionDayGroup group;
  final bool isLast;
  final bool showTopSpacing;
  final EdgeInsets padding;
  final String? emptyLabel;

  String get dateKey {
    final normalizedDate = startOfDay(group.date);

    return "${normalizedDate.year.toString().padLeft(4, "0")}-"
        "${normalizedDate.month.toString().padLeft(2, "0")}-"
        "${normalizedDate.day.toString().padLeft(2, "0")}";
  }

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        if (showTopSpacing)
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            padding.left,
            0,
            padding.right,
            isLast ? padding.bottom : 0,
          ),
          sliver: SliverMainAxisGroup(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: TransactionsDayHeaderDelegate(
                  child: TransactionsDayHeaderWidget(
                    key: ValueKey("transactions-day-header-$dateKey"),
                    group: group,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: TransactionsDaySectionWidget(
                  group: group,
                  emptyLabel: emptyLabel,
                  showHeader: false,
                ),
              ),
              if (!isLast)
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
            ],
          ),
        ),
      ],
    );
  }
}
