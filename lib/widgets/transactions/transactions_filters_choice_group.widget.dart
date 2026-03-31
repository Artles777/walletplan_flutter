import "package:flutter/material.dart";

class TransactionsFiltersChoiceGroupWidget<T> extends StatelessWidget {
  const TransactionsFiltersChoiceGroupWidget({
    required this.options,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<(T value, String label)> options;
  final T selected;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final option in options)
          _TransactionsFiltersChoiceButtonWidget(
            widgetKey: ValueKey(
              "transactions-filters-choice-${option.$2}-${selected == option.$1 ? "selected" : "idle"}",
            ),
            label: option.$2,
            selected: selected == option.$1,
            onPressed: () => onSelected(option.$1),
          ),
      ],
    );
  }
}

class _TransactionsFiltersChoiceButtonWidget extends StatelessWidget {
  const _TransactionsFiltersChoiceButtonWidget({
    required this.widgetKey,
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final Key widgetKey;
  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      key: widgetKey,
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? colorScheme.primaryContainer
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? colorScheme.primaryContainer
                  : colorScheme.outlineVariant,
            ),
          ),
          child: Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: selected
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
