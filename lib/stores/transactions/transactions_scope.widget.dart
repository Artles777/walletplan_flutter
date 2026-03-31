import "package:flutter/material.dart";
import "package:flutter_compositions/flutter_compositions.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions_filters.dart";

final transactionsStoreKey = const InjectionKey<TransactionsStore>(
  "transactions.store",
);
final transactionsViewStoreKey = const InjectionKey<TransactionsViewStore>(
  "transactions.view.store",
);

class TransactionsScopeWidget extends CompositionWidget {
  const TransactionsScopeWidget({required this.child, super.key});

  final Widget child;

  @override
  Widget Function(BuildContext) setup() {
    final transactionsStore = useTransactions();
    final transactionsViewStore = useTransactionsViewStore();

    provide(transactionsStoreKey, transactionsStore);
    provide(transactionsViewStoreKey, transactionsViewStore);

    return (_) => child;
  }
}
