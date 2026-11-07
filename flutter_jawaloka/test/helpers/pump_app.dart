import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/core/l10n/app_locales.dart';
import 'package:flutter_jawaloka/core/l10n/jv_localizations_delegate.dart';
import 'package:flutter_jawaloka/core/l10n/locale_controller.dart';
import 'package:flutter_jawaloka/core/l10n/locale_preferences.dart';
import 'package:flutter_jawaloka/core/l10n/locale_scope.dart';
import 'package:flutter_jawaloka/core/theme/app_theme.dart';
import 'package:flutter_jawaloka/l10n/app_localizations.dart';

/// Test helper providing standard [pumpApp] extension on [WidgetTester].
/// Wraps widgets with [LocaleScope] and [MaterialApp] with full localization support.
extension PumpAppTester on WidgetTester {
  Future<void> pumpApp(
    Widget child, {
    LocaleController? controller,
    Locale locale = AppLocales.defaultLocale,
    Map<String, WidgetBuilder>? routes,
    RouteFactory? onGenerateRoute,
    String? initialRoute,
    NavigatorObserver? navigatorObserver,
  }) async {
    final activeController = controller ??
        LocaleController(
          preferences: InMemoryLocalePreferences(initialLocale: locale.languageCode),
        );
    if (!activeController.isInitialized) {
      await activeController.loadSavedLocale();
    }

    await pumpWidget(
      LocaleScope(
        controller: activeController,
        child: Builder(
          builder: (context) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              locale: LocaleScope.of(context).locale,
              supportedLocales: AppLocales.supportedLocales,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                JvMaterialLocalizationsDelegate(),
                JvCupertinoLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              routes: routes ?? const <String, WidgetBuilder>{},
              onGenerateRoute: onGenerateRoute,
              initialRoute: initialRoute,
              navigatorObservers: navigatorObserver != null
                  ? [navigatorObserver]
                  : const <NavigatorObserver>[],
              home: initialRoute == null ? child : null,
            );
          },
        ),
      ),
    );
  }
}

