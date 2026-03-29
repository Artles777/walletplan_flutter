import "package:flutter/material.dart";

class TransactionsPeriodPickerChoiceButtonWidget extends StatelessWidget {
  const TransactionsPeriodPickerChoiceButtonWidget({
    required this.buttonKey,
    required this.child,
    required this.isEnabled,
    required this.isFocused,
    this.onPressed,
    super.key,
  });

  final Key buttonKey;
  final Widget child;
  final bool isEnabled;
  final bool isFocused;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FilledButton.tonal(
      key: buttonKey,
      style: FilledButton.styleFrom(
        backgroundColor: isFocused
            ? colorScheme.primary
            : isEnabled
            ? colorScheme.surfaceContainerLow
            : colorScheme.surfaceContainerHighest,
        foregroundColor: isFocused
            ? colorScheme.onPrimary
            : isEnabled
            ? colorScheme.onSurface
            : colorScheme.outline,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      onPressed: isEnabled ? onPressed : null,
      child: child,
    );
  }
}
