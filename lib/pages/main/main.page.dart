import "package:beamer/beamer.dart";
import "package:flutter/material.dart";
import "package:walletplan_flutter/router/base_delegate.dart";
import "package:walletplan_flutter/widgets/main/main_action_button.widget.dart";
import "package:walletplan_flutter/widgets/main/main_app_bar.widget.dart";
import "package:walletplan_flutter/widgets/main/main_drawer.widget.dart";
import "package:walletplan_flutter/widgets/main/main_navigation_bar.widget.dart";

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawerWidget(),
      appBar: const MainAppBarWidget(),
      body: Beamer(routerDelegate: baseDelegate),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const MainActionButtonWidget(),
      bottomNavigationBar: const MainNavigationBarWidget(),
    );
  }
}
