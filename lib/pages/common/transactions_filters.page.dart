import "package:flutter/material.dart";
import "package:flutter_compositions/flutter_compositions.dart";
import "package:walletplan_flutter/stores/transactions/transactions_scope.widget.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions_filters.dart";
import "package:walletplan_flutter/utils/beamer_context_ext.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_filters_app_bar.widget.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_filters_apply_button.widget.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_filters_body.widget.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_period_header.widget.dart";

class TransactionsFiltersPage extends CompositionWidget {
  const TransactionsFiltersPage({super.key});

  @override
  Widget Function(BuildContext) setup() {
    final contextRef = useContext();
    final transactionsStore = inject(
      transactionsStoreKey,
      defaultValue: useTransactions(),
    );
    final viewStore = inject(
      transactionsViewStoreKey,
      defaultValue: useTransactionsViewStore(),
    );
    final filtersStore = useTransactionsFilters(
      transactionsStore: transactionsStore,
      viewStore: viewStore,
      onApply: () {
        final context = contextRef.value;
        if (context != null && context.mounted) {
          context.beamBackRoot();
        }
      },
    );

    return (context) {
      final hasChanges = filtersStore.hasChanges.value;
      final canReset = filtersStore.canReset.value;
      final applyButtonProgress = filtersStore.applyButtonProgress.value;
      final draftState = filtersStore.draftState.value;

      Future<void> pickPeriod() async {
        final picked = await showTransactionsPeriodPicker(
          context,
          period: draftState.filters.period,
        );
        if (picked != null && context.mounted) {
          filtersStore.setPeriod(picked);
        }
      }

      return Scaffold(
        appBar: TransactionsFiltersAppBarWidget(
          onCancel: context.beamBackRoot,
          onReset: filtersStore.resetDraft,
          canReset: canReset,
        ),
        body: Stack(
          children: [
            SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  16,
                  12,
                  16,
                  24 +
                      TransactionsFiltersApplyButtonWidget.panelHeightForInset(
                        MediaQuery.viewPaddingOf(context).bottom,
                      ),
                ),
                child: TransactionsFiltersBodyWidget(
                  store: filtersStore,
                  onPickPeriod: pickPeriod,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: TransactionsFiltersApplyButtonWidget(
                onPressed: hasChanges ? filtersStore.apply : null,
                progress: applyButtonProgress,
              ),
            ),
          ],
        ),
      );
    };
  }
}
