import "package:beamer/beamer.dart";
import "package:flutter/material.dart";
import "package:walletplan_flutter/router/base_delegate.dart";
import "package:walletplan_flutter/widgets/main/main_action_button.widget.dart";
import "package:walletplan_flutter/widgets/main/main_app_bar.widget.dart";
import "package:walletplan_flutter/widgets/main/main_drawer.widget.dart";
import "package:walletplan_flutter/widgets/main/main_navigation_bar.widget.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_app_bar.widget.dart";

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: baseDelegate,
      builder: (context, _) {
        final currentRoute = routeFromUri(baseDelegate.configuration.uri);

        return Scaffold(
          drawer: const MainDrawerWidget(),
          appBar: switch (currentRoute) {
            BaseRoutesEnum.transactions => const TransactionsAppBarWidget(),
            BaseRoutesEnum.accounts => MainAppBarWidget(
              actions: [
                IconButton(
                  onPressed: () => debugPrint("Manage accounts tapped"),
                  icon: const Icon(Icons.manage_accounts_outlined),
                ),
                IconButton(
                  onPressed: () => debugPrint("Open settings tapped"),
                  icon: const Icon(Icons.settings_outlined),
                ),
              ],
            ),
            _ => const MainAppBarWidget(),
          },
          body: Beamer(routerDelegate: baseDelegate),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: const MainActionButtonWidget(),
          bottomNavigationBar: const MainNavigationBarWidget(),
        );
      },
    );
  }
}
