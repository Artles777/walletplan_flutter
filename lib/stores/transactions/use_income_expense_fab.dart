import "package:flutter/animation.dart";
import "package:flutter/gestures.dart";
import "package:flutter/services.dart";
import "package:flutter_compositions/flutter_compositions.dart";
import "package:walletplan_flutter/router/root_delegate.dart";

enum AddType { income, expense }

typedef FabLogic = ({
  Ref<double> progress,
  VoidCallback onTap,
  GestureDragStartCallback onDragStart,
  GestureDragUpdateCallback onDragUpdate,
  GestureDragEndCallback onDragEnd,
  VoidCallback onDragCancel,
});

({
  void Function() onDragCancel,
  void Function(DragEndDetails _) onDragEnd,
  void Function(DragStartDetails _) onDragStart,
  void Function(DragUpdateDetails d) onDragUpdate,
  void Function() onTap,
  ReadonlyRef<double> progress,
})
useAddIncomeOrExpenseFab({
  required String route,
  double liftPx = 18,
  double threshold = 0.6,
  bool haptics = true,
}) {
  final (controller, t) = useAnimationController(
    duration: const Duration(milliseconds: 170),
    reverseDuration: const Duration(milliseconds: 190),
  );

  final isDragging = ref(false);
  final isLocked = ref(false);
  final dragAccum = ref(0.0);

  String path(AddType type) => "$route?type=${type.name}";

  void reset() {
    dragAccum.value = 0.0;
    controller.animateBack(
      0.0,
      duration: const Duration(milliseconds: 170),
      curve: Curves.easeOut,
    );
  }

  void onTap() {
    if (isLocked.value || isDragging.value) return;
    rootDelegate.beamToNamed(path(AddType.expense));
  }

  void onDragStart(DragStartDetails _) {
    if (isLocked.value) return;
    isDragging.value = true;
    dragAccum.value = 0.0;
  }

  void onDragUpdate(DragUpdateDetails d) {
    if (isLocked.value) {
      return;
    }

    dragAccum.value += d.delta.dy;
    final up = (-dragAccum.value / liftPx).clamp(0.0, 1.0);

    controller.value = up;
  }

  Future<void> _commitIncome() async {
    if (isLocked.value) {
      return;
    }
    isLocked.value = true;

    if (haptics) HapticFeedback.selectionClick();

    await controller.animateTo(
      1.0,
      duration: const Duration(milliseconds: 170),
      curve: Curves.easeOut,
    );

    rootDelegate.beamToNamed(path(AddType.income));

    try {
      await controller.animateBack(
        0.0,
        duration: const Duration(milliseconds: 190),
        curve: Curves.easeIn,
      );
    } catch (_) {}

    dragAccum.value = 0.0;
    isLocked.value = false;
  }

  void onDragEnd(DragEndDetails _) {
    if (isLocked.value) {
      return;
    }

    final up = controller.value;
    isDragging.value = false;

    if (up >= threshold) {
      _commitIncome();
    } else {
      reset();
    }
  }

  void onDragCancel() {
    if (isLocked.value) {
      return;
    }
    isDragging.value = false;
    reset();
  }

  return (
    progress: t,
    onTap: onTap,
    onDragStart: onDragStart,
    onDragUpdate: onDragUpdate,
    onDragEnd: onDragEnd,
    onDragCancel: onDragCancel,
  );
}
