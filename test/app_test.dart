import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:walletplan_flutter/i18n/strings.g.dart";
import "package:walletplan_flutter/main.dart";
import "package:walletplan_flutter/router/base_delegate.dart";
import "package:walletplan_flutter/router/root_delegate.dart";

Widget buildApp() {
  return TranslationProvider(child: const MyApp());
}

void resetAppDelegates() {
  rootDelegate.beamToNamed("/app/transactions");
  baseDelegate.beamToNamed("/app/transactions");
}

void main() {
  setUpAll(() async {
    await LocaleSettings.setLocale(AppLocale.ru);
  });

  setUp(() {
    resetAppDelegates();
  });

  testWidgets("app renders shell, balance and initial transactions tab", (
    tester,
  ) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.textContaining("240"), findsOneWidget);
    expect(find.text("Мир **0037"), findsOneWidget);
    expect(find.text("Транзакции"), findsOneWidget);
    expect(find.text("Счета"), findsOneWidget);
    expect(find.text("Планы"), findsOneWidget);
    expect(find.text("Аналитика"), findsOneWidget);
    expect(find.text("Рестораны и кафе"), findsOneWidget);
    expect(find.text("Сегодня"), findsWidgets);
    expect(find.byIcon(Icons.trending_down), findsOneWidget);
  });

  testWidgets("bottom navigation switches between base tabs", (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text("Счета"));
    await tester.pumpAndSettle();

    expect(find.byType(Placeholder), findsOneWidget);
    expect(baseDelegate.configuration.uri.path, "/app/accounts");
  });

  testWidgets("period picker opens from transactions header", (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey("transactions-period-picker-open")),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey("transactions-period-picker-dialog")),
      findsOneWidget,
    );
  });

  testWidgets("fab tap opens expense screen", (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.trending_down));
    await tester.pumpAndSettle();

    expect(find.text("Расход"), findsWidgets);
    expect(rootDelegate.configuration.uri.queryParameters["type"], "expense");
  });

  testWidgets("root add route reflects income tab title and can switch tabs", (
    tester,
  ) async {
    rootDelegate.beamToNamed("/addIncomeOrExpense?type=income");

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text("Доход"), findsWidgets);

    await tester.tap(find.text("Расход").last);
    await tester.pumpAndSettle();

    expect(rootDelegate.configuration.uri.queryParameters["type"], "expense");
  });
}
