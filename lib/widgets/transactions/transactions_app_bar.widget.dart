import "package:flutter/material.dart";
import "package:flutter_compositions/flutter_compositions.dart";
import "package:walletplan_flutter/stores/transactions/transactions_models.dart";
import "package:walletplan_flutter/stores/transactions/transactions_scope.widget.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions_filters.dart";
import "package:walletplan_flutter/utils/beamer_context_ext.dart";
import "package:walletplan_flutter/widgets/main/main_app_bar.widget.dart";

class TransactionsAppBarWidget extends CompositionWidget
    implements PreferredSizeWidget {
  const TransactionsAppBarWidget({super.key});

  @override
  Widget Function(BuildContext) setup() {
    final viewStore = inject(
      transactionsViewStoreKey,
      defaultValue: useTransactionsViewStore(),
    );

    return (context) {
      final activeFiltersCount = countAppliedTransactionsFilters(
        state: viewStore.appliedState.value,
        defaultState: viewStore.defaultState,
      );

      return MainAppBarWidget(
        actions: [
          IconButton(
            key: const ValueKey("transactions-open-filters"),
            onPressed: () => context.beamToNamedRoot("/transactionsFilters"),
            icon: activeFiltersCount > 0
                ? Badge(
                    label: Text(
                      "$activeFiltersCount",
                      key: const ValueKey("transactions-open-filters-count"),
                    ),
                    child: const Icon(Icons.filter_alt_outlined),
                  )
                : const Icon(Icons.filter_alt_outlined),
          ),
          IconButton(
            onPressed: () => {},
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      );
    };
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
