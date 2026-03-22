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

(
  Ref<Transactions> data,
  Ref<bool> loading,
  Ref<Object?> error,
  Future<void> Function({bool refresh}) getData,
  Future<void> Function() loadMore,
  void Function(Transaction tx) upsertLocal,
  void Function(String id) removeLocal,
)
useTransactions({int pageSize = 30}) {
  final data = ref<Transactions>(Transactions(items: const [], count: 0));
  final loading = ref(false);
  final error = ref<Object?>(null);

  final offset = ref(0);
  final hasMore = computed(() => data.value.items.length < data.value.count);

  Future<Transactions> fetch({required int offset, required int limit}) async {
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

  Future<void> getData({bool refresh = false}) async {
    if (loading.value) return;

    try {
      loading.value = true;
      error.value = null;

      if (refresh) {
        offset.value = 0;
      }

      final res = await fetch(offset: offset.value, limit: pageSize);

      if (refresh) {
        data.value = res;
      } else {
        final merged = <Transaction>[...data.value.items, ...res.items];

        data.value = data.value.copyWith(items: merged, count: res.count);
      }

      offset.value = data.value.items.length;
    } catch (e) {
      error.value = e;
    } finally {
      loading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!hasMore.value) return;
    await getData(refresh: false);
  }

  void upsertLocal(Transaction tx) {
    final items = data.value.items;
    final idx = items.indexWhere((x) => x.id == tx.id);

    final next = [...items];
    if (idx == -1) {
      next.insert(0, tx);
    } else {
      next[idx] = tx;
    }

    data.value = data.value.copyWith(items: next);
  }

  void removeLocal(String id) {
    final next = data.value.items
        .where((x) => x.id != id)
        .toList(growable: false);
    data.value = data.value.copyWith(items: next, count: data.value.count - 1);
  }

  return (data, loading, error, getData, loadMore, upsertLocal, removeLocal);
}
