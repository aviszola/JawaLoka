import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/l10n/app_locales.dart';
import 'core/l10n/locale_preferences.dart';
import 'core/l10n/locale_controller.dart';
import 'core/l10n/locale_scope.dart';
import 'core/l10n/jv_localizations_delegate.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final localePreferences = SharedPrefsLocalePreferences();
  final localeController = LocaleController(preferences: localePreferences);
  await localeController.loadSavedLocale();

  runApp(
    LocaleScope(
      controller: localeController,
      child: const JawaLokaApp(),
    ),
  );
}

/// Root widget for JawaLoka: Aplikasi Belajar Bahasa & Aksara Jawa.
class JawaLokaApp extends StatelessWidget {
  const JawaLokaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = LocaleScope.of(context);

    return MaterialApp(
      title: 'JawaLoka',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: controller.locale,
      supportedLocales: AppLocales.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        JvMaterialLocalizationsDelegate(),
        JvCupertinoLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: AppRouter.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
