import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:walletplan_flutter/i18n/strings.g.dart";
import "package:walletplan_flutter/widgets/accounts/accounts_screen.dart";

void main() {
  setUpAll(() async {
    await LocaleSettings.setLocale(AppLocale.ru);
  });

  testWidgets("summary block stays pinned and keeps add action inside", (
    tester,
  ) async {
    await tester.pumpWidget(
      TranslationProvider(
        child: const MaterialApp(
          locale: Locale("ru"),
          home: Scaffold(body: AccountsScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(CustomScrollView), findsOneWidget);
    expect(find.byType(SliverPersistentHeader), findsOneWidget);
    expect(
      find.byKey(const ValueKey("accounts-summary-add-account")),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey("accounts-summary-title")),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey("accounts-summary-total")),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey("accounts-summary-active")),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey("accounts-summary-breakdown")),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey("accounts-summary-divider")),
      findsOneWidget,
    );
    expect(find.text("Подключенные счета"), findsOneWidget);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -320));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey("accounts-summary-title")),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey("accounts-summary-total")),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey("accounts-summary-add-account")),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey("accounts-summary-divider")),
      findsNothing,
    );
    expect(find.byKey(const ValueKey("accounts-summary-active")), findsNothing);
    expect(
      find.byKey(const ValueKey("accounts-summary-breakdown")),
      findsNothing,
    );
    expect(find.text("Инвестиции"), findsOneWidget);
  });
}
