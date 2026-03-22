import "package:beamer/beamer.dart";
import "package:flutter/material.dart";
import "package:walletplan_flutter/router/root_delegate.dart";
import "package:walletplan_flutter/stores/transactions/use_income_expense_fab.dart";
import "package:walletplan_flutter/utils/beamer_context_ext.dart";
import "package:walletplan_flutter/widgets/add_income_or_expense/add_app_bar.widget.dart";
import "package:walletplan_flutter/widgets/add_income_or_expense/add_expense_form.widget.dart";
import "package:walletplan_flutter/widgets/add_income_or_expense/add_income_form.widget.dart";

AddType parseAddType(String? raw) {
  return raw == "income" ? AddType.income : AddType.expense;
}

Uri withAddType(Uri uri, AddType type) {
  return uri.replace(
    queryParameters: {...uri.queryParameters, "type": type.name},
  );
}

class AddIncomeOrExpansePage extends StatelessWidget {
  const AddIncomeOrExpansePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: rootDelegate,
      builder: (context, _) {
        final uri = context.rootUri;
        final type = parseAddType(uri.queryParameters["type"]);
        final initialIndex = type == AddType.income ? 1 : 0;

        void setType(AddType type) {
          final nextUri = withAddType(uri, type);

          context.rootBeamer.beamToReplacementNamed(
            nextUri.toString(),
            stacked: false,
            transitionDelegate: const NoAnimationTransitionDelegate(),
          );
        }

        return DefaultTabController(
          length: 2,
          initialIndex: initialIndex,
          child: Scaffold(
            appBar: AddAppBarWidget(setType: setType, type: type),
            body: const TabBarView(
              children: [AddExpenseFormWidget(), AddIncomeFormWidget()],
            ),
          ),
        );
      },
    );
  }
}
