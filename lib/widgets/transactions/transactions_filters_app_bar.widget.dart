import "package:flutter/material.dart";
import "package:walletplan_flutter/i18n/strings.g.dart";

class TransactionsFiltersAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const TransactionsFiltersAppBarWidget({
    required this.onCancel,
    required this.onReset,
    required this.canReset,
    super.key,
  });

  final VoidCallback onCancel;
  final VoidCallback onReset;
  final bool canReset;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      leading: IconButton(
        key: const ValueKey("transactions-filters-back"),
        onPressed: onCancel,
        icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
      ),
      title: Text(context.t.transactionsFiltersPage.title),
      actions: [
        TextButton(
          key: const ValueKey("transactions-filters-reset"),
          onPressed: canReset ? onReset : null,
          child: Text(context.t.common.reset),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
