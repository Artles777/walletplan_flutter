import "package:flutter/material.dart";
import "package:flutter_compositions/flutter_compositions.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions_period_picker.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions_period_picker_navigation.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_period_picker_keys.dart";

class TransactionsPeriodPickerNavigationWidget extends CompositionWidget {
  const TransactionsPeriodPickerNavigationWidget({
    required this.localeTag,
    required this.pickerStore,
    super.key,
  });

  final String localeTag;
  final TransactionsPeriodPickerStore pickerStore;

  @override
  Widget Function(BuildContext) setup() {
    final navigationStore = useTransactionsPeriodPickerNavigation(
      localeTag: localeTag,
      pickerStore: pickerStore,
    );

    return (context) {
      final monthLabel = navigationStore.monthLabel.value;
      final yearLabel = navigationStore.yearLabel.value;
      final canGoPreviousMonth = navigationStore.canGoPreviousMonth.value;
      final canGoNextMonth = navigationStore.canGoNextMonth.value;
      final canGoPreviousYear = navigationStore.canGoPreviousYear.value;
      final canGoNextYear = navigationStore.canGoNextYear.value;

      return Row(
        children: [
          Expanded(
            child: _NavigationSectionWidget(
              child: Row(
                children: [
                  IconButton(
                    key: const ValueKey(
                      "transactions-period-picker-month-prev",
                    ),
                    onPressed: canGoPreviousMonth
                        ? navigationStore.goPreviousMonth
                        : null,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(
                      width: 24,
                      height: 34,
                    ),
                    iconSize: 16,
                    icon: const Icon(Icons.chevron_left_rounded),
                    visualDensity: VisualDensity.compact,
                    splashRadius: 16,
                  ),
                  Expanded(
                    child: TextButton(
                      key: transactionsPeriodPickerHeaderMonthKey,
                      onPressed: navigationStore.openMonthView,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 6,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(monthLabel, maxLines: 1, softWrap: false),
                      ),
                    ),
                  ),
                  IconButton(
                    key: const ValueKey(
                      "transactions-period-picker-month-next",
                    ),
                    onPressed: canGoNextMonth
                        ? navigationStore.goNextMonth
                        : null,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(
                      width: 24,
                      height: 34,
                    ),
                    iconSize: 16,
                    icon: const Icon(Icons.chevron_right_rounded),
                    visualDensity: VisualDensity.compact,
                    splashRadius: 16,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 120,
            child: _NavigationSectionWidget(
              child: Row(
                children: [
                  IconButton(
                    key: const ValueKey("transactions-period-picker-year-prev"),
                    onPressed: canGoPreviousYear
                        ? navigationStore.goPreviousYear
                        : null,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(
                      width: 24,
                      height: 34,
                    ),
                    iconSize: 16,
                    icon: const Icon(Icons.chevron_left_rounded),
                    visualDensity: VisualDensity.compact,
                    splashRadius: 16,
                  ),
                  Expanded(
                    child: TextButton(
                      key: transactionsPeriodPickerHeaderYearKey,
                      onPressed: navigationStore.openYearView,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 6,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                      child: Text(yearLabel, maxLines: 1, softWrap: false),
                    ),
                  ),
                  IconButton(
                    key: const ValueKey("transactions-period-picker-year-next"),
                    onPressed: canGoNextYear
                        ? navigationStore.goNextYear
                        : null,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(
                      width: 24,
                      height: 34,
                    ),
                    iconSize: 16,
                    icon: const Icon(Icons.chevron_right_rounded),
                    visualDensity: VisualDensity.compact,
                    splashRadius: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    };
  }
}

class _NavigationSectionWidget extends StatelessWidget {
  const _NavigationSectionWidget({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
