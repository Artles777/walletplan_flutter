import "package:beamer/beamer.dart";
import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:syncfusion_localizations/syncfusion_localizations.dart";
import "package:walletplan_flutter/i18n/strings.g.dart";
import "package:walletplan_flutter/router/root_delegate.dart";
import "package:walletplan_flutter/theme/app_theme.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();
  runApp(TranslationProvider(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: BeamerParser(),
      routerDelegate: rootDelegate,
      backButtonDispatcher: BeamerBackButtonDispatcher(delegate: rootDelegate),
      theme: buildAppTheme(),
      localizationsDelegates: [
        ...GlobalMaterialLocalizations.delegates,
        GlobalMaterialLocalizations.delegate,
        SfGlobalLocalizations.delegate,
      ],
      supportedLocales: AppLocaleUtils.supportedLocales,
      locale: TranslationProvider.of(context).flutterLocale,
    );
  }
}
