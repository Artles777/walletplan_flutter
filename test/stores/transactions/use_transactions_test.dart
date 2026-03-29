import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_compositions/flutter_compositions.dart";
import "package:flutter_test/flutter_test.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";
import "package:walletplan_flutter/utils/currency_formatter.dart";

typedef TransactionsLogic = (
  Ref<Transactions> data,
  Ref<bool> loading,
  Ref<Object?> error,
  ReadonlyRef<TransactionsPeriodSelection> selectedPeriod,
  ReadonlyRef<TransactionsPeriodSummary> periodSummary,
  Future<void> Function({bool refresh}) getData,
  Future<void> Function() loadMore,
  void Function(TransactionsPeriodSelection period) setPeriod,
  void Function(Transaction tx) upsertLocal,
  void Function(String id) removeLocal,
);

Transaction buildTx(
  String id, {
  String? title,
  TransactionType type = TransactionType.expense,
  num amount = 10,
  DateTime? createdAt,
}) {
  return Transaction(
    id: id,
    type: type,
    amount: amount,
    currency: AppCurrency.rub,
    category: title ?? "tx-$id",
    title: title ?? "tx-$id",
    subtitle: "subtitle-$id",
    sourceName: "acc-$id",
    icon: Icons.account_balance,
    createdAt: createdAt ?? DateTime(2025, 1, 1),
  );
}

class _TransactionsHarness extends CompositionWidget {
  const _TransactionsHarness({
    required this.onReady,
    required this.pageSize,
    required this.fetcher,
  });

  final void Function(TransactionsLogic logic) onReady;
  final int pageSize;
  final GetTransactions fetcher;

  @override
  Widget Function(BuildContext context) setup() {
    final logic = useTransactions(pageSize: pageSize, fetcher: fetcher);

    onMounted(() {
      onReady(logic);
    });

    return (_) => const SizedBox.shrink();
  }
}

Future<TransactionsLogic> pumpTransactionsHarness(
  WidgetTester tester, {
  required GetTransactions fetcher,
  int pageSize = 30,
}) async {
  final completer = Completer<TransactionsLogic>();

  await tester.pumpWidget(
    MaterialApp(
      home: _TransactionsHarness(
        onReady: completer.complete,
        pageSize: pageSize,
        fetcher: fetcher,
      ),
    ),
  );
  await tester.pump();

  return completer.future;
}

void main() {
  group("transactions state helpers", () {
    test("appendTransactions appends items and keeps server count", () {
      final current = Transactions(items: [buildTx("1")], count: 2);
      final next = Transactions(items: [buildTx("2")], count: 5);

      final result = appendTransactions(current, next);

      expect(result.items.map((tx) => tx.id), ["1", "2"]);
      expect(result.count, 5);
    });

    test("upsertTransaction inserts new items at the top", () {
      final current = Transactions(items: [buildTx("1")], count: 1);

      final result = upsertTransaction(current, buildTx("2"));

      expect(result.items.map((tx) => tx.id), ["2", "1"]);
      expect(result.count, 2);
    });

    test("upsertTransaction updates existing item without changing count", () {
      final current = Transactions(items: [buildTx("1")], count: 1);

      final result = upsertTransaction(current, buildTx("1", title: "updated"));

      expect(result.items.single.title, "updated");
      expect(result.count, 1);
    });

    test("removeTransaction removes existing items and decrements count", () {
      final current = Transactions(
        items: [buildTx("1"), buildTx("2")],
        count: 2,
      );

      final result = removeTransaction(current, "1");

      expect(result.items.map((tx) => tx.id), ["2"]);
      expect(result.count, 1);
    });

    test("removeTransaction keeps state unchanged for unknown ids", () {
      final current = Transactions(items: [buildTx("1")], count: 1);

      final result = removeTransaction(current, "404");

      expect(result.items.map((tx) => tx.id), ["1"]);
      expect(result.count, 1);
    });

    test("calculateTransactionsTotal respects transaction type sign", () {
      final total = calculateTransactionsTotal([
        buildTx("1", type: TransactionType.income, amount: 120),
        buildTx("2", type: TransactionType.expense, amount: 35),
      ]);

      expect(total, 85);
    });

    test("buildTransactionsPeriodSummary groups items by day in period", () {
      final januarySummary = buildTransactionsPeriodSummary(
        period: TransactionsPeriodSelection(
          date: DateTime(2025, 1),
          mode: TransactionsPeriodMode.month,
        ),
        items: [
          buildTx(
            "1",
            amount: 100,
            type: TransactionType.income,
            createdAt: DateTime(2025, 1, 2, 10),
          ),
          buildTx("2", amount: 25, createdAt: DateTime(2025, 1, 2, 8)),
          buildTx("3", amount: 10, createdAt: DateTime(2025, 1, 1, 12)),
          buildTx("4", amount: 999, createdAt: DateTime(2025, 2, 1, 12)),
        ],
      );

      expect(januarySummary.items.map((tx) => tx.id), ["1", "2", "3"]);
      expect(januarySummary.groups, hasLength(2));
      expect(januarySummary.groups.first.items.map((tx) => tx.id), ["1", "2"]);
      expect(januarySummary.groups.first.total, 75);
      expect(januarySummary.total, 65);
    });
  });

  group("useTransactions", () {
    testWidgets("loads and appends pages through injected fetcher", (
      tester,
    ) async {
      Future<Transactions> fetcher({
        required int offset,
        required int limit,
      }) async {
        if (offset == 0) {
          return Transactions(items: [buildTx("1")], count: 2);
        }

        return Transactions(items: [buildTx("2")], count: 2);
      }

      final logic = await pumpTransactionsHarness(
        tester,
        fetcher: fetcher,
        pageSize: 1,
      );

      final (
        data,
        loading,
        error,
        selectedPeriod,
        periodSummary,
        getData,
        loadMore,
        setPeriod,
        upsertLocal,
        removeLocal,
      ) = logic;

      await getData(refresh: true);
      await tester.pump();

      expect(loading.value, isFalse);
      expect(error.value, isNull);
      expect(data.value.items.map((tx) => tx.id), ["1"]);
      expect(data.value.count, 2);
      expect(
        selectedPeriod.value.date,
        DateTime(DateTime.now().year, DateTime.now().month),
      );
      expect(selectedPeriod.value.mode, TransactionsPeriodMode.month);
      expect(periodSummary.value.items.map((tx) => tx.id), isEmpty);

      await loadMore();
      await tester.pump();

      expect(data.value.items.map((tx) => tx.id), ["1", "2"]);
      expect(data.value.count, 2);

      setPeriod(
        TransactionsPeriodSelection(
          date: DateTime(2025, 1),
          mode: TransactionsPeriodMode.month,
        ),
      );
      await tester.pump();
      expect(periodSummary.value.items.map((tx) => tx.id), ["1", "2"]);

      upsertLocal(buildTx("3"));
      await tester.pump();
      expect(data.value.items.first.id, "3");
      expect(data.value.count, 3);

      removeLocal("2");
      await tester.pump();
      expect(data.value.items.map((tx) => tx.id), ["3", "1"]);
      expect(data.value.count, 2);
    });

    testWidgets("captures fetch errors and resets loading", (tester) async {
      Future<Transactions> fetcher({
        required int offset,
        required int limit,
      }) async {
        throw StateError("boom");
      }

      final logic = await pumpTransactionsHarness(tester, fetcher: fetcher);
      final (data, loading, error, _, _, getData, _, _, _, _) = logic;

      await getData(refresh: true);
      await tester.pump();

      expect(loading.value, isFalse);
      expect(data.value.items, isEmpty);
      expect(error.value, isA<StateError>());
    });
  });
}
