// ignore_for_file: always_use_package_imports

// Update snapshots intentionally:
// flutter test --update-goldens test/goldens/visual_regression_test.dart
//
// Golden tests in `flutter test` use the test font, so these baselines lock
// layout, spacing, colors, icons, and screen structure rather than production
// system typography.

import "package:flutter/material.dart";
import "package:flutter_compositions/flutter_compositions.dart";
import "package:flutter_test/flutter_test.dart";
import "package:walletplan_flutter/i18n/strings.g.dart";
import "package:walletplan_flutter/pages/common/transactions_filters.page.dart";
import "package:walletplan_flutter/router/base_delegate.dart";
import "package:walletplan_flutter/router/root_delegate.dart";
import "package:walletplan_flutter/stores/transactions/transactions_scope.widget.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";
import "package:walletplan_flutter/utils/currency_formatter.dart";
import "package:walletplan_flutter/widgets/main/main_navigation_bar.widget.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_period_header.widget.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_scrollable_content.widget.dart";

import "golden_test_harness.dart";

void main() {
  setUpAll(() async {
    await LocaleSettings.setLocale(AppLocale.ru);
  });

  setUp(() {
    rootDelegate.beamToNamed("/app/transactions");
    baseDelegate.beamToNamed("/app/transactions");
  });

  testWidgets("transactions overview matches golden", (tester) async {
    await pumpGoldenApp(tester, home: const _TransactionsOverviewGoldenPage());

    await expectLater(
      find.byKey(goldenSurfaceKey),
      matchesGoldenFile("goldens/transactions_overview.png"),
    );
  });

  testWidgets("transactions overview pinned header matches golden", (
    tester,
  ) async {
    await pumpGoldenApp(
      tester,
      home: const _TransactionsOverviewGoldenPage(groupCount: 7),
    );

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -260));
    await tester.pumpAndSettle();

    await expectLater(
      find.byKey(goldenSurfaceKey),
      matchesGoldenFile("goldens/transactions_overview_pinned_header.png"),
    );
  });

  testWidgets("transactions period picker dialog matches golden", (
    tester,
  ) async {
    await pumpGoldenApp(tester, home: const _TransactionsOverviewGoldenPage());

    await tester.tap(
      find.byKey(const ValueKey("transactions-period-picker-open")),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byKey(goldenSurfaceKey),
      matchesGoldenFile("goldens/transactions_period_picker_dialog.png"),
    );
  });

  testWidgets("transactions filters screen matches golden", (tester) async {
    await pumpGoldenApp(tester, home: const _TransactionsFiltersGoldenPage());

    await expectLater(
      find.byKey(goldenSurfaceKey),
      matchesGoldenFile("goldens/transactions_filters_screen.png"),
    );
  });

  testWidgets("transactions filters screen with draft changes matches golden", (
    tester,
  ) async {
    await pumpGoldenApp(tester, home: const _TransactionsFiltersGoldenPage());

    await tester.tap(find.text("Расходы"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Мир 0037"));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text("По категориям"),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text("По категориям"));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.widgetWithText(SwitchListTile, "Включать переводы"),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(SwitchListTile, "Включать переводы"));
    await tester.pumpAndSettle();

    await expectLater(
      find.byKey(goldenSurfaceKey),
      matchesGoldenFile("goldens/transactions_filters_screen_dirty.png"),
    );
  });

  testWidgets("main navigation matches golden", (tester) async {
    baseDelegate.beamToNamed(pathForIndex(BaseRoutesEnum.plans.index));

    await pumpGoldenApp(
      tester,
      size: const Size(390, 120),
      home: const Scaffold(
        body: SizedBox.expand(),
        bottomNavigationBar: MainNavigationBarWidget(),
      ),
    );

    await expectLater(
      find.byKey(goldenSurfaceKey),
      matchesGoldenFile("goldens/main_navigation_bar_plans.png"),
    );
  });

  testWidgets("add expense screen matches golden", (tester) async {
    rootDelegate.beamToNamed("/addIncomeOrExpense?type=expense");

    await pumpGoldenRouterApp(tester);

    await expectLater(
      find.byKey(goldenSurfaceKey),
      matchesGoldenFile("goldens/add_income_or_expense_expense.png"),
    );
  });

  testWidgets("add income screen matches golden", (tester) async {
    rootDelegate.beamToNamed("/addIncomeOrExpense?type=income");

    await pumpGoldenRouterApp(tester);

    await expectLater(
      find.byKey(goldenSurfaceKey),
      matchesGoldenFile("goldens/add_income_or_expense_income.png"),
    );
  });
}

class _TransactionsOverviewGoldenPage extends StatelessWidget {
  const _TransactionsOverviewGoldenPage({this.groupCount = 2});

  final int groupCount;

  @override
  Widget build(BuildContext context) {
    final period = TransactionsPeriodSelection(
      date: DateTime(2025, 3, 1),
      mode: TransactionsPeriodMode.month,
    );

    final groups = _buildGroups(groupCount);
    final items = groups.expand((group) => group.items).toList(growable: false);
    final summary = TransactionsPeriodSummary(
      period: period.date,
      periodMode: period.mode,
      items: items,
      groups: groups,
      total: 4,
      currency: AppCurrency.rub,
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: TransactionsPeriodHeaderWidget(
                period: period,
                total: 4,
                currency: AppCurrency.rub,
                today: DateTime(2025, 3, 29),
                onPeriodSelected: (_) {},
              ),
            ),
            Expanded(
              child: TransactionsScrollableContentWidget(
                period: period,
                summary: summary,
                groupBy: TransactionsGroupBy.days,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TransactionDayGroup> _buildGroups(int count) {
    final groups = <TransactionDayGroup>[];

    for (var index = 0; index < count; index++) {
      final date = DateTime(2025, 3, 17 - index);
      if (index.isEven) {
        groups.add(
          TransactionDayGroup(
            date: date,
            items: [
              Transaction(
                id: "expense-restaurant-$index",
                type: TransactionType.expense,
                amount: 4 + index,
                currency: AppCurrency.rub,
                category: "Еда",
                title: "Еда",
                subtitle: "Обед",
                sourceName: "Мир",
                icon: Icons.restaurant_rounded,
                createdAt: DateTime(2025, 3, 17 - index, 14, 20),
              ),
              Transaction(
                id: "expense-taxi-$index",
                type: TransactionType.expense,
                amount: 1 + index,
                currency: AppCurrency.rub,
                category: "Транспорт",
                title: "Такси",
                subtitle: "Офис",
                sourceName: "Мир",
                icon: Icons.local_taxi_rounded,
                createdAt: DateTime(2025, 3, 17 - index, 9, 10),
              ),
            ],
            total: -(5 + index * 2),
          ),
        );
      } else {
        groups.add(
          TransactionDayGroup(
            date: date,
            items: [
              Transaction(
                id: "income-freelance-$index",
                type: TransactionType.income,
                amount: 9 + index,
                currency: AppCurrency.rub,
                category: "Подработка",
                title: "Доход",
                subtitle: "Заказ",
                sourceName: "Счет",
                icon: Icons.work_history_rounded,
                createdAt: DateTime(2025, 3, 17 - index, 18, 40),
              ),
            ],
            total: 9 + index,
          ),
        );
      }
    }

    return groups;
  }
}

class _TransactionsFiltersGoldenPage extends StatelessWidget {
  const _TransactionsFiltersGoldenPage();

  @override
  Widget build(BuildContext context) {
    return const TransactionsScopeWidget(
      child: _TransactionsFiltersGoldenLoaderWidget(),
    );
  }
}

class _TransactionsFiltersGoldenLoaderWidget extends CompositionWidget {
  const _TransactionsFiltersGoldenLoaderWidget();

  @override
  Widget Function(BuildContext) setup() {
    final transactionsStore = inject(
      transactionsStoreKey,
      defaultValue: useTransactions(),
    );

    onMounted(() {
      transactionsStore.getData(refresh: true);
    });

    return (_) => const TransactionsFiltersPage();
  }
}
