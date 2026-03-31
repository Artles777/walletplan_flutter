import "package:flutter_test/flutter_test.dart";
import "package:walletplan_flutter/utils/currency_formatter.dart";

void main() {
  group("currencyFormatter", () {
    test("formats rub values with ruble symbol and russian decimals", () {
      final result = currencyFormatter(AppCurrency.rub).format(240000.6);

      expect(result, contains("₽"));
      expect(result, contains("240"));
      expect(result, contains(",60"));
    });

    test("formats usd values with dollar symbol and english decimals", () {
      final result = currencyFormatter(AppCurrency.usd).format(42);

      expect(result, contains(r"$"));
      expect(result, contains("42.00"));
    });

    test("formats signed values with optional plus sign", () {
      expect(
        formatSignedCurrencyAmount(-1250, AppCurrency.rub),
        startsWith("-"),
      );
      expect(
        formatSignedCurrencyAmount(1250, AppCurrency.rub, withPlusSign: true),
        startsWith("+"),
      );
    });
  });
}
