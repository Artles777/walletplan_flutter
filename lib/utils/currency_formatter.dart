import "package:intl/intl.dart";

enum AppCurrency { rub, usd }

NumberFormat currencyFormatter(AppCurrency currency, {int? decimalDigits}) {
  switch (currency) {
    case AppCurrency.rub:
      return NumberFormat.currency(
        locale: "ru_RU",
        symbol: "₽",
        decimalDigits: decimalDigits ?? 2,
      );
    case AppCurrency.usd:
      return NumberFormat.currency(
        locale: "en_US",
        symbol: r"$",
        decimalDigits: decimalDigits ?? 2,
      );
  }
}

String formatCurrencyAmount(
  num amount,
  AppCurrency currency, {
  int? decimalDigits,
}) {
  return currencyFormatter(
    currency,
    decimalDigits: decimalDigits,
  ).format(amount);
}

String formatSignedCurrencyAmount(
  num amount,
  AppCurrency currency, {
  bool withPlusSign = false,
  int? decimalDigits,
}) {
  final normalized = amount.toDouble();
  final formatted = formatCurrencyAmount(
    normalized.abs(),
    currency,
    decimalDigits: decimalDigits,
  );

  if (normalized < 0) {
    return "-$formatted";
  }

  if (withPlusSign && normalized > 0) {
    return "+$formatted";
  }

  return formatted;
}
