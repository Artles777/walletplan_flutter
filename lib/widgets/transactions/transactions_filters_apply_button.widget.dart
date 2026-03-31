import "dart:math" as math;

import "package:flutter/material.dart";
import "package:walletplan_flutter/i18n/strings.g.dart";

class TransactionsFiltersApplyButtonWidget extends StatelessWidget {
  const TransactionsFiltersApplyButtonWidget({
    required this.onPressed,
    required this.progress,
    super.key,
  });

  static const double buttonHeight = 50;
  static const double verticalPadding = 16;
  static const double horizontalPadding = 16;

  static double bottomPaddingForInset(double bottomInset) {
    if (bottomInset <= 0) {
      return verticalPadding;
    }

    return math.max(12, math.min(20, bottomInset * 0.5));
  }

  static double panelHeightForInset(double bottomInset) {
    return buttonHeight + verticalPadding + bottomPaddingForInset(bottomInset);
  }

  final VoidCallback? onPressed;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0).toDouble();
    final isVisible = clampedProgress > 0.001;
    if (!isVisible) {
      return const SizedBox.shrink();
    }

    return _TransactionsFiltersApplyPanelWidget(
      key: const ValueKey("transactions-filters-apply-panel"),
      onPressed: onPressed,
      progress: clampedProgress,
    );
  }
}

class _TransactionsFiltersApplyPanelWidget extends StatelessWidget {
  const _TransactionsFiltersApplyPanelWidget({
    required this.onPressed,
    required this.progress,
    super.key,
  });

  final VoidCallback? onPressed;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final width = math.min(MediaQuery.sizeOf(context).width - 32, 420.0);
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    final bottomPadding =
        TransactionsFiltersApplyButtonWidget.bottomPaddingForInset(bottomInset);
    final panelHeight =
        TransactionsFiltersApplyButtonWidget.panelHeightForInset(bottomInset);

    return IgnorePointer(
      ignoring: progress < 0.999,
      child: Transform.translate(
        offset: Offset(0, (1 - progress) * panelHeight),
        child: Opacity(
          opacity: progress,
          child: SizedBox(
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.55),
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  TransactionsFiltersApplyButtonWidget.horizontalPadding,
                  TransactionsFiltersApplyButtonWidget.verticalPadding,
                  TransactionsFiltersApplyButtonWidget.horizontalPadding,
                  bottomPadding,
                ),
                child: Center(
                  child: SizedBox(
                    width: width,
                    height: TransactionsFiltersApplyButtonWidget.buttonHeight,
                    child: FilledButton(
                      key: const ValueKey("transactions-filters-apply"),
                      onPressed: onPressed,
                      child: Text(context.t.common.apply),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
