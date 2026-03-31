import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions_view_summary.dart";
import "package:walletplan_flutter/utils/currency_formatter.dart";

Transaction buildViewTx(
  String id, {
  required DateTime createdAt,
  TransactionType type = TransactionType.expense,
  num amount = 10,
  String accountId = "acc-1",
  String accountName = "Account 1",
  String categoryId = "cat-1",
  String category = "Category 1",
  bool isTransfer = false,
}) {
  return Transaction(
    id: id,
    type: type,
    amount: amount,
    currency: AppCurrency.rub,
    category: category,
    title: category,
    subtitle: "subtitle-$id",
    sourceName: accountName,
    icon: Icons.account_balance_wallet_rounded,
    createdAt: createdAt,
    accountId: accountId,
    categoryId: categoryId,
    isTransfer: isTransfer,
  );
}

void main() {
  group("buildTransactionsViewSummary", () {
    test("applies period, type, account and category filters together", () {
      final summary = buildTransactionsViewSummary(
        viewState: TransactionsViewState(
          filters: TransactionsFilters(
            period: TransactionsPeriodSelection(
              date: DateTime(2025, 1),
              mode: TransactionsPeriodMode.month,
            ),
            type: TransactionsFilterType.expense,
            accountIds: const ["wallet"],
            categoryIds: const ["food"],
          ),
          presentation: const TransactionsPresentation(),
        ),
        items: [
          buildViewTx(
            "expense-match",
            createdAt: DateTime(2025, 1, 10, 12),
            accountId: "wallet",
            accountName: "Wallet",
            categoryId: "food",
            category: "Food",
            amount: 30,
          ),
          buildViewTx(
            "income-type-mismatch",
            createdAt: DateTime(2025, 1, 10, 13),
            type: TransactionType.income,
            accountId: "wallet",
            accountName: "Wallet",
            categoryId: "food",
            category: "Food",
            amount: 80,
          ),
          buildViewTx(
            "account-mismatch",
            createdAt: DateTime(2025, 1, 11, 8),
            accountId: "card",
            accountName: "Card",
            categoryId: "food",
            category: "Food",
            amount: 10,
          ),
          buildViewTx(
            "category-mismatch",
            createdAt: DateTime(2025, 1, 11, 9),
            accountId: "wallet",
            accountName: "Wallet",
            categoryId: "transport",
            category: "Transport",
            amount: 15,
          ),
          buildViewTx(
            "period-mismatch",
            createdAt: DateTime(2025, 2, 1, 10),
            accountId: "wallet",
            accountName: "Wallet",
            categoryId: "food",
            category: "Food",
            amount: 18,
          ),
        ],
      );

      expect(summary.items.map((tx) => tx.id), ["expense-match"]);
      expect(summary.groups, hasLength(1));
      expect(summary.total, -30);
    });

    test("excludes transfers when includeTransfers is false", () {
      final summary = buildTransactionsViewSummary(
        viewState: TransactionsViewState(
          filters: TransactionsFilters(
            period: TransactionsPeriodSelection(
              date: DateTime(2025, 1),
              mode: TransactionsPeriodMode.month,
            ),
            includeTransfers: false,
          ),
          presentation: const TransactionsPresentation(),
        ),
        items: [
          buildViewTx(
            "transfer",
            createdAt: DateTime(2025, 1, 3, 12),
            categoryId: "transfer",
            category: "Transfer",
            isTransfer: true,
            amount: 50,
          ),
          buildViewTx(
            "expense",
            createdAt: DateTime(2025, 1, 3, 14),
            categoryId: "food",
            category: "Food",
            amount: 25,
          ),
        ],
      );

      expect(summary.items.map((tx) => tx.id), ["expense"]);
      expect(summary.total, -25);
    });

    test("builds day groups from already filtered transactions", () {
      final summary = buildTransactionsViewSummary(
        viewState: TransactionsViewState(
          filters: TransactionsFilters(
            period: TransactionsPeriodSelection(
              date: DateTime(2025, 1),
              mode: TransactionsPeriodMode.month,
            ),
            type: TransactionsFilterType.expense,
          ),
          presentation: const TransactionsPresentation(),
        ),
        items: [
          buildViewTx(
            "same-day-late",
            createdAt: DateTime(2025, 1, 4, 18),
            amount: 30,
          ),
          buildViewTx(
            "same-day-early",
            createdAt: DateTime(2025, 1, 4, 8),
            amount: 10,
          ),
          buildViewTx(
            "other-day",
            createdAt: DateTime(2025, 1, 3, 9),
            amount: 5,
          ),
          buildViewTx(
            "income-filtered-out",
            createdAt: DateTime(2025, 1, 4, 9),
            type: TransactionType.income,
            amount: 100,
          ),
        ],
      );

      expect(summary.groups, hasLength(2));
      expect(summary.groups.first.items.map((tx) => tx.id), [
        "same-day-late",
        "same-day-early",
      ]);
      expect(summary.groups.first.total, -40);
      expect(summary.groups.last.total, -5);
    });

    test("builds category sections with totals and item counts", () {
      final summary = buildTransactionsViewSummary(
        viewState: TransactionsViewState(
          filters: TransactionsFilters(
            period: TransactionsPeriodSelection(
              date: DateTime(2025, 1),
              mode: TransactionsPeriodMode.month,
            ),
          ),
          presentation: const TransactionsPresentation(
            groupBy: TransactionsGroupBy.categories,
          ),
        ),
        items: [
          buildViewTx(
            "expense-food-1",
            createdAt: DateTime(2025, 1, 4, 18),
            categoryId: "food",
            category: "Food",
            amount: 30,
          ),
          buildViewTx(
            "expense-food-2",
            createdAt: DateTime(2025, 1, 5, 18),
            categoryId: "food",
            category: "Food",
            amount: 10,
          ),
          buildViewTx(
            "expense-transport",
            createdAt: DateTime(2025, 1, 5, 20),
            categoryId: "transport",
            category: "Transport",
            amount: 5,
          ),
          buildViewTx(
            "income-salary",
            createdAt: DateTime(2025, 1, 6, 12),
            type: TransactionType.income,
            categoryId: "salary",
            category: "Salary",
            amount: 100,
          ),
        ],
      );

      expect(summary.categorySections, hasLength(2));

      final expenseSection = summary.categorySections.first;
      final incomeSection = summary.categorySections.last;

      expect(expenseSection.type, TransactionType.expense);
      expect(expenseSection.total, -45);
      expect(expenseSection.items.first.label, "Food");
      expect(expenseSection.items.first.total, -40);
      expect(expenseSection.items.first.count, 2);
      expect(expenseSection.items.last.label, "Transport");
      expect(expenseSection.items.last.total, -5);
      expect(expenseSection.items.last.count, 1);

      expect(incomeSection.type, TransactionType.income);
      expect(incomeSection.total, 100);
      expect(incomeSection.items.single.label, "Salary");
      expect(incomeSection.items.single.total, 100);
      expect(incomeSection.items.single.count, 1);
    });

    test("returns empty day and category summaries for empty result sets", () {
      final summary = buildTransactionsViewSummary(
        viewState: TransactionsViewState(
          filters: TransactionsFilters(
            period: TransactionsPeriodSelection(
              date: DateTime(2025, 1),
              mode: TransactionsPeriodMode.month,
            ),
            categoryIds: const ["missing-category"],
          ),
          presentation: const TransactionsPresentation(
            groupBy: TransactionsGroupBy.categories,
          ),
        ),
        items: [
          buildViewTx(
            "expense-food",
            createdAt: DateTime(2025, 1, 4, 18),
            categoryId: "food",
            category: "Food",
            amount: 30,
          ),
        ],
      );

      expect(summary.items, isEmpty);
      expect(summary.groups, isEmpty);
      expect(summary.categorySections, isEmpty);
      expect(summary.total, 0);
    });
  });
}
