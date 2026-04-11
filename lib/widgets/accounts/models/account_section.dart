import "package:walletplan_flutter/widgets/accounts/models/account_item.dart";

class AccountSection {
  const AccountSection({
    required this.id,
    required this.title,
    required this.sourceType,
    required this.items,
  });

  final String id;
  final String title;
  final AccountSourceType sourceType;
  final List<AccountItem> items;

  List<AccountItem> get visibleItems {
    return items.where((item) => item.isVisible).toList(growable: false);
  }
}
