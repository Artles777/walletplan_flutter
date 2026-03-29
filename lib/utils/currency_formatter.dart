import "package:intl/intl.dart";

enum AppCurrency { rub, usd }

NumberFormat currencyFormatter(AppCurrency currency) {
  switch (currency) {
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

String formatCurrencyAmount(num amount, AppCurrency currency) {
  return currencyFormatter(currency).format(amount);
}

String formatSignedCurrencyAmount(
  num amount,
  AppCurrency currency, {
  bool withPlusSign = false,
}) {
  final normalized = amount.toDouble();
  final formatted = formatCurrencyAmount(normalized.abs(), currency);

  if (normalized < 0) {
    return "-$formatted";
  }

  if (withPlusSign && normalized > 0) {
    return "+$formatted";
  }

  return formatted;
}
