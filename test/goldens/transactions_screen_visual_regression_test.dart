// ignore_for_file: always_use_package_imports

import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:walletplan_flutter/i18n/strings.g.dart";
import "package:walletplan_flutter/main.dart";
import "package:walletplan_flutter/router/base_delegate.dart";
import "package:walletplan_flutter/router/root_delegate.dart";

import "golden_test_harness.dart";

void resetDelegates() {
  rootDelegate.beamToNamed("/app/transactions");
  baseDelegate.beamToNamed("/app/transactions");
}

Future<void> pumpGoldenTransactionsScreen(
  WidgetTester tester, {
  Size size = defaultGoldenSurfaceSize,
}) async {
  await ensureGoldenFontsLoaded();
  await setGoldenSurfaceSize(tester, size: size);
  await tester.pumpWidget(
    TranslationProvider(
      child: const RepaintBoundary(key: goldenSurfaceKey, child: MyApp()),
    ),
  );
  await tester.pumpAndSettle();
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

  testWidgets("transactions shell screen matches golden", (tester) async {
    await pumpGoldenTransactionsScreen(tester);

    await expectLater(
      find.byKey(goldenSurfaceKey),
      matchesGoldenFile("goldens/transactions_screen_shell.png"),
    );
  });

  testWidgets("transactions shell filtered state matches golden", (
    tester,
  ) async {
    await pumpGoldenTransactionsScreen(tester);

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

    await expectLater(
      find.byKey(goldenSurfaceKey),
      matchesGoldenFile("goldens/transactions_screen_filtered.png"),
    );
  });
}
