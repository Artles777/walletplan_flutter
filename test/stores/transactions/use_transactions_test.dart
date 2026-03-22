import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_compositions/flutter_compositions.dart";
import "package:flutter_test/flutter_test.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";

typedef TransactionsLogic = (
  Ref<Transactions> data,
  Ref<bool> loading,
  Ref<Object?> error,
  Future<void> Function({bool refresh}) getData,
  Future<void> Function() loadMore,
  void Function(Transaction tx) upsertLocal,
  void Function(String id) removeLocal,
);

Transaction buildTx(String id, {String? title}) {
  return Transaction(
    id: id,
    dateTime: DateTime(2025, 1, 1),
    title: title ?? "tx-$id",
    subtitle: "subtitle-$id",
    accountLabel: "acc-$id",
    amount: 10,
    currencySymbol: "₽",
    icon: Icons.account_balance,
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
        getData,
        loadMore,
        upsertLocal,
        removeLocal,
      ) = logic;

      await getData(refresh: true);
      await tester.pump();

      expect(loading.value, isFalse);
      expect(error.value, isNull);
      expect(data.value.items.map((tx) => tx.id), ["1"]);
      expect(data.value.count, 2);

      await loadMore();
      await tester.pump();

      expect(data.value.items.map((tx) => tx.id), ["1", "2"]);
      expect(data.value.count, 2);

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
      final (data, loading, error, getData, _, _, _) = logic;

      await getData(refresh: true);
      await tester.pump();

      expect(loading.value, isFalse);
      expect(data.value.items, isEmpty);
      expect(error.value, isA<StateError>());
    });
  });
}
