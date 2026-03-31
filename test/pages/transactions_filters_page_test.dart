import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:walletplan_flutter/i18n/strings.g.dart";
import "package:walletplan_flutter/main.dart";
import "package:walletplan_flutter/router/base_delegate.dart";
import "package:walletplan_flutter/router/root_delegate.dart";

Widget buildApp() {
  return TranslationProvider(child: const MyApp());
}

void resetDelegates() {
  rootDelegate.beamToNamed("/app/transactions");
  baseDelegate.beamToNamed("/app/transactions");
}

Future<void> tapScrollableItem(WidgetTester tester, Finder finder) async {
  final scrollable = find.byType(Scrollable).first;

  await tester.scrollUntilVisible(finder, 120, scrollable: scrollable);
  await tester.pumpAndSettle();

  final rect = tester.getRect(finder);
  if (rect.top < kToolbarHeight + 24) {
    await tester.drag(scrollable, const Offset(0, 140));
    await tester.pumpAndSettle();
  }

  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() async {
    await LocaleSettings.setLocale(AppLocale.ru);
  });

  setUp(() {
    resetDelegates();
  });

  testWidgets("opens filters screen and returns back without breaking route", (
    tester,
  ) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey("transactions-open-filters")));
    await tester.pumpAndSettle();

    expect(find.text("Фильтры"), findsOneWidget);
    expect(rootDelegate.configuration.uri.path, "/transactionsFilters");

    await tester.tap(find.byKey(const ValueKey("transactions-filters-back")));
    await tester.pumpAndSettle();

    expect(rootDelegate.configuration.uri.path, "/app/transactions");
    expect(find.text("Рестораны и кафе"), findsOneWidget);
  });

  testWidgets("apply updates transactions screen and shows active filters", (
    tester,
  ) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey("transactions-open-filters")));
    await tester.pumpAndSettle();

    await tapScrollableItem(tester, find.text("Расходы"));
    await tapScrollableItem(tester, find.text("Visa 5210"));
    await tapScrollableItem(tester, find.text("По категориям"));
    await tapScrollableItem(
      tester,
      find.widgetWithText(SwitchListTile, "Включать переводы"),
    );
    await tester.tap(find.byKey(const ValueKey("transactions-filters-apply")));
    await tester.pumpAndSettle();

    expect(rootDelegate.configuration.uri.path, "/app/transactions");
    expect(find.textContaining("Расходы"), findsOneWidget);
    expect(find.textContaining("Visa 5210"), findsOneWidget);
    expect(find.textContaining("По категориям"), findsOneWidget);
    expect(find.textContaining("Без переводов"), findsOneWidget);
    expect(find.text("Категории расходов"), findsOneWidget);
    expect(find.text("Подписки"), findsOneWidget);
    expect(find.text("Образование"), findsOneWidget);
    expect(find.text("Рестораны и кафе"), findsNothing);
    expect(
      find.byKey(const ValueKey("transactions-open-filters-count")),
      findsOneWidget,
    );
    expect(find.text("3"), findsOneWidget);
  });

  testWidgets("cancel drops draft changes and leaves base view intact", (
    tester,
  ) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey("transactions-open-filters")));
    await tester.pumpAndSettle();

    await tapScrollableItem(tester, find.text("Доходы"));
    await tapScrollableItem(tester, find.text("По категориям"));
    await tester.tap(find.byKey(const ValueKey("transactions-filters-back")));
    await tester.pumpAndSettle();

    expect(find.text("Доходы"), findsNothing);
    expect(find.text("По категориям"), findsNothing);
    expect(find.text("Сегодня"), findsWidgets);
  });

  testWidgets("reset returns draft state to defaults and disables apply", (
    tester,
  ) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey("transactions-open-filters")));
    await tester.pumpAndSettle();

    await tapScrollableItem(tester, find.text("Доходы"));

    var applyButton = tester.widget<FilledButton>(
      find.byKey(const ValueKey("transactions-filters-apply")),
    );
    expect(applyButton.onPressed, isNotNull);

    await tester.tap(find.byKey(const ValueKey("transactions-filters-reset")));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey("transactions-filters-apply")),
      findsNothing,
    );
  });

  testWidgets("reopen restores applied state instead of defaults", (
    tester,
  ) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey("transactions-open-filters")));
    await tester.pumpAndSettle();
    await tapScrollableItem(tester, find.text("Доходы"));
    await tapScrollableItem(tester, find.text("По категориям"));
    await tester.tap(find.byKey(const ValueKey("transactions-filters-apply")));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey("transactions-open-filters")));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey("transactions-filters-choice-Доходы-selected")),
      findsOneWidget,
    );
    expect(
      find.byKey(
        const ValueKey("transactions-filters-choice-По категориям-selected"),
      ),
      findsOneWidget,
    );
  });
}
