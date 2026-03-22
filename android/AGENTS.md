# AGENTS.md

Этот файл действует только внутри каталога `android/`.
Основной гайд по проекту находится в корне репозитория: `../AGENTS.md`.

## Android-слой в этом репозитории

- `android/` здесь это стандартная Flutter-платформа, а не отдельное Android
  приложение со своей бизнес-логикой.
- Большинство продуктовых изменений делаются в `lib/**`, а не в `android/**`.
- Из Android-специфичных файлов обычно важны:
  `app/build.gradle.kts`,
  `build.gradle.kts`,
  `settings.gradle.kts`,
  `app/src/main/AndroidManifest.xml`,
  `app/src/main/kotlin/**`.

## Правила изменений внутри `android/`

- Не меняй Android-конфигурацию без прямой необходимости.
- Любое изменение в `applicationId`, SDK-версиях, Gradle-плагинах,
  manifest entries или `MainActivity.kt` считай потенциально рискованным.
- Если Android-изменение связано с Flutter-фичей, сначала дочитай
  соответствующие файлы в `lib/**`.
- Не описывай этот проект как нативный Android-кодбейс:
  source of truth для продуктовой логики находится в Dart-слое.
