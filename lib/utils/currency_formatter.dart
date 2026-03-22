import "package:intl/intl.dart";

enum AppCurrency { rub, usd }

NumberFormat currencyFormatter(AppCurrency c) {
  switch (c) {
    case AppCurrency.rub:
      return NumberFormat.currency(
        locale: "ru_RU",
        symbol: "₽",
        decimalDigits: 2,
      );
    case AppCurrency.usd:
      return NumberFormat.currency(
        locale: "en_US",
        symbol: r"$",
        decimalDigits: 2,
      );
  }
}
