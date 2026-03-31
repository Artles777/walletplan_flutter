import "package:flutter_compositions/flutter_compositions.dart";
import "package:walletplan_flutter/stores/transactions/transactions_models.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions_data.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions_period.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions_summary.dart";

export "package:walletplan_flutter/stores/transactions/transactions_models.dart";
export "package:walletplan_flutter/stores/transactions/use_transactions_data.dart";
export "package:walletplan_flutter/stores/transactions/use_transactions_period.dart";
export "package:walletplan_flutter/stores/transactions/use_transactions_summary.dart";

typedef TransactionsStore = (
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

extension TransactionsStoreExt on TransactionsStore {
  Ref<Transactions> get data => this.$1;

  Ref<bool> get loading => this.$2;

  Ref<Object?> get error => this.$3;

  ReadonlyRef<TransactionsPeriodSelection> get selectedPeriod => this.$4;

  ReadonlyRef<TransactionsPeriodSummary> get periodSummary => this.$5;

  Future<void> Function({bool refresh}) get getData => this.$6;

  Future<void> Function() get loadMore => this.$7;

  void Function(TransactionsPeriodSelection period) get setPeriod => this.$8;

  void Function(Transaction tx) get upsertLocal => this.$9;

  void Function(String id) get removeLocal => this.$10;
}

TransactionsStore useTransactions({
  int pageSize = 30,
  GetTransactions? fetcher,
}) {
  final periodStore = useTransactionsPeriod();
  final dataStore = useTransactionsData(pageSize: pageSize, fetcher: fetcher);
  final periodSummary = useTransactionsSummary(
    selectedPeriod: periodStore.selectedPeriod,
    data: dataStore.data,
  );

  return (
    dataStore.data,
    dataStore.loading,
    dataStore.error,
    periodStore.selectedPeriod,
    periodSummary,
    dataStore.getData,
    dataStore.loadMore,
    periodStore.setPeriod,
    dataStore.upsertLocal,
    dataStore.removeLocal,
  );
}
