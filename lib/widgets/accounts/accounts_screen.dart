import "package:flutter/material.dart";
import "package:walletplan_flutter/i18n/strings.g.dart";
import "package:walletplan_flutter/utils/currency_formatter.dart";
import "package:walletplan_flutter/widgets/accounts/account_section_block.dart";
import "package:walletplan_flutter/widgets/accounts/account_summary_card.dart";
import "package:walletplan_flutter/widgets/accounts/data/mock_accounts.dart";
import "package:walletplan_flutter/widgets/accounts/models/account_item.dart";

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  static const double _horizontalPadding = 16;
  static const double _headerTopPadding = 14;
  static const double _maxHeaderBottomPadding = 8;
  static const double _minHeaderBottomPadding = 4;
  static const double _maxSummaryCardHeight = 130;
  static const double _minSummaryCardHeight = 58;
  static const double _maxHeaderExtent =
      _maxSummaryCardHeight + _headerTopPadding + _maxHeaderBottomPadding;
  static const double _minHeaderExtent =
      _minSummaryCardHeight + _headerTopPadding + _minHeaderBottomPadding;

  @override
  Widget build(BuildContext context) {
    final translations = context.t;
    final sections = buildMockAccountSections(translations);
    final visibleAccounts = sections
        .expand((section) => section.visibleItems)
        .toList(growable: false);
    final totalAmount = visibleAccounts.fold<double>(
      0,
      (sum, item) => sum + item.amount,
    );
    final totalAmountLabel = formatCurrencyAmount(
      totalAmount,
      AppCurrency.rub,
      decimalDigits: 0,
    );

    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: _AccountsSummaryHeaderDelegate(
            minExtentValue: _minHeaderExtent,
            maxExtentValue: _maxHeaderExtent,
            builder: (context, collapseProgress) {
              final bottomPadding =
                  _maxHeaderBottomPadding -
                  (_maxHeaderBottomPadding - _minHeaderBottomPadding) *
                      collapseProgress;

              return Padding(
                padding: EdgeInsets.fromLTRB(
                  _horizontalPadding,
                  _headerTopPadding,
                  _horizontalPadding,
                  bottomPadding,
                ),
                child: AccountSummaryCard(
                  title: translations.accountsPage.summaryTitle,
                  totalAmountLabel: totalAmountLabel,
                  activeAccountsLabel: translations.accountsPage.activeAccounts(
                    count: visibleAccounts.length,
                  ),
                  breakdownLabel: _buildBreakdownLabel(
                    translations,
                    visibleAccounts,
                  ),
                  collapseProgress: collapseProgress,
                  onAddAccount: () => debugPrint("Add account tapped"),
                ),
              );
            },
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            _horizontalPadding,
            0,
            _horizontalPadding,
            24,
          ),
          sliver: SliverList.list(
            children: [
              for (final section in sections)
                if (section.visibleItems.isNotEmpty) ...[
                  AccountSectionBlock(
                    title: section.title,
                    items: section.visibleItems,
                    onTapItem: _handleTap,
                  ),
                ],
            ],
          ),
        ),
      ],
    );
  }

  String _buildBreakdownLabel(
    Translations t,
    List<AccountItem> visibleAccounts,
  ) {
    final connectedCount = _countBySource(
      visibleAccounts,
      AccountSourceType.connected,
    );
    final manualCount = _countBySource(
      visibleAccounts,
      AccountSourceType.manual,
    );
    final investmentCount = _countBySource(
      visibleAccounts,
      AccountSourceType.investment,
    );

    return [
      t.accountsPage.connectedAccounts(count: connectedCount),
      t.accountsPage.manualAccounts(count: manualCount),
      t.accountsPage.investmentAccounts(count: investmentCount),
    ].join(", ");
  }

  int _countBySource(List<AccountItem> items, AccountSourceType sourceType) {
    return items.where((item) => item.sourceType == sourceType).length;
  }

  void _handleTap(AccountItem item) {
    debugPrint("Open account: ${item.id}");
  }
}

class _AccountsSummaryHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _AccountsSummaryHeaderDelegate({
    required this.minExtentValue,
    required this.maxExtentValue,
    required this.builder,
  });

  final double minExtentValue;
  final double maxExtentValue;
  final Widget Function(BuildContext context, double collapseProgress) builder;

  @override
  double get minExtent => minExtentValue;

  @override
  double get maxExtent => maxExtentValue;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final distance = maxExtentValue - minExtentValue;
    final collapseProgress = distance <= 0
        ? 1.0
        : (shrinkOffset / distance).clamp(0.0, 1.0);

    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: builder(context, collapseProgress),
    );
  }

  @override
  bool shouldRebuild(_AccountsSummaryHeaderDelegate oldDelegate) {
    return minExtentValue != oldDelegate.minExtentValue ||
        maxExtentValue != oldDelegate.maxExtentValue ||
        builder != oldDelegate.builder;
  }
}
