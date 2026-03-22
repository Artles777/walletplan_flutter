import "dart:math" as math;

import "package:flutter/material.dart";
import "package:flutter_compositions/flutter_compositions.dart";
import "package:walletplan_flutter/stores/transactions/use_income_expense_fab.dart";

class MainActionButtonWidget extends CompositionWidget {
  const MainActionButtonWidget({super.key});

  @override
  Widget Function(BuildContext) setup() {
    final logic = useAddIncomeOrExpenseFab(route: "/addIncomeOrExpense");

    return (context) {
      final cs = Theme.of(context).colorScheme;

      final p = logic.progress.value.clamp(0.0, 1.0);
      final y = -18 * p;
      final angle = math.pi * p;

      return Transform.translate(
        offset: Offset(0, y),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: logic.onTap,
          onVerticalDragStart: logic.onDragStart,
          onVerticalDragUpdate: logic.onDragUpdate,
          onVerticalDragEnd: logic.onDragEnd,
          onVerticalDragCancel: logic.onDragCancel,
          child: SizedBox(
            width: 48,
            height: 48,
            child: Material(
              color: cs.primary,
              elevation: 2,
              shape: CircleBorder(
                side: BorderSide(color: cs.primaryFixedDim, width: 4),
              ),
              clipBehavior: Clip.antiAlias,
              child: Center(
                child: Transform.scale(
                  scaleX: -1,
                  child: Transform.rotate(
                    angle: angle,
                    child: const Icon(Icons.trending_down, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    };
  }
}
