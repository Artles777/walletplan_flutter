import "package:flutter/animation.dart";
import "package:flutter/gestures.dart";
import "package:flutter/services.dart";
import "package:flutter_compositions/flutter_compositions.dart";
import "package:walletplan_flutter/router/root_delegate.dart";

enum AddType { income, expense }

typedef NavigateToAddFlow = void Function(String path);

typedef FabLogic = ({
  Ref<double> progress,
  VoidCallback onTap,
  GestureDragStartCallback onDragStart,
  GestureDragUpdateCallback onDragUpdate,
  GestureDragEndCallback onDragEnd,
  VoidCallback onDragCancel,
});

String addTypePath({required String route, required AddType type}) {
  return "$route?type=${type.name}";
}

double addTypeProgress({required double dragAccum, required double liftPx}) {
  return (-dragAccum / liftPx).clamp(0.0, 1.0).toDouble();
}

bool shouldOpenIncome({required double progress, required double threshold}) {
  return progress >= threshold;
}

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
  NavigateToAddFlow? navigateTo,
}) {
  assert(liftPx > 0, "liftPx must be greater than zero");
  assert(threshold >= 0 && threshold <= 1, "threshold must be between 0 and 1");

  final (controller, t) = useAnimationController(
    duration: const Duration(milliseconds: 170),
    reverseDuration: const Duration(milliseconds: 190),
  );

  final isDragging = ref(false);
  final isLocked = ref(false);
  final dragAccum = ref(0.0);
  final navigate = navigateTo ?? rootDelegate.beamToNamed;

  void reset() {
    dragAccum.value = 0.0;
    controller.animateBack(
      0.0,
      duration: const Duration(milliseconds: 170),
      curve: Curves.easeOut,
    );
  }

  void onTap() {
    if (isLocked.value || isDragging.value) {
      return;
    }

    navigate(addTypePath(route: route, type: AddType.expense));
  }

  void onDragStart(DragStartDetails _) {
    if (isLocked.value) {
      return;
    }

    isDragging.value = true;
    dragAccum.value = 0.0;
  }

  void onDragUpdate(DragUpdateDetails d) {
    if (isLocked.value) {
      return;
    }

    dragAccum.value += d.delta.dy;
    final up = addTypeProgress(dragAccum: dragAccum.value, liftPx: liftPx);

    controller.value = up;
  }

  Future<void> commitIncome() async {
    if (isLocked.value) {
      return;
    }

    isLocked.value = true;

    if (haptics) {
      HapticFeedback.selectionClick();
    }

    await controller.animateTo(
      1.0,
      duration: const Duration(milliseconds: 170),
      curve: Curves.easeOut,
    );

    navigate(addTypePath(route: route, type: AddType.income));

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

    if (shouldOpenIncome(progress: up, threshold: threshold)) {
      commitIncome();
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
