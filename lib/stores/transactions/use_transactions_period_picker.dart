import "package:flutter_compositions/flutter_compositions.dart";
import "package:walletplan_flutter/stores/transactions/use_transactions.dart";
import "package:walletplan_flutter/widgets/transactions/transactions_period_picker_logic.dart";

enum TransactionsPeriodPickerView { day, month, year }

typedef TransactionsPeriodPickerStore = (
  ReadonlyRef<TransactionsPeriodSelection> draftSelection,
  ReadonlyRef<TransactionsPeriodPickerView> pickerView,
  ReadonlyRef<DateTime> displayedDate,
  ReadonlyRef<TransactionsPeriodSelection?> appliedSelection,
  ReadonlyRef<DateTime?> previousMonth,
  ReadonlyRef<DateTime?> nextMonth,
  ReadonlyRef<DateTime?> previousYear,
  ReadonlyRef<DateTime?> nextYear,
  void Function([DateTime? monthDate]) openMonthView,
  void Function([int? year]) openYearView,
  void Function(DateTime monthDate) openDayViewForMonth,
  void Function(int candidateYear) moveToYear,
  void Function(DateTime date) selectDate,
  void Function(int year) selectYear,
);

extension TransactionsPeriodPickerStoreExt on TransactionsPeriodPickerStore {
  ReadonlyRef<TransactionsPeriodSelection> get draftSelection => this.$1;

  ReadonlyRef<TransactionsPeriodPickerView> get pickerView => this.$2;

  ReadonlyRef<DateTime> get displayedDate => this.$3;

  ReadonlyRef<TransactionsPeriodSelection?> get appliedSelection => this.$4;

  ReadonlyRef<DateTime?> get previousMonth => this.$5;

  ReadonlyRef<DateTime?> get nextMonth => this.$6;

  ReadonlyRef<DateTime?> get previousYear => this.$7;

  ReadonlyRef<DateTime?> get nextYear => this.$8;

  void Function([DateTime? monthDate]) get openMonthView => this.$9;

  void Function([int? year]) get openYearView => this.$10;

  void Function(DateTime monthDate) get openDayViewForMonth => this.$11;

  void Function(int candidateYear) get moveToYear => this.$12;

  void Function(DateTime date) get selectDate => this.$13;

  void Function(int year) get selectYear => this.$14;
}

TransactionsPeriodPickerStore useTransactionsPeriodPicker({
  required TransactionsPeriodSelection initialSelection,
  required TransactionsPeriodPickerView initialView,
  required TransactionsPeriodPickerConstraints constraints,
}) {
  final draftSelection = ref(initialSelection);
  final pickerView = ref(initialView);
  final displayedDate = ref(
    DateTime(
      periodSelectionEndDate(initialSelection).year,
      periodSelectionEndDate(initialSelection).month,
    ),
  );

  final appliedSelection = computed(() {
    switch (pickerView.value) {
      case TransactionsPeriodPickerView.year:
        return buildFullYearPeriodSelection(
          constraints,
          displayedDate.value.year,
        );
      case TransactionsPeriodPickerView.month:
        return buildFullMonthPeriodSelection(constraints, displayedDate.value);
      case TransactionsPeriodPickerView.day:
        return clampPeriodSelectionToConstraints(
          constraints,
          draftSelection.value,
        );
    }
  });

  final previousMonth = computed(
    () => previousSelectableMonth(constraints, displayedDate.value),
  );
  final nextMonth = computed(
    () => nextSelectableMonth(constraints, displayedDate.value),
  );
  final previousYear = computed(
    () => previousSelectableYear(constraints, displayedDate.value.year),
  );
  final nextYear = computed(
    () => nextSelectableYear(constraints, displayedDate.value.year),
  );

  void openMonthView([DateTime? monthDate]) {
    final resolvedMonthDate =
        monthDate ??
        resolveSelectableMonthInYear(
          constraints,
          year: displayedDate.value.year,
          preferredMonth: displayedDate.value.month,
        );
    if (resolvedMonthDate == null) {
      return;
    }

    final monthSelection = buildFullMonthPeriodSelection(
      constraints,
      resolvedMonthDate,
    );
    if (monthSelection == null) {
      return;
    }

    displayedDate.value = DateTime(
      resolvedMonthDate.year,
      resolvedMonthDate.month,
    );
    draftSelection.value = monthSelection;
    pickerView.value = TransactionsPeriodPickerView.month;
  }

  void openYearView([int? year]) {
    final resolvedYear = year ?? displayedDate.value.year;
    final yearSelection = buildFullYearPeriodSelection(
      constraints,
      resolvedYear,
    );
    if (yearSelection == null) {
      return;
    }

    displayedDate.value = DateTime(resolvedYear, displayedDate.value.month);
    draftSelection.value = yearSelection;
    pickerView.value = TransactionsPeriodPickerView.year;
  }

  void openDayViewForMonth(DateTime monthDate) {
    final monthSelection = buildFullMonthPeriodSelection(
      constraints,
      monthDate,
    );
    if (monthSelection == null) {
      return;
    }

    displayedDate.value = DateTime(monthDate.year, monthDate.month);
    draftSelection.value = monthSelection;
    pickerView.value = TransactionsPeriodPickerView.day;
  }

  void moveToYear(int candidateYear) {
    final resolvedMonthDate = resolveSelectableMonthInYear(
      constraints,
      year: candidateYear,
      preferredMonth: displayedDate.value.month,
    );
    if (pickerView.value == TransactionsPeriodPickerView.year) {
      openYearView(candidateYear);

      return;
    }

    if (resolvedMonthDate == null) {
      return;
    }

    if (pickerView.value == TransactionsPeriodPickerView.month) {
      openMonthView(resolvedMonthDate);

      return;
    }

    openDayViewForMonth(resolvedMonthDate);
  }

  void selectDate(DateTime date) {
    draftSelection.value = nextDayRangePeriodSelection(
      constraints: constraints,
      currentSelection: draftSelection.value,
      selectedDate: date,
    );
  }

  void selectYear(int year) {
    final resolvedMonthDate = resolveSelectableMonthInYear(
      constraints,
      year: year,
      preferredMonth: displayedDate.value.month,
    );
    if (resolvedMonthDate == null) {
      return;
    }

    openMonthView(resolvedMonthDate);
  }

  return (
    draftSelection,
    pickerView,
    displayedDate,
    appliedSelection,
    previousMonth,
    nextMonth,
    previousYear,
    nextYear,
    openMonthView,
    openYearView,
    openDayViewForMonth,
    moveToYear,
    selectDate,
    selectYear,
  );
}
