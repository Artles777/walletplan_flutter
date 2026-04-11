import "package:flutter/material.dart";
import "package:walletplan_flutter/utils/currency_formatter.dart";

enum AccountType { bankCard, cash, savings, reserve, brokerage, cryptoWallet }

enum AccountSourceType { connected, manual, investment }

enum AccountSyncStatus { success, warning, error }

class AccountItem {
  const AccountItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.currency,
    required this.type,
    required this.sourceType,
    required this.icon,
    required this.isVisible,
    this.lastDigits,
    this.paymentSystem,
    this.syncStatus,
    this.syncLabel,
    this.progress,
  });

  final String id;
  final String title;
  final String subtitle;
  final double amount;
  final AppCurrency currency;
  final AccountType type;
  final AccountSourceType sourceType;
  final IconData icon;
  final String? lastDigits;
  final String? paymentSystem;
  final AccountSyncStatus? syncStatus;
  final String? syncLabel;
  final bool isVisible;
  final double? progress;

  bool get hasSyncState => syncStatus != null && syncLabel != null;

  String get displayTitle {
    final segments = <String>[title];

    if (paymentSystem != null && paymentSystem!.isNotEmpty) {
      segments.add(paymentSystem!);
    }

    if (lastDigits != null && lastDigits!.isNotEmpty) {
      segments.add(lastDigits!);
    }

    return switch (segments.length) {
      0 => "",
      1 => segments.first,
      2 => "${segments[0]} ${segments[1]}",
      _ => "${segments[0]} ${segments[1]} · ${segments[2]}",
    };
  }
}
