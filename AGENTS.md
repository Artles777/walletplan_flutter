# AGENTS.md

## 1. Роль агента

Ты работаешь как senior software engineer для этого репозитория.
Твоя задача: разбираться в реальной структуре проекта, вносить минимальные и
безопасные изменения и не придумывать отсутствующие слои архитектуры.

Отвечай на языке пользователя. Пиши кратко, технически точно и по делу.
Если контекста не хватает для безопасного изменения, сначала дочитай
связанные файлы.

---

## 2. Реальный контекст проекта

### Общая информация
- Репозиторий: `walletplan_flutter`
- Тип проекта: Flutter app
- Язык: Dart `^3.9.2`
- UI: Flutter Material 3
- Роутинг: `beamer`
- Локализация: `slang`, `slang_flutter`
- Состояние и локальная логика: `flutter_compositions`
- Формы: `flutter_form_builder`
- Форматирование: `intl`

### Что есть в коде сейчас
- Корневая точка входа: `lib/main.dart`
- Корневой роутер: `lib/router/root_delegate.dart`
- Вложенный роутер вкладок: `lib/router/base_delegate.dart`
- Главный shell: `lib/pages/main/main.page.dart`
- Основные экраны вкладок: `lib/pages/base/*.page.dart`
- Общие экраны: `lib/pages/common/*.page.dart`
- UI-компоненты: `lib/widgets/**`
- Локальная бизнес-логика и состояние: `lib/stores/**`
- Хелперы и расширения: `lib/utils/**`
- Локализация: `lib/i18n/*.i18n.json`
- Сгенерированные переводы: `lib/i18n/strings*.g.dart`

### Текущая архитектурная схема

`main.dart`
-> `MaterialApp.router`
-> `rootDelegate`
-> `MainPage`
-> вложенный `Beamer(delegate: baseDelegate)`
-> tab page
-> widgets
-> composable hooks из `lib/stores/**`

### Важные факты по текущей реализации
- Проект не использует `go_router`, `provider` или `mobx`.
- Навигация построена на двух `BeamerDelegate`:
  корневой `rootDelegate` и вложенный `baseDelegate`.
- Текущий state-слой это не store-классы, а composable-функции с `Ref<T>`:
  например `useTransactions()` и `useAddIncomeOrExpenseFab()`.
- Текущий список транзакций и формы пока частично заглушки:
  `useTransactions()` возвращает локальные данные,
  `SignInPage`, `AddIncomeFormWidget`, `AddExpenseFormWidget`
  пока содержат `Placeholder`.
- Локализация берётся через `t.*` из `slang`, а не через `gen-l10n`.

---

## 3. Источники истины

При любой задаче сначала проверяй реальные файлы:

### Конфигурация
- `pubspec.yaml`
- `analysis_options.yaml`

### Приложение и роутинг
- `lib/main.dart`
- `lib/router/root_delegate.dart`
- `lib/router/base_delegate.dart`
- `lib/utils/beamer_context_ext.dart`

### Экраны и shell
- `lib/pages/main/main.page.dart`
- `lib/pages/base/*.page.dart`
- `lib/pages/common/*.page.dart`
- `lib/widgets/main/*.widget.dart`

### Локальная логика и данные
- `lib/stores/transactions/use_transactions.dart`
- `lib/stores/transactions/use_income_expense_fab.dart`
- `lib/utils/currency_formatter.dart`

### Локализация
- `lib/i18n/en.i18n.json`
- `lib/i18n/ru.i18n.json`
- `lib/i18n/strings.g.dart`
- `lib/i18n/strings_en.g.dart`
- `lib/i18n/strings_ru.g.dart`

### Android-платформа
- `android/app/build.gradle.kts`
- `android/app/src/main/kotlin/**`
- `android/app/src/main/AndroidManifest.xml`

---

## 4. Золотые правила

- Делай минимальный diff.
- Сначала читай связанный роутинг, страницу и виджеты, потом меняй код.
- Не трогай несвязанные файлы без явного запроса.
- Не подменяй текущую архитектуру своей любимой:
  не добавляй `provider`, `bloc`, `riverpod`, `mobx` или новый роутер,
  если пользователь прямо этого не просил.
- Не ломай вложенную навигацию `rootDelegate` / `baseDelegate`.
- Не правь generated-файлы локализации вручную, если можно менять исходники.
- Учитывай правила из `analysis_options.yaml`:
  `package:` imports, двойные кавычки, trailing commas, `const`,
  ограничение длины строк и явные return types.

---

## 5. Правила по архитектуре

### 5.1 Роутинг
- Корневые маршруты описаны в `lib/router/root_delegate.dart`.
- Вкладки нижней навигации описаны в `lib/router/base_delegate.dart`.
- Если меняется состав вкладок, синхронно проверь:
  `BaseRoutesEnum`, `baseRoutes`, `basePaths`, `pathForIndex()`,
  `indexFromUri()` и `MainNavigationBarWidget`.
- Для переходов из виджетов предпочитай существующие обёртки из
  `lib/utils/beamer_context_ext.dart`, если переход привязан к `BuildContext`.
- Если меняется экран добавления дохода/расхода, проверь query-параметр `type`
  и логику `parseAddType()` / `setType()`.

### 5.2 Состояние и composable hooks
- Текущая логика хранится в функциях `use*`, а не в классических store-классах.
- Состояние UI, эффекты, анимации и локальные actions держи рядом с текущим
  модулем, если это продолжает существующий паттерн.
- Если логика разрастается, выноси её в новый `use_*.dart` рядом с модулем,
  а не перегружай виджет.
- Не дублируй данные и derived state по нескольким виджетам,
  если их можно выразить через один composable hook.

### 5.3 UI-компоненты
- Виджеты должны описывать layout и биндинг к состоянию.
- Тяжёлую логику, форматирование, расчёты и навигационные решения
  не держи внутри длинного `build()`, если это можно вынести.
- Повторяющиеся части страницы выноси в соседние `*.widget.dart` файлы.
- Сохраняй текущий нейминг файлов:
  `snake_case.widget.dart`, `snake_case.page.dart`, `use_*.dart`.

### 5.4 Локализация
- Пользовательские строки должны идти через `slang`.
- Меняй исходные файлы `lib/i18n/en.i18n.json` и `lib/i18n/ru.i18n.json`,
  а не `strings*.g.dart` вручную.
- Если добавлены новые ключи перевода, проверь, что сгенерированные файлы
  обновлены.

### 5.5 Форматирование и доменные хелперы
- Форматирование валют держи в `lib/utils/currency_formatter.dart`
  или в соседнем helper, если появляется новый изолированный форматтер.
- Общие расширения и роутинговые утилиты не размазывай по виджетам;
  предпочитай `lib/utils/**`.

---

## 6. Как анализировать задачу

### Если меняется маршрут или навигация
Проверь:
- `lib/router/root_delegate.dart`
- `lib/router/base_delegate.dart`
- `lib/pages/main/main.page.dart`
- `lib/widgets/main/main_navigation_bar.widget.dart`
- `lib/utils/beamer_context_ext.dart`

### Если меняется список транзакций
Проверь:
- `lib/pages/base/transactions.page.dart`
- `lib/widgets/transactions/transactions_list_view.widget.dart`
- `lib/stores/transactions/use_transactions.dart`

### Если меняется FAB доход/расход
Проверь:
- `lib/widgets/main/main_action_button.widget.dart`
- `lib/stores/transactions/use_income_expense_fab.dart`
- `lib/router/root_delegate.dart`
- `lib/pages/common/add_income_or_expense.page.dart`

### Если меняется экран добавления дохода/расхода
Проверь:
- `lib/pages/common/add_income_or_expense.page.dart`
- `lib/widgets/add_income_or_expense/*.widget.dart`
- связанные переводы в `lib/i18n/*.i18n.json`

### Если меняется локализация
Проверь:
- оба JSON-файла переводов
- все места вызова `t.*`
- необходимость регенерации `strings*.g.dart`

---

## 7. Чего делать не нужно

- Не описывай проект как большой enterprise-кодбейс, если код этого не
  подтверждает.
- Не ссылайся на несуществующие каталоги вроде `lib/screens/**`,
  `lib/store/**`, `lib/l10n/**` или на `go_router`.
- Не вводи абстракции заранее, если в коде пока нет такой сложности.
- Не переписывай placeholder-экраны в полноценные фичи без явного запроса.
- Не меняй Android-конфигурацию, если задача касается только Dart/Flutter-слоя.

---

## 8. Проверка после изменений

- Если менялись Dart-файлы, проверь, не нарушены ли правила линтера.
- Если менялись переводы, проверь, что generated-файлы локализации актуальны.
- Если менялся роутинг, проверь сценарии:
  запуск приложения,
  переход по вкладкам,
  открытие `/addIncomeOrExpense?type=expense`,
  открытие `/addIncomeOrExpense?type=income`,
  возврат назад.
- Если не запускал команды проверки, скажи об этом явно.
