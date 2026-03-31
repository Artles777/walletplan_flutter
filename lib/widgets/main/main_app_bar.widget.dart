import "package:flutter/material.dart";
import "package:walletplan_flutter/utils/currency_formatter.dart";

class MainAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBarWidget({this.actions, super.key});

  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    final fmt = currencyFormatter(AppCurrency.rub);

    return AppBar(
      centerTitle: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fmt.format(240000.60),
            style: tt.titleMedium,
            selectionColor: cs.onSurface,
          ),
          Text(
            "Мир **0037",
            style: tt.labelMedium,
            selectionColor: cs.surfaceTint,
          ),
        ],
      ),
      actions: [
        ...(actions ??
            [
              IconButton(
                onPressed: () => {},
                icon: const Icon(Icons.manage_search_outlined),
              ),
              IconButton(
                onPressed: () => {},
                icon: const Icon(Icons.settings_outlined),
              ),
            ]),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
