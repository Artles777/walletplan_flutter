import "package:beamer/beamer.dart";
import "package:flutter/foundation.dart";
import "package:walletplan_flutter/pages/common/add_income_or_expense.page.dart";
import "package:walletplan_flutter/pages/common/signIn.page.dart";
import "package:walletplan_flutter/pages/common/transactions_filters.page.dart";
import "package:walletplan_flutter/pages/main/main.page.dart";

final rootDelegate = BeamerDelegate(
  initialPath: "/app/transactions",
  locationBuilder: RoutesLocationBuilder(
    routes: {
      "/signIn": (context, state, data) => const SignInPage(),
      "/addIncomeOrExpense": (context, state, data) => const BeamPage(
        key: ValueKey("addIncomeOrExpense"),
        type: BeamPageType.noTransition,
        child: AddIncomeOrExpansePage(),
      ),
      "/transactionsFilters": (context, state, data) => const BeamPage(
        key: ValueKey("transactionsFilters"),
        type: BeamPageType.noTransition,
        child: TransactionsFiltersPage(),
      ),
      "/app/*": (context, state, data) => const MainPage(),
    },
  ).call,
);
