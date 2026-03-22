import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_compositions/flutter_compositions.dart";
import "package:flutter_test/flutter_test.dart";
import "package:walletplan_flutter/stores/transactions/use_income_expense_fab.dart";

typedef AddFabLogic = ({
  void Function() onDragCancel,
  void Function(DragEndDetails _) onDragEnd,
  void Function(DragStartDetails _) onDragStart,
  void Function(DragUpdateDetails d) onDragUpdate,
  void Function() onTap,
  ReadonlyRef<double> progress,
});

class _AddFabHarness extends CompositionWidget {
  const _AddFabHarness({
    required this.onReady,
    required this.navigateTo,
    required this.route,
    required this.liftPx,
    required this.threshold,
  });

  final void Function(AddFabLogic logic) onReady;
  final NavigateToAddFlow navigateTo;
  final String route;
  final double liftPx;
  final double threshold;

  @override
  Widget Function(BuildContext context) setup() {
    final logic = useAddIncomeOrExpenseFab(
      route: route,
      navigateTo: navigateTo,
      haptics: false,
      liftPx: liftPx,
      threshold: threshold,
    );

    onMounted(() {
      onReady(logic);
    });

    return (_) => const SizedBox.shrink();
  }
}

Future<AddFabLogic> pumpAddFabHarness(
  WidgetTester tester, {
  required NavigateToAddFlow navigateTo,
  String route = "/addIncomeOrExpense",
  double liftPx = 18,
  double threshold = 0.6,
}) async {
  final completer = Completer<AddFabLogic>();

  await tester.pumpWidget(
    MaterialApp(
      home: _AddFabHarness(
        onReady: completer.complete,
        navigateTo: navigateTo,
        route: route,
        liftPx: liftPx,
        threshold: threshold,
      ),
    ),
  );
  await tester.pump();

  return completer.future;
}

void main() {
  group("add income or expense fab helpers", () {
    test("builds route path by add type", () {
      expect(
        addTypePath(route: "/addIncomeOrExpense", type: AddType.expense),
        "/addIncomeOrExpense?type=expense",
      );
      expect(
        addTypePath(route: "/addIncomeOrExpense", type: AddType.income),
        "/addIncomeOrExpense?type=income",
      );
    });

    test("converts drag distance to normalized progress", () {
      expect(addTypeProgress(dragAccum: 0, liftPx: 18), 0);
      expect(addTypeProgress(dragAccum: -9, liftPx: 18), 0.5);
      expect(addTypeProgress(dragAccum: -90, liftPx: 18), 1);
      expect(addTypeProgress(dragAccum: 20, liftPx: 18), 0);
    });

    test("decides whether income flow should open", () {
      expect(shouldOpenIncome(progress: 0.6, threshold: 0.6), isTrue);
      expect(shouldOpenIncome(progress: 0.59, threshold: 0.6), isFalse);
    });
  });

  group("useAddIncomeOrExpenseFab", () {
    testWidgets("tap opens expense flow", (tester) async {
      final navigated = <String>[];
      final logic = await pumpAddFabHarness(tester, navigateTo: navigated.add);

      logic.onTap();
      await tester.pump();

      expect(navigated, ["/addIncomeOrExpense?type=expense"]);
    });

    testWidgets("short drag resets progress without navigation", (
      tester,
    ) async {
      final navigated = <String>[];
      final logic = await pumpAddFabHarness(tester, navigateTo: navigated.add);

      logic.onDragStart(DragStartDetails());
      logic.onDragUpdate(
        DragUpdateDetails(
          globalPosition: Offset.zero,
          delta: const Offset(0, -5),
        ),
      );
      expect(logic.progress.value, greaterThan(0));

      logic.onDragEnd(DragEndDetails());
      await tester.pumpAndSettle();

      expect(logic.progress.value, 0);
      expect(navigated, isEmpty);
    });

    testWidgets("long drag opens income flow and animates back", (
      tester,
    ) async {
      final navigated = <String>[];
      final logic = await pumpAddFabHarness(tester, navigateTo: navigated.add);

      logic.onDragStart(DragStartDetails());
      logic.onDragUpdate(
        DragUpdateDetails(
          globalPosition: Offset.zero,
          delta: const Offset(0, -30),
        ),
      );
      logic.onDragEnd(DragEndDetails());

      await tester.pumpAndSettle();

      expect(logic.progress.value, 0);
      expect(navigated, ["/addIncomeOrExpense?type=income"]);
    });
  });
}
