import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:walletplan_flutter/i18n/strings.g.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_day_section.widget.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_period_header.widget.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_list_view.widget.dart";

void main() {
  setUpAll(() async {
    await LocaleSettings.setLocale(AppLocale.ru);
  });

  testWidgets("period header stays outside scroll view "
      "and day sections use pinned sliver groups", (tester) async {
    await tester.pumpWidget(
      TranslationProvider(
        child: const MaterialApp(
          locale: Locale("ru"),
          home: Scaffold(body: TransactionsListViewWidget()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final periodHeader = find.byType(TransactionsPeriodHeaderWidget);
    final scrollView = find.byType(CustomScrollView);

    expect(periodHeader, findsOneWidget);
    expect(scrollView, findsOneWidget);
    expect(find.ancestor(of: periodHeader, matching: scrollView), findsNothing);
    expect(find.byType(SliverMainAxisGroup), findsWidgets);

    final firstSection = tester.widget<TransactionsDaySectionWidget>(
      find.byType(TransactionsDaySectionWidget).first,
    );
    expect(firstSection.showHeader, isFalse);
  });
}
