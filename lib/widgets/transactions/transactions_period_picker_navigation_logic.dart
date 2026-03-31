part of "transactions_period_picker_logic.dart";

List<int> pickerAvailableMonthsInYear(
  TransactionsPeriodPickerConstraints constraints,
  int year,
) {
  return [
    for (int month = 1; month <= 12; month += 1)
      if (monthHasSelectableDate(constraints, DateTime(year, month))) month,
  ];
}

DateTime? resolveSelectableMonthInYear(
  TransactionsPeriodPickerConstraints constraints, {
  required int year,
  required int preferredMonth,
}) {
  final availableMonths = pickerAvailableMonthsInYear(constraints, year);
  if (availableMonths.isEmpty) {
    return null;
  }

  final normalizedPreferredMonth = preferredMonth.clamp(1, 12);
  if (availableMonths.contains(normalizedPreferredMonth)) {
    return DateTime(year, normalizedPreferredMonth);
  }

  final previousAvailableMonths = availableMonths
      .where((month) => month < normalizedPreferredMonth)
      .toList(growable: false);

  if (previousAvailableMonths.isNotEmpty) {
    return DateTime(year, previousAvailableMonths.last);
  }

  return DateTime(year, availableMonths.first);
}

int _monthSearchWindowWithoutMinDate(
  TransactionsPeriodPickerConstraints constraints,
) {
  return constraints.blockedDates.length ~/ 28 + 2;
}

int _yearSearchWindowWithoutMinDate(
  TransactionsPeriodPickerConstraints constraints,
) {
  return constraints.blockedDates.length ~/ 365 + 2;
}

DateTime? previousSelectableMonth(
  TransactionsPeriodPickerConstraints constraints,
  DateTime displayedDate,
) {
  final lowerBoundMonth = constraints.minDate == null
      ? null
      : DateTime(constraints.minDate!.year, constraints.minDate!.month);
  final maxIterations = lowerBoundMonth == null
      ? _monthSearchWindowWithoutMinDate(constraints)
      : 240;

  for (int offset = 1; offset <= maxIterations; offset += 1) {
    final candidate = DateUtils.addMonthsToMonthDate(displayedDate, -offset);
    if (lowerBoundMonth != null && candidate.isBefore(lowerBoundMonth)) {
      return null;
    }

    if (monthHasSelectableDate(constraints, candidate)) {
      return candidate;
    }
  }

  return null;
}

DateTime? nextSelectableMonth(
  TransactionsPeriodPickerConstraints constraints,
  DateTime displayedDate,
) {
  final upperBoundMonth = DateTime(
    constraints.effectiveMaxDate.year,
    constraints.effectiveMaxDate.month,
  );
  final maxDelta =
      (upperBoundMonth.year - displayedDate.year) * 12 +
      upperBoundMonth.month -
      displayedDate.month;

  for (int offset = 1; offset <= maxDelta; offset += 1) {
    final candidate = DateUtils.addMonthsToMonthDate(displayedDate, offset);
    if (monthHasSelectableDate(constraints, candidate)) {
      return candidate;
    }
  }

  return null;
}

DateTime? previousSelectableYear(
  TransactionsPeriodPickerConstraints constraints,
  int year,
) {
  final lowerYear = constraints.minDate?.year;
  final maxIterations = lowerYear == null
      ? _yearSearchWindowWithoutMinDate(constraints)
      : year - lowerYear;

  for (int offset = 1; offset <= maxIterations; offset += 1) {
    final candidateYear = year - offset;
    if (lowerYear != null && candidateYear < lowerYear) {
      return null;
    }

    if (yearHasSelectableDate(constraints, candidateYear)) {
      return DateTime(candidateYear, 1);
    }
  }

  return null;
}

DateTime? nextSelectableYear(
  TransactionsPeriodPickerConstraints constraints,
  int year,
) {
  final upperYear = constraints.effectiveMaxDate.year;
  final maxIterations = upperYear - year;

  for (int offset = 1; offset <= maxIterations; offset += 1) {
    final candidateYear = year + offset;
    if (yearHasSelectableDate(constraints, candidateYear)) {
      return DateTime(candidateYear, 1);
    }
  }

  return null;
}
