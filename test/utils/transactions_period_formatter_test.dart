import "package:flutter_test/flutter_test.dart";
import "package:intl/date_symbol_data_local.dart";
import "package:walletplan_flutter/utils/transactions_period_formatter.dart";

void main() {
  setUpAll(() async {
    await initializeDateFormatting("en");
  });

  group("transactions period formatter", () {
    test("russian picker month labels stay lowercase", () {
      expect(
        formatTransactionsPickerMonthLabel(DateTime(2026, 3), "ru"),
        "март",
      );
      expect(
        formatTransactionsPickerMonthShortLabel(DateTime(2026, 3), "ru"),
        "мар",
      );
      expect(
        formatTransactionsPickerMonthLabel(DateTime(2026, 5), "ru"),
        "май",
      );
    });

    test("english picker month labels remain capitalized", () {
      expect(
        formatTransactionsPickerMonthLabel(DateTime(2026, 3), "en"),
        "March",
      );
      expect(
        formatTransactionsPickerMonthShortLabel(DateTime(2026, 3), "en"),
        "Mar",
      );
    });
  });
}
