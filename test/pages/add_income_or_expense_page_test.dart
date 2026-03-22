import "package:flutter_test/flutter_test.dart";
import "package:walletplan_flutter/pages/common/add_income_or_expense.page.dart";
import "package:walletplan_flutter/stores/transactions/use_income_expense_fab.dart";

void main() {
  group("parseAddType", () {
    test("returns income only for explicit income value", () {
      expect(parseAddType("income"), AddType.income);
      expect(parseAddType("expense"), AddType.expense);
      expect(parseAddType(null), AddType.expense);
      expect(parseAddType("other"), AddType.expense);
    });
  });

  group("withAddType", () {
    test("replaces type and preserves other query parameters", () {
      final uri = Uri.parse("/addIncomeOrExpense?foo=bar&type=expense");

      final next = withAddType(uri, AddType.income);

      expect(next.path, "/addIncomeOrExpense");
      expect(next.queryParameters["foo"], "bar");
      expect(next.queryParameters["type"], "income");
    });

    test("adds type when query is empty", () {
      final next = withAddType(
        Uri.parse("/addIncomeOrExpense"),
        AddType.expense,
      );

      expect(next.toString(), "/addIncomeOrExpense?type=expense");
    });
  });
}
