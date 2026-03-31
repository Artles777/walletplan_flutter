///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final TranslationsCommonEn common = TranslationsCommonEn._(_root);
	late final TranslationsMainEn main = TranslationsMainEn._(_root);
	late final TranslationsTransactionsPageEn transactionsPage = TranslationsTransactionsPageEn._(_root);
	late final TranslationsTransactionsFiltersPageEn transactionsFiltersPage = TranslationsTransactionsFiltersPageEn._(_root);
}

// Path: common
class TranslationsCommonEn {
	TranslationsCommonEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Income'
	String get income => 'Income';

	/// en: 'Expense'
	String get expense => 'Expense';

	/// en: 'Apply'
	String get apply => 'Apply';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Reset'
	String get reset => 'Reset';
}

// Path: main
class TranslationsMainEn {
	TranslationsMainEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsMainNavigationBarEn navigationBar = TranslationsMainNavigationBarEn._(_root);
}

// Path: transactionsPage
class TranslationsTransactionsPageEn {
	TranslationsTransactionsPageEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Today'
	String get today => 'Today';

	/// en: 'Yesterday'
	String get yesterday => 'Yesterday';

	/// en: 'No transactions yet'
	String get empty => 'No transactions yet';

	/// en: 'Failed to load transactions'
	String get loadError => 'Failed to load transactions';

	/// en: '$count accounts'
	String accountsSelected({required Object count}) => '${count} accounts';

	/// en: '$count categories'
	String categoriesSelected({required Object count}) => '${count} categories';

	/// en: 'No transfers'
	String get withoutTransfers => 'No transfers';

	/// en: 'Expense categories'
	String get expenseCategories => 'Expense categories';

	/// en: 'Income categories'
	String get incomeCategories => 'Income categories';

	/// en: 'operations'
	String get operationsLabel => 'operations';

	/// en: '$count operations'
	String operationsCount({required Object count}) => '${count} operations';
}

// Path: transactionsFiltersPage
class TranslationsTransactionsFiltersPageEn {
	TranslationsTransactionsFiltersPageEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Filters'
	String get title => 'Filters';

	/// en: 'Transaction type'
	String get typeSectionTitle => 'Transaction type';

	/// en: 'Period'
	String get periodSectionTitle => 'Period';

	/// en: 'Accounts'
	String get accountsSectionTitle => 'Accounts';

	/// en: 'Categories'
	String get categoriesSectionTitle => 'Categories';

	/// en: 'View mode'
	String get presentationSectionTitle => 'View mode';

	/// en: 'Advanced'
	String get advancedSectionTitle => 'Advanced';

	/// en: 'All'
	String get allTypes => 'All';

	/// en: 'Expenses'
	String get expensesOnly => 'Expenses';

	/// en: 'Income'
	String get incomeOnly => 'Income';

	/// en: 'Select period'
	String get selectPeriod => 'Select period';

	/// en: 'All accounts'
	String get allAccounts => 'All accounts';

	/// en: 'All categories'
	String get allCategories => 'All categories';

	/// en: 'By days'
	String get byDays => 'By days';

	/// en: 'By categories'
	String get byCategories => 'By categories';

	/// en: 'Include transfers'
	String get includeTransfers => 'Include transfers';

	/// en: 'Options will appear after transactions load'
	String get noOptions => 'Options will appear after transactions load';
}

// Path: main.navigationBar
class TranslationsMainNavigationBarEn {
	TranslationsMainNavigationBarEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'transactions'
	String get transactions => 'transactions';

	/// en: 'accounts'
	String get accounts => 'accounts';

	/// en: 'plans'
	String get plans => 'plans';

	/// en: 'analytic'
	String get analytic => 'analytic';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'common.income' => 'Income',
			'common.expense' => 'Expense',
			'common.apply' => 'Apply',
			'common.cancel' => 'Cancel',
			'common.reset' => 'Reset',
			'main.navigationBar.transactions' => 'transactions',
			'main.navigationBar.accounts' => 'accounts',
			'main.navigationBar.plans' => 'plans',
			'main.navigationBar.analytic' => 'analytic',
			'transactionsPage.today' => 'Today',
			'transactionsPage.yesterday' => 'Yesterday',
			'transactionsPage.empty' => 'No transactions yet',
			'transactionsPage.loadError' => 'Failed to load transactions',
			'transactionsPage.accountsSelected' => ({required Object count}) => '${count} accounts',
			'transactionsPage.categoriesSelected' => ({required Object count}) => '${count} categories',
			'transactionsPage.withoutTransfers' => 'No transfers',
			'transactionsPage.expenseCategories' => 'Expense categories',
			'transactionsPage.incomeCategories' => 'Income categories',
			'transactionsPage.operationsLabel' => 'operations',
			'transactionsPage.operationsCount' => ({required Object count}) => '${count} operations',
			'transactionsFiltersPage.title' => 'Filters',
			'transactionsFiltersPage.typeSectionTitle' => 'Transaction type',
			'transactionsFiltersPage.periodSectionTitle' => 'Period',
			'transactionsFiltersPage.accountsSectionTitle' => 'Accounts',
			'transactionsFiltersPage.categoriesSectionTitle' => 'Categories',
			'transactionsFiltersPage.presentationSectionTitle' => 'View mode',
			'transactionsFiltersPage.advancedSectionTitle' => 'Advanced',
			'transactionsFiltersPage.allTypes' => 'All',
			'transactionsFiltersPage.expensesOnly' => 'Expenses',
			'transactionsFiltersPage.incomeOnly' => 'Income',
			'transactionsFiltersPage.selectPeriod' => 'Select period',
			'transactionsFiltersPage.allAccounts' => 'All accounts',
			'transactionsFiltersPage.allCategories' => 'All categories',
			'transactionsFiltersPage.byDays' => 'By days',
			'transactionsFiltersPage.byCategories' => 'By categories',
			'transactionsFiltersPage.includeTransfers' => 'Include transfers',
			'transactionsFiltersPage.noOptions' => 'Options will appear after transactions load',
			_ => null,
		};
	}
}
