///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsRu with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsRu({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ru,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ru>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsRu _root = this; // ignore: unused_field

	@override 
	TranslationsRu $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsRu(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsCommonRu common = _TranslationsCommonRu._(_root);
	@override late final _TranslationsMainRu main = _TranslationsMainRu._(_root);
	@override late final _TranslationsTransactionsPageRu transactionsPage = _TranslationsTransactionsPageRu._(_root);
}

// Path: common
class _TranslationsCommonRu implements TranslationsCommonEn {
	_TranslationsCommonRu._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get income => 'Доход';
	@override String get expense => 'Расход';
}

// Path: main
class _TranslationsMainRu implements TranslationsMainEn {
	_TranslationsMainRu._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsMainNavigationBarRu navigationBar = _TranslationsMainNavigationBarRu._(_root);
}

// Path: transactionsPage
class _TranslationsTransactionsPageRu implements TranslationsTransactionsPageEn {
	_TranslationsTransactionsPageRu._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get today => 'Сегодня';
	@override String get yesterday => 'Вчера';
	@override String get empty => 'Пока нет транзакций';
	@override String get loadError => 'Не удалось загрузить транзакции';
}

// Path: main.navigationBar
class _TranslationsMainNavigationBarRu implements TranslationsMainNavigationBarEn {
	_TranslationsMainNavigationBarRu._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get transactions => 'Транзакции';
	@override String get accounts => 'Счета';
	@override String get plans => 'Планы';
	@override String get analytic => 'Аналитика';
}

/// The flat map containing all translations for locale <ru>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsRu {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'common.income' => 'Доход',
			'common.expense' => 'Расход',
			'main.navigationBar.transactions' => 'Транзакции',
			'main.navigationBar.accounts' => 'Счета',
			'main.navigationBar.plans' => 'Планы',
			'main.navigationBar.analytic' => 'Аналитика',
			'transactionsPage.today' => 'Сегодня',
			'transactionsPage.yesterday' => 'Вчера',
			'transactionsPage.empty' => 'Пока нет транзакций',
			'transactionsPage.loadError' => 'Не удалось загрузить транзакции',
			_ => null,
		};
	}
}
