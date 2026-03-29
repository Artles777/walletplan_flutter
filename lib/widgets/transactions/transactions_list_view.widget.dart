import "package:flutter/material.dart";
import "package:flutter_compositions/flutter_compositions.dart";
import "package:walletplan_flutter/i18n/strings.g.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_day_header_delegate.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_day_header.widget.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_day_section.widget.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_period_header.widget.dart";

class TransactionsListViewWidget extends CompositionWidget {
  const TransactionsListViewWidget({
    this.controller,
    this.padding = const EdgeInsets.fromLTRB(16, 0, 16, 24),
    super.key,
  });

  final ScrollController? controller;
  final EdgeInsets padding;

  @override
  Widget Function(BuildContext) setup() {
    final transactionsState = useTransactions();

    onMounted(() {
      transactionsState.getData(refresh: true);
    });

    return (context) {
      return TransactionsListContentWidget(
        controller: controller,
        padding: padding,
        loading: transactionsState.loading.value,
        error: transactionsState.error.value,
        period: transactionsState.selectedPeriod.value,
        summary: transactionsState.periodSummary.value,
        onPeriodSelected: transactionsState.setPeriod,
      );
    };
  }
}

class TransactionsListContentWidget extends StatelessWidget {
  const TransactionsListContentWidget({
    required this.loading,
    required this.period,
    required this.summary,
    required this.padding,
    required this.onPeriodSelected,
    this.error,
    this.controller,
    super.key,
  });

  final ScrollController? controller;
  final EdgeInsets padding;
  final bool loading;
  final Object? error;
  final TransactionsPeriodSelection period;
  final TransactionsPeriodSummary summary;
  final ValueChanged<TransactionsPeriodSelection> onPeriodSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (loading) const LinearProgressIndicator(minHeight: 2),
        if (error != null) const TransactionsLoadErrorWidget(),
        Padding(
          padding: EdgeInsets.only(left: padding.left, right: padding.right),
          child: TransactionsPeriodHeaderWidget(
            period: period,
            total: summary.total,
            currency: summary.currency,
            onPeriodSelected: onPeriodSelected,
          ),
        ),
        Expanded(
          child: TransactionsScrollableContentWidget(
            controller: controller,
            padding: padding,
            period: period,
            summary: summary,
          ),
        ),
      ],
    );
  }
}

class TransactionsLoadErrorWidget extends StatelessWidget {
  const TransactionsLoadErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: theme.colorScheme.onErrorContainer,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  context.t.transactionsPage.loadError,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TransactionsScrollableContentWidget extends StatelessWidget {
  const TransactionsScrollableContentWidget({
    required this.period,
    required this.summary,
    required this.padding,
    this.controller,
    super.key,
  });

  final ScrollController? controller;
  final EdgeInsets padding;
  final TransactionsPeriodSelection period;
  final TransactionsPeriodSummary summary;

  List<TransactionDayGroup> get displayGroups {
    if (summary.groups.isNotEmpty) {
      return summary.groups;
    }

    return [TransactionDayGroup(date: period.date, items: const [], total: 0)];
  }

  @override
  Widget build(BuildContext context) {
    final groups = displayGroups;

    return CustomScrollView(
      controller: controller,
      slivers: [
        for (int index = 0; index < groups.length; index++)
          TransactionsDayGroupSliverWidget(
            group: groups[index],
            isLast: index == groups.length - 1,
            showTopSpacing: index > 0,
            emptyLabel: summary.groups.isEmpty
                ? context.t.transactionsPage.empty
                : null,
            padding: padding,
          ),
      ],
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
