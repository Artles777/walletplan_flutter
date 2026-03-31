import "package:beamer/beamer.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:flutter_test/flutter_test.dart";
import "package:syncfusion_localizations/syncfusion_localizations.dart";
import "package:walletplan_flutter/i18n/strings.g.dart";
import "package:walletplan_flutter/router/root_delegate.dart";
import "package:walletplan_flutter/theme/app_theme.dart";

const Size defaultGoldenSurfaceSize = Size(390, 844);
const ValueKey<String> goldenSurfaceKey = ValueKey("golden-surface");
bool _fontsLoaded = false;

ThemeData buildGoldenTheme() {
  return buildAppTheme();
}

Future<void> setGoldenSurfaceSize(
  WidgetTester tester, {
  Size size = defaultGoldenSurfaceSize,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;

  addTearDown(() {
    tester.view.resetDevicePixelRatio();
    tester.view.resetPhysicalSize();
  });
}

Future<void> ensureGoldenFontsLoaded() async {
  if (_fontsLoaded) {
    return;
  }

  final fontLoader = FontLoader("PT Sans")
    ..addFont(rootBundle.load("assets/fonts/PTSans.ttc"));

  await fontLoader.load();
  _fontsLoaded = true;
}

Widget _appShell({required Widget child}) {
  return TranslationProvider(
    child: MaterialApp(
      locale: const Locale("ru"),
      theme: buildGoldenTheme(),
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: [
        ...GlobalMaterialLocalizations.delegates,
        GlobalMaterialLocalizations.delegate,
        SfGlobalLocalizations.delegate,
      ],
      builder: (context, appChild) {
        return RepaintBoundary(key: goldenSurfaceKey, child: appChild ?? child);
      },
      home: child,
    ),
  );
}

Widget _routerAppShell() {
  return TranslationProvider(
    child: MaterialApp.router(
      routeInformationParser: BeamerParser(),
      routerDelegate: rootDelegate,
      backButtonDispatcher: BeamerBackButtonDispatcher(delegate: rootDelegate),
      theme: buildGoldenTheme(),
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: [
        ...GlobalMaterialLocalizations.delegates,
        GlobalMaterialLocalizations.delegate,
        SfGlobalLocalizations.delegate,
      ],
      builder: (context, child) {
        return RepaintBoundary(
          key: goldenSurfaceKey,
          child: child ?? const SizedBox.shrink(),
        );
      },
    ),
  );
}

Future<void> pumpGoldenApp(
  WidgetTester tester, {
  required Widget home,
  Size size = defaultGoldenSurfaceSize,
}) async {
  await ensureGoldenFontsLoaded();
  await setGoldenSurfaceSize(tester, size: size);
  await tester.pumpWidget(_appShell(child: home));
  await tester.pumpAndSettle();
}

Future<void> pumpGoldenRouterApp(
  WidgetTester tester, {
  Size size = defaultGoldenSurfaceSize,
}) async {
  await ensureGoldenFontsLoaded();
  await setGoldenSurfaceSize(tester, size: size);
  await tester.pumpWidget(_routerAppShell());
  await tester.pumpAndSettle();
}
