import "package:beamer/beamer.dart";
import "package:flutter/material.dart";
import "package:flutter_compositions/flutter_compositions.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:syncfusion_localizations/syncfusion_localizations.dart";
import "package:walletplan_flutter/i18n/strings.g.dart";
import "package:walletplan_flutter/router/root_delegate.dart";
import "package:walletplan_flutter/stores/transactions/transactions_scope.widget.dart";
import "package:walletplan_flutter/theme/app_theme.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocaleSettings.useDeviceLocale();
  runApp(TranslationProvider(child: const MyApp()));
}

class MyApp extends CompositionWidget {
  const MyApp({super.key});

  @override
  Widget Function(BuildContext) setup() {
    return (context) {
      return TransactionsScopeWidget(
        child: MaterialApp.router(
          routeInformationParser: BeamerParser(),
          routerDelegate: rootDelegate,
          backButtonDispatcher: BeamerBackButtonDispatcher(
            delegate: rootDelegate,
          ),
          theme: buildAppTheme(),
          localizationsDelegates: [
            ...GlobalMaterialLocalizations.delegates,
            SfGlobalLocalizations.delegate,
          ],
          supportedLocales: AppLocaleUtils.supportedLocales,
          locale: TranslationProvider.of(context).flutterLocale,
        ),
      );
    };
  }
}
