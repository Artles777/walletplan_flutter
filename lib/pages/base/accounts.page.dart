import "package:flutter/material.dart";
import "package:walletplan_flutter/widgets/accounts/accounts_screen.dart";

class AccountsPage extends StatelessWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: AccountsScreen());
  }
}
