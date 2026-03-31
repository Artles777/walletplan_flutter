import "package:flutter/material.dart";
import "package:flutter_compositions/flutter_compositions.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions_period_picker.dart";
import "package:walletplan_flutter/utils/transactions_period_formatter.dart";

typedef TransactionsPeriodPickerNavigationStore = (
  ReadonlyRef<String> monthLabel,
  ReadonlyRef<String> yearLabel,
  ReadonlyRef<bool> canGoPreviousMonth,
  ReadonlyRef<bool> canGoNextMonth,
  ReadonlyRef<bool> canGoPreviousYear,
  ReadonlyRef<bool> canGoNextYear,
  VoidCallback openMonthView,
  VoidCallback openYearView,
  VoidCallback goPreviousMonth,
  VoidCallback goNextMonth,
  VoidCallback goPreviousYear,
  VoidCallback goNextYear,
);

extension TransactionsPeriodPickerNavigationStoreExt
    on TransactionsPeriodPickerNavigationStore {
  ReadonlyRef<String> get monthLabel => this.$1;

  ReadonlyRef<String> get yearLabel => this.$2;

  ReadonlyRef<bool> get canGoPreviousMonth => this.$3;

  ReadonlyRef<bool> get canGoNextMonth => this.$4;

  ReadonlyRef<bool> get canGoPreviousYear => this.$5;

  ReadonlyRef<bool> get canGoNextYear => this.$6;

  VoidCallback get openMonthView => this.$7;

  VoidCallback get openYearView => this.$8;

  VoidCallback get goPreviousMonth => this.$9;

  VoidCallback get goNextMonth => this.$10;

  VoidCallback get goPreviousYear => this.$11;

  VoidCallback get goNextYear => this.$12;
}

TransactionsPeriodPickerNavigationStore useTransactionsPeriodPickerNavigation({
  required String localeTag,
  required TransactionsPeriodPickerStore pickerStore,
}) {
  final monthLabel = computed(() {
    return formatTransactionsPickerMonthLabel(
      pickerStore.displayedDate.value,
      localeTag,
    );
  });
  final yearLabel = computed(
    () => pickerStore.displayedDate.value.year.toString(),
  );
  final canGoPreviousMonth = computed(() {
    return pickerStore.pickerView.value != TransactionsPeriodPickerView.year &&
        pickerStore.previousMonth.value != null;
  });
  final canGoNextMonth = computed(() {
    return pickerStore.pickerView.value != TransactionsPeriodPickerView.year &&
        pickerStore.nextMonth.value != null;
  });
  final canGoPreviousYear = computed(
    () => pickerStore.previousYear.value != null,
  );
  final canGoNextYear = computed(() => pickerStore.nextYear.value != null);

  void goPreviousMonth() {
    final previousMonth = pickerStore.previousMonth.value;
    if (previousMonth == null) {
      return;
    }

    if (pickerStore.pickerView.value == TransactionsPeriodPickerView.month) {
      pickerStore.openMonthView(previousMonth);

      return;
    }

    pickerStore.openDayViewForMonth(previousMonth);
  }

  void goNextMonth() {
    final nextMonth = pickerStore.nextMonth.value;
    if (nextMonth == null) {
      return;
    }

    if (pickerStore.pickerView.value == TransactionsPeriodPickerView.month) {
      pickerStore.openMonthView(nextMonth);

      return;
    }

    pickerStore.openDayViewForMonth(nextMonth);
  }

  void goPreviousYear() {
    final previousYear = pickerStore.previousYear.value;
    if (previousYear == null) {
      return;
    }

    pickerStore.moveToYear(previousYear.year);
  }

  void goNextYear() {
    final nextYear = pickerStore.nextYear.value;
    if (nextYear == null) {
      return;
    }

    pickerStore.moveToYear(nextYear.year);
  }

  return (
    monthLabel,
    yearLabel,
    canGoPreviousMonth,
    canGoNextMonth,
    canGoPreviousYear,
    canGoNextYear,
    pickerStore.openMonthView,
    pickerStore.openYearView,
    goPreviousMonth,
    goNextMonth,
    goPreviousYear,
    goNextYear,
  );
}
