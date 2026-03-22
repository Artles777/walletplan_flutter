import "package:beamer/beamer.dart";
import "package:flutter/widgets.dart";
import "package:walletplan_flutter/pages/base/accounts.page.dart";
import "package:walletplan_flutter/pages/base/analytic.page.dart";
import "package:walletplan_flutter/pages/base/plans.page.dart";
import "package:walletplan_flutter/pages/base/transactions.page.dart";

enum BaseRoutesEnum { transactions, accounts, plans, analytic }

typedef BeamBuilder = Widget Function(BuildContext, BeamState, Object?);

final _tabConfig = <BaseRoutesEnum, ({String path, BeamBuilder builder})>{
  BaseRoutesEnum.transactions: (
    path: "/app/transactions",
    builder: (context, state, data) => const TransactionsPage(),
  ),
  BaseRoutesEnum.accounts: (
    path: "/app/accounts",
    builder: (context, state, data) => const AccountsPage(),
  ),
  BaseRoutesEnum.plans: (
    path: "/app/plans",
    builder: (context, state, data) => const PlansPage(),
  ),
  BaseRoutesEnum.analytic: (
    path: "/app/analytic",
    builder: (context, state, data) => const AnalyticPage(),
  ),
};

final Map<String, BaseRoutesEnum> basePaths = {
  for (final e in _tabConfig.entries) e.value.path: e.key,
};

final Map<BaseRoutesEnum, String> baseRoutes = {
  for (final e in _tabConfig.entries) e.key: e.value.path,
};

final baseDelegate = BeamerDelegate(
  initialPath: baseRoutes[BaseRoutesEnum.transactions]!,
  locationBuilder: RoutesLocationBuilder(
    routes: {for (final e in _tabConfig.entries) e.value.path: e.value.builder},
  ).call,
);

int indexFromUri(Uri uri) {
  final p = uri.path;

  for (final entry in basePaths.entries) {
    if (p.startsWith(entry.key)) return entry.value.index;
  }

  return BaseRoutesEnum.transactions.index;
}

String pathForIndex(int index) {
  final route = BaseRoutesEnum.values[index];
  return baseRoutes[route]!;
}
