import "package:flutter/material.dart";
import "package:flutter_compositions/flutter_compositions.dart";

class Transactions {
  Transactions({required this.items, required this.count});

  final List<Transaction> items;
  final int count;

  Transactions copyWith({List<Transaction>? items, int? count}) {
    return Transactions(items: items ?? this.items, count: count ?? this.count);
  }
}

class Transaction {
  Transaction({
    required this.id,
    required this.dateTime,
    required this.title,
    required this.subtitle,
    required this.accountLabel,
    required this.amount,
    required this.currencySymbol,
    required this.icon,
  });

  final String id;
  final DateTime dateTime;

  final String title;
  final String subtitle;
  final String accountLabel;

  final num amount;
  final String currencySymbol;
  final IconData icon;
}

typedef GetTransactions =
    Future<Transactions> Function({required int offset, required int limit});

Transactions appendTransactions(Transactions current, Transactions next) {
  return current.copyWith(
    items: [...current.items, ...next.items],
    count: next.count,
  );
}

Transactions upsertTransaction(Transactions current, Transaction tx) {
  final items = current.items;
  final idx = items.indexWhere((x) => x.id == tx.id);

  final next = [...items];
  if (idx == -1) {
    next.insert(0, tx);
    return current.copyWith(items: next, count: current.count + 1);
  }

  next[idx] = tx;
  return current.copyWith(items: next);
}

Transactions removeTransaction(Transactions current, String id) {
  final exists = current.items.any((x) => x.id == id);
  if (!exists) {
    return current;
  }

  final next = current.items.where((x) => x.id != id).toList(growable: false);

  return current.copyWith(
    items: next,
    count: current.count > 0 ? current.count - 1 : 0,
  );
}

Future<Transactions> _defaultFetchTransactions({
  required int offset,
  required int limit,
}) async {
  final items = <Transaction>[
    Transaction(
      id: "1",
      dateTime: DateTime.timestamp(),
      title: "Банковский перевод",
      subtitle: "на текущие траты",
      accountLabel: "Мир 0037",
      amount: 420.00,
      currencySymbol: "₽",
      icon: Icons.account_balance,
    ),
  ];

  return Transactions(items: items, count: items.length);
}

(
  Ref<Transactions> data,
  Ref<bool> loading,
  Ref<Object?> error,
  Future<void> Function({bool refresh}) getData,
  Future<void> Function() loadMore,
  void Function(Transaction tx) upsertLocal,
  void Function(String id) removeLocal,
)
useTransactions({int pageSize = 30, GetTransactions? fetcher}) {
  final data = ref<Transactions>(Transactions(items: const [], count: 0));
  final loading = ref(false);
  final error = ref<Object?>(null);

  final offset = ref(0);
  final hasMore = computed(() => data.value.items.length < data.value.count);
  final getTransactions = fetcher ?? _defaultFetchTransactions;

  Future<void> getData({bool refresh = false}) async {
    if (loading.value) {
      return;
    }

    try {
      loading.value = true;
      error.value = null;

      if (refresh) {
        offset.value = 0;
      }

      final res = await getTransactions(offset: offset.value, limit: pageSize);

      if (refresh) {
        data.value = res;
      } else {
        data.value = appendTransactions(data.value, res);
      }

      offset.value = data.value.items.length;
    } catch (e) {
      error.value = e;
    } finally {
      loading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!hasMore.value) {
      return;
    }

    await getData(refresh: false);
  }

  void upsertLocal(Transaction tx) {
    data.value = upsertTransaction(data.value, tx);
  }

  void removeLocal(String id) {
    data.value = removeTransaction(data.value, id);
  }

  return (data, loading, error, getData, loadMore, upsertLocal, removeLocal);
}
