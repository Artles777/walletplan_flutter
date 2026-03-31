import "package:flutter/material.dart";
import "package:flutter_compositions/flutter_compositions.dart";
import "package:walletplan_flutter/stores/transactions/transactions_models.dart";
import "package:walletplan_flutter/utils/currency_formatter.dart";

typedef GetTransactions =
    Future<Transactions> Function({required int offset, required int limit});

typedef TransactionsDataStore = (
  Ref<Transactions> data,
  Ref<bool> loading,
  Ref<Object?> error,
  Future<void> Function({bool refresh}) getData,
  Future<void> Function() loadMore,
  void Function(Transaction tx) upsertLocal,
  void Function(String id) removeLocal,
);

extension TransactionsDataStoreExt on TransactionsDataStore {
  Ref<Transactions> get data => this.$1;

  Ref<bool> get loading => this.$2;

  Ref<Object?> get error => this.$3;

  Future<void> Function({bool refresh}) get getData => this.$4;

  Future<void> Function() get loadMore => this.$5;

  void Function(Transaction tx) get upsertLocal => this.$6;

  void Function(String id) get removeLocal => this.$7;
}

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

Future<Transactions> defaultFetchTransactions({
  required int offset,
  required int limit,
}) async {
  final now = DateTime.now();
  final currentMonth = DateTime(now.year, now.month);
  final items = <Transaction>[
    Transaction(
      id: "1",
      type: TransactionType.expense,
      amount: 4000,
      currency: AppCurrency.rub,
      category: "Рестораны и кафе",
      title: "Рестораны и кафе",
      subtitle: "Сегодня обед в городе",
      sourceName: "Мир 0037",
      icon: Icons.restaurant_rounded,
      createdAt: now.copyWith(hour: 14, minute: 20),
    ),
    Transaction(
      id: "2",
      type: TransactionType.expense,
      amount: 1250,
      currency: AppCurrency.rub,
      category: "Транспорт",
      title: "Такси",
      subtitle: "Поездка до офиса",
      sourceName: "Мир 0037",
      icon: Icons.local_taxi_rounded,
      createdAt: now.copyWith(hour: 9, minute: 10),
    ),
    Transaction(
      id: "3",
      type: TransactionType.income,
      amount: 18500,
      currency: AppCurrency.rub,
      category: "Подработка",
      title: "Фриланс",
      subtitle: "Оплата за лендинг",
      sourceName: "Тинькофф Black",
      icon: Icons.work_history_rounded,
      createdAt: now
          .subtract(const Duration(days: 1))
          .copyWith(hour: 18, minute: 40),
    ),
    Transaction(
      id: "4",
      type: TransactionType.expense,
      amount: 890,
      currency: AppCurrency.rub,
      category: "Продукты",
      title: "Супермаркет",
      subtitle: "Покупки домой",
      sourceName: "Мир 0037",
      icon: Icons.shopping_basket_rounded,
      createdAt: now
          .subtract(const Duration(days: 1))
          .copyWith(hour: 11, minute: 55),
    ),
    Transaction(
      id: "5",
      type: TransactionType.expense,
      amount: 3200,
      currency: AppCurrency.rub,
      category: "Дом",
      title: "Коммунальные платежи",
      subtitle: "Ежемесячная оплата",
      sourceName: "Мир 0037",
      icon: Icons.home_work_rounded,
      createdAt: currentMonth
          .add(const Duration(days: 9))
          .copyWith(hour: 10, minute: 5),
    ),
    Transaction(
      id: "6",
      type: TransactionType.income,
      amount: 120000,
      currency: AppCurrency.rub,
      category: "Зарплата",
      title: "Зарплата",
      subtitle: "Основной доход за месяц",
      sourceName: "Тинькофф Black",
      icon: Icons.payments_rounded,
      createdAt: currentMonth
          .add(const Duration(days: 5))
          .copyWith(hour: 12, minute: 0),
    ),
    Transaction(
      id: "7",
      type: TransactionType.expense,
      amount: 4600,
      currency: AppCurrency.rub,
      category: "Здоровье",
      title: "Аптека",
      subtitle: "Покупка лекарств",
      sourceName: "Мир 0037",
      icon: Icons.local_hospital_rounded,
      createdAt: currentMonth
          .add(const Duration(days: 4))
          .copyWith(hour: 19, minute: 25),
    ),
    Transaction(
      id: "8",
      type: TransactionType.expense,
      amount: 2100,
      currency: AppCurrency.rub,
      category: "Подписки",
      title: "Онлайн-сервис",
      subtitle: "Продление подписки",
      sourceName: "Visa 5210",
      icon: Icons.subscriptions_rounded,
      createdAt: currentMonth
          .add(const Duration(days: 1))
          .copyWith(hour: 8, minute: 45),
    ),
    Transaction(
      id: "9",
      type: TransactionType.expense,
      amount: 950,
      currency: AppCurrency.rub,
      category: "Кофе",
      title: "Кофейня",
      subtitle: "Утренний кофе",
      sourceName: "Мир 0037",
      icon: Icons.local_cafe_rounded,
      createdAt: currentMonth
          .add(const Duration(days: 1))
          .copyWith(hour: 8, minute: 10),
    ),
    Transaction(
      id: "10",
      type: TransactionType.expense,
      amount: 2400,
      currency: AppCurrency.rub,
      category: "Образование",
      title: "Курс английского",
      subtitle: "Оплата еженедельного занятия",
      sourceName: "Visa 5210",
      icon: Icons.menu_book_rounded,
      createdAt: currentMonth
          .add(const Duration(days: 2))
          .copyWith(hour: 20, minute: 0),
    ),
  ];

  final totalCount = items.length;
  final pagedItems = items.skip(offset).take(limit).toList(growable: false);

  return Transactions(items: pagedItems, count: totalCount);
}

TransactionsDataStore useTransactionsData({
  int pageSize = 30,
  GetTransactions? fetcher,
}) {
  final data = ref<Transactions>(Transactions(items: const [], count: 0));
  final loading = ref(false);
  final error = ref<Object?>(null);
  final offset = ref(0);
  final hasMore = computed(() => data.value.items.length < data.value.count);
  final getTransactions = fetcher ?? defaultFetchTransactions;

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
