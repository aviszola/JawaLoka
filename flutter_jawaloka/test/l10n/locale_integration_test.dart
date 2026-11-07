import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/core/l10n/app_locales.dart';
import 'package:flutter_jawaloka/core/l10n/jv_localizations_delegate.dart';
import 'package:flutter_jawaloka/core/l10n/locale_controller.dart';
import 'package:flutter_jawaloka/core/l10n/locale_preferences.dart';
import 'package:flutter_jawaloka/core/l10n/locale_scope.dart';
import 'package:flutter_jawaloka/core/theme/app_theme.dart';
import 'package:flutter_jawaloka/features/auth/presentation/screens/language_selection_screen.dart';
import 'package:flutter_jawaloka/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_jawaloka/features/auth/presentation/screens/register_screen.dart';
import 'package:flutter_jawaloka/features/auth/presentation/widgets/primary_button.dart';
import 'package:flutter_jawaloka/features/home/presentation/screens/main_shell_screen.dart';
import 'package:flutter_jawaloka/features/learn/presentation/screens/aksara_detail_screen.dart';
import 'package:flutter_jawaloka/features/learn/presentation/screens/vocabulary_detail_screen.dart';
import 'package:flutter_jawaloka/features/profile/presentation/screens/choose_blangkon_screen.dart';
import 'package:flutter_jawaloka/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter_jawaloka/features/profile/presentation/screens/settings_screen.dart';
import 'package:flutter_jawaloka/features/splash/presentation/screens/splash_screen.dart';
import 'package:flutter_jawaloka/features/translator/presentation/screens/translator_screen.dart';
import 'package:flutter_jawaloka/l10n/app_localizations.dart';

void main() {
  Widget buildTestableApp({
    required LocaleController controller,
    required Widget child,
    TextScaler textScaler = TextScaler.noScaling,
  }) {
    return LocaleScope(
      controller: controller,
      child: Builder(
        builder: (context) {
          final activeLocale = LocaleScope.of(context).locale;
          return MediaQuery(
            data: MediaQueryData(
              size: const Size(360, 800),
              textScaler: textScaler,
            ),
            child: MaterialApp(
              theme: AppTheme.lightTheme,
              locale: activeLocale,
              supportedLocales: AppLocales.supportedLocales,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                JvMaterialLocalizationsDelegate(),
                JvCupertinoLocalizationsDelegate(),
                ...AppLocalizationDelegates.delegates,
              ],
              routes: {
                '/register': (ctx) => const Scaffold(body: Text('Register Screen Target')),
                '/login': (ctx) => const Scaffold(body: Text('Login Screen Target')),
                '/home': (ctx) => const Scaffold(body: Text('Home Screen Target')),
                '/settings': (ctx) => const SettingsScreen(),
                '/choose-blangkon': (ctx) => const ChooseBlangkonScreen(),
                '/drawing-canvas': (ctx) => const Scaffold(body: Text('Canvas Screen Target')),
                '/quiz-question': (ctx) => const Scaffold(body: Text('Quiz Question Target')),
                '/vocabulary-detail': (ctx) => const Scaffold(body: Text('Vocab Detail Target')),
              },
              home: child,
            ),
          );
        },
      ),
    );
  }

  group('Fase 2 - LanguageSelectionScreen Widget Integration Tests', () {
    testWidgets('Tapping English updates screen title to English instantly', (tester) async {
      final storage = InMemoryLocalePreferences();
      final controller = LocaleController(preferences: storage);
      await controller.loadSavedLocale();

      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          child: const LanguageSelectionScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Initial Indonesian state
      expect(find.text('Pilih Bahasa Pengantar'), findsOneWidget);

      // Tap English card
      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();

      // Screen updates immediately to English
      expect(find.text('Choose App Language'), findsOneWidget);
      expect(find.text('Pilih Bahasa Pengantar'), findsNothing);
      expect(find.text('Continue'), findsOneWidget);
      expect(controller.locale, const Locale('en'));
    });

    testWidgets('Tapping Basa Jawa updates screen title to Javanese instantly', (tester) async {
      final storage = InMemoryLocalePreferences();
      final controller = LocaleController(preferences: storage);
      await controller.loadSavedLocale();

      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          child: const LanguageSelectionScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Basa Jawa card
      await tester.tap(find.text('Basa Jawa'));
      await tester.pumpAndSettle();

      // Screen updates immediately to Javanese draft
      expect(find.text('Pilih Basa Pitedah'), findsOneWidget);
      expect(find.text('Lajeng'), findsOneWidget);
      expect(controller.locale, const Locale('jv'));
    });

    testWidgets('Reopening application restores the last chosen language from storage', (tester) async {
      final storage = InMemoryLocalePreferences();
      final firstController = LocaleController(preferences: storage);
      await firstController.loadSavedLocale();

      // User selects Javanese
      await firstController.setLocale(const Locale('jv'));
      await firstController.markLanguageChosen();

      // Simulate app reopen with a fresh controller connected to identical storage
      final secondController = LocaleController(preferences: storage);
      expect(secondController.isInitialized, isFalse);

      await secondController.loadSavedLocale();
      expect(secondController.isInitialized, isTrue);
      expect(secondController.locale, const Locale('jv'));
      expect(secondController.hasChosenLanguage, isTrue);
    });

    testWidgets('Tapping Lanjut marks language as chosen and navigates', (tester) async {
      final storage = InMemoryLocalePreferences();
      final controller = LocaleController(preferences: storage);
      await controller.loadSavedLocale();

      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          child: const LanguageSelectionScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(controller.hasChosenLanguage, isFalse);

      await tester.tap(find.widgetWithText(PrimaryButton, 'Lanjut'));
      await tester.pumpAndSettle();

      expect(controller.hasChosenLanguage, isTrue);
      expect(find.text('Register Screen Target'), findsOneWidget);
    });
  });

  group('Fase 2 - SettingsScreen Widget Integration Tests', () {
    testWidgets('Settings language tile displays active endonym and switches locale via dialog', (tester) async {
      final storage = InMemoryLocalePreferences();
      final controller = LocaleController(preferences: storage);
      await controller.loadSavedLocale();

      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          child: const SettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Subtitle displays active endonym "Bahasa Indonesia"
      expect(find.text('Bahasa'), findsOneWidget);
      expect(find.text('Bahasa Indonesia'), findsWidgets);

      // Tap language tile to open dialog
      await tester.tap(find.text('Bahasa'));
      await tester.pumpAndSettle();

      expect(find.text('Pilih Bahasa'), findsOneWidget);

      // Select English from dialog
      await tester.tap(find.widgetWithText(SimpleDialogOption, 'English'));
      await tester.pumpAndSettle();

      // Settings screen row title now comes from English ARB: "Language"
      expect(find.text('Language'), findsOneWidget);
      // Row trailing endonym now shows "English"
      expect(find.text('English'), findsOneWidget);
      expect(controller.locale, const Locale('en'));

      // Tap language row again to switch to Basa Jawa
      await tester.tap(find.text('Language'));
      await tester.pumpAndSettle();

      // Dialog title in English is "Select Language"
      expect(find.text('Select Language'), findsOneWidget);

      await tester.tap(find.widgetWithText(SimpleDialogOption, 'Basa Jawa'));
      await tester.pumpAndSettle();

      // Settings row title now comes from Javanese ARB: "Basa"
      expect(find.text('Basa'), findsOneWidget);
      expect(find.text('Basa Jawa'), findsOneWidget);
      expect(controller.locale, const Locale('jv'));
    });
  });

  group('Fase 2 - Layout & Overflow Resilience Tests (textScaler 1.3 @ 360 dp)', () {
    const testLocales = [Locale('id'), Locale('jv'), Locale('en')];

    for (final locale in testLocales) {
      testWidgets('LanguageSelectionScreen has no overflow with textScaler 1.3 on ${locale.languageCode}',
          (tester) async {
        final storage = InMemoryLocalePreferences(initialLocale: locale.languageCode);
        final controller = LocaleController(preferences: storage);
        await controller.loadSavedLocale();

        await tester.pumpWidget(
          buildTestableApp(
            controller: controller,
            textScaler: const TextScaler.linear(1.3),
            child: const LanguageSelectionScreen(),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      });

      testWidgets('SettingsScreen has no overflow with textScaler 1.3 on ${locale.languageCode}',
          (tester) async {
        final storage = InMemoryLocalePreferences(initialLocale: locale.languageCode);
        final controller = LocaleController(preferences: storage);
        await controller.loadSavedLocale();

        await tester.pumpWidget(
          buildTestableApp(
            controller: controller,
            textScaler: const TextScaler.linear(1.3),
            child: const SettingsScreen(),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      });
    }
  });

  group('Fase 4 - Gelombang 1: Multi-language Screen Content (id, jv, en)', () {
    testWidgets('SplashScreen renders localized tagline in all three languages', (tester) async {
      for (final (locale, expectedTagline) in [
        (const Locale('id'), 'Belajar bahasa dan aksara Jawa setiap hari'),
        (const Locale('jv'), 'Sinau basa lan aksara Jawa saben dina'),
        (const Locale('en'), 'Learn Javanese language and script every day'),
      ]) {
        final storage = InMemoryLocalePreferences(initialLocale: locale.languageCode);
        final controller = LocaleController(preferences: storage);
        await controller.loadSavedLocale();

        await tester.pumpWidget(
          buildTestableApp(
            controller: controller,
            child: const SplashScreen(autoNavigate: false),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 900));

        expect(find.text('JawaLoka'), findsOneWidget);
        expect(find.text(expectedTagline), findsOneWidget);
      }
    });

    testWidgets('LoginScreen renders localized texts in all three languages', (tester) async {
      for (final (locale, title, forgotPass) in [
        (const Locale('id'), 'Masuk ke akunmu', 'Lupa kata sandi?'),
        (const Locale('jv'), 'Mlebu menyang akunmu', 'Lali tembung sandi?'),
        (const Locale('en'), 'Sign in to your account', 'Forgot password?'),
      ]) {
        final storage = InMemoryLocalePreferences(initialLocale: locale.languageCode);
        final controller = LocaleController(preferences: storage);
        await controller.loadSavedLocale();

        await tester.pumpWidget(
          buildTestableApp(
            controller: controller,
            child: const LoginScreen(),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text(title), findsOneWidget);
        expect(find.text(forgotPass), findsOneWidget);
      }
    });

    testWidgets('RegisterScreen renders localized texts in all three languages', (tester) async {
      for (final (locale, title, nameLabel, btnLabel) in [
        (const Locale('id'), 'Buat akunmu', 'Nama Lengkap', 'Daftar'),
        (const Locale('jv'), 'Gawe akunmu', 'Jeneng Jangkep', 'Ndhaptar'),
        (const Locale('en'), 'Create your account', 'Full Name', 'Sign Up'),
      ]) {
        final storage = InMemoryLocalePreferences(initialLocale: locale.languageCode);
        final controller = LocaleController(preferences: storage);
        await controller.loadSavedLocale();

        await tester.pumpWidget(
          buildTestableApp(
            controller: controller,
            child: const RegisterScreen(),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text(title), findsOneWidget);
        expect(find.text(nameLabel), findsOneWidget);
        expect(find.widgetWithText(PrimaryButton, btnLabel), findsOneWidget);
      }
    });
  });

  group('Fase 4 - Gelombang 1: Validation Message Localization', () {
    testWidgets('LoginScreen validation messages update dynamically on locale change', (tester) async {
      final storage = InMemoryLocalePreferences(initialLocale: 'id');
      final controller = LocaleController(preferences: storage);
      await controller.loadSavedLocale();

      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          child: const LoginScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Submit empty form in Indonesian
      await tester.tap(find.byType(PrimaryButton));
      await tester.pumpAndSettle();

      expect(find.text('Kata sandi tidak boleh kosong'), findsOneWidget);
      expect(find.text('Format email belum benar'), findsOneWidget);

      // Switch to English and submit again
      await controller.setLocale(const Locale('en'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(PrimaryButton));
      await tester.pumpAndSettle();

      expect(find.text('Password cannot be empty'), findsOneWidget);
      expect(find.text('Invalid email format'), findsOneWidget);

      // Switch to Javanese and submit again
      await controller.setLocale(const Locale('jv'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(PrimaryButton));
      await tester.pumpAndSettle();

      expect(find.text('Tembung sandi ora kena kothong'), findsOneWidget);
      expect(find.text('Format email durung bener'), findsOneWidget);
    });

    testWidgets('RegisterScreen validation messages update dynamically on locale change', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final storage = InMemoryLocalePreferences(initialLocale: 'id');
      final controller = LocaleController(preferences: storage);
      await controller.loadSavedLocale();

      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          child: const RegisterScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Submit empty form in Indonesian
      await tester.ensureVisible(find.byType(PrimaryButton));
      await tester.tap(find.byType(PrimaryButton));
      await tester.pumpAndSettle();

      expect(find.text('Nama tidak boleh kosong'), findsOneWidget);
      expect(find.text('Format email belum benar'), findsOneWidget);
      expect(find.text('Kata sandi minimal 8 karakter'), findsOneWidget);

      // Switch to English and submit again
      await controller.setLocale(const Locale('en'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byType(PrimaryButton));
      await tester.tap(find.byType(PrimaryButton));
      await tester.pumpAndSettle();

      expect(find.text('Name is required'), findsOneWidget);
      expect(find.text('Invalid email format'), findsOneWidget);
      expect(find.text('Password must be at least 8 characters'), findsOneWidget);

      // Switch to Javanese and submit again
      await controller.setLocale(const Locale('jv'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byType(PrimaryButton));
      await tester.tap(find.byType(PrimaryButton));
      await tester.pumpAndSettle();

      expect(find.text('Jeneng ora kena kothong'), findsOneWidget);
      expect(find.text('Format email durung bener'), findsOneWidget);
      expect(find.text('Tembung sandi paling sethithik 8 aksara'), findsOneWidget);
    });
  });

  group('Fase 4 - Gelombang 1: Layout & Overflow Resilience (textScaler 1.0 & 1.3 @ 360 dp)', () {
    const testLocales = [Locale('id'), Locale('jv'), Locale('en')];
    const scalers = [TextScaler.noScaling, TextScaler.linear(1.3)];

    for (final locale in testLocales) {
      for (final scaler in scalers) {
        final scaleLabel = scaler == TextScaler.noScaling ? '1.0' : '1.3';

        testWidgets(
          'SplashScreen renders cleanly without exception (scale: $scaleLabel, locale: ${locale.languageCode})',
          (tester) async {
            final storage = InMemoryLocalePreferences(initialLocale: locale.languageCode);
            final controller = LocaleController(preferences: storage);
            await controller.loadSavedLocale();

            await tester.pumpWidget(
              buildTestableApp(
                controller: controller,
                textScaler: scaler,
                child: const SplashScreen(autoNavigate: false),
              ),
            );
            await tester.pump();
            await tester.pump(const Duration(milliseconds: 900));

            expect(tester.takeException(), isNull);
          },
        );

        testWidgets(
          'LoginScreen renders cleanly without exception (scale: $scaleLabel, locale: ${locale.languageCode})',
          (tester) async {
            final storage = InMemoryLocalePreferences(initialLocale: locale.languageCode);
            final controller = LocaleController(preferences: storage);
            await controller.loadSavedLocale();

            await tester.pumpWidget(
              buildTestableApp(
                controller: controller,
                textScaler: scaler,
                child: const LoginScreen(),
              ),
            );
            await tester.pumpAndSettle();

            expect(tester.takeException(), isNull);
          },
        );

        testWidgets(
          'RegisterScreen renders cleanly without exception (scale: $scaleLabel, locale: ${locale.languageCode})',
          (tester) async {
            final storage = InMemoryLocalePreferences(initialLocale: locale.languageCode);
            final controller = LocaleController(preferences: storage);
            await controller.loadSavedLocale();

            await tester.pumpWidget(
              buildTestableApp(
                controller: controller,
                textScaler: scaler,
                child: const RegisterScreen(),
              ),
            );
            await tester.pumpAndSettle();

            expect(tester.takeException(), isNull);
          },
        );
      }
    }
  });

  group('Full App Javanese Locking QA Tests', () {
    testWidgets('Locking Basa Jawa transforms MainShellScreen & Bottom Nav to Javanese', (tester) async {
      final storage = InMemoryLocalePreferences(initialLocale: 'jv', initialHasChosen: true);
      final controller = LocaleController(preferences: storage);
      await controller.loadSavedLocale();

      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          child: const MainShellScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Bottom nav labels in Javanese
      expect(find.text('Beranda'), findsOneWidget);
      expect(find.text('Sinau'), findsOneWidget);
      expect(find.text('Quest'), findsOneWidget);
      expect(find.text('Kuis'), findsOneWidget);
      expect(find.text('Profil'), findsOneWidget);

      // Home Header in Javanese
      expect(find.text('Sugeng rawuh, Dimas!'), findsOneWidget);
      expect(find.text('5 dina'), findsOneWidget);
    });

    testWidgets('Locking Basa Jawa renders ProfileScreen in Javanese', (tester) async {
      final storage = InMemoryLocalePreferences(initialLocale: 'jv', initialHasChosen: true);
      final controller = LocaleController(preferences: storage);
      await controller.loadSavedLocale();

      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          child: const ProfileScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Profil'), findsOneWidget);
      expect(find.text('Koleksi Prestasi'), findsOneWidget);
      expect(find.text('Pilih Blangkon'), findsOneWidget);
      expect(find.text('Binuka'), findsOneWidget);
    });

    testWidgets('Locking Basa Jawa renders TranslatorScreen in Javanese', (tester) async {
      final storage = InMemoryLocalePreferences(initialLocale: 'jv', initialHasChosen: true);
      final controller = LocaleController(preferences: storage);
      await controller.loadSavedLocale();

      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          child: const TranslatorScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Penerjemah'), findsOneWidget);
      expect(find.text('LEBETAKEN TEKS'), findsOneWidget);
      expect(find.text('Jarwakake'), findsOneWidget);
      expect(find.text('ASILING JARWAN'), findsOneWidget);
    });

    testWidgets('Locking Basa Jawa renders AksaraDetailScreen in Javanese', (tester) async {
      final storage = InMemoryLocalePreferences(initialLocale: 'jv', initialHasChosen: true);
      final controller = LocaleController(preferences: storage);
      await controller.loadSavedLocale();

      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          child: const AksaraDetailScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Tuladha Tembung'), findsOneWidget);
      expect(find.text('Carane Nulis'), findsOneWidget);
      expect(find.text('Gladhen Nulis'), findsOneWidget);
      expect(find.text('Miwiti Kuis'), findsOneWidget);
    });

    testWidgets('Locking Basa Jawa renders VocabularyDetailScreen in Javanese', (tester) async {
      final storage = InMemoryLocalePreferences(initialLocale: 'jv', initialHasChosen: true);
      final controller = LocaleController(preferences: storage);
      await controller.loadSavedLocale();

      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          child: const VocabularyDetailScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Kosa Tembung'), findsOneWidget);
      expect(find.text('Teges & Tataran'), findsOneWidget);
      expect(find.text('Tuladha Ukara'), findsOneWidget);
      expect(find.text('Tembung Sabanjure'), findsOneWidget);
    });

    testWidgets('Locking Basa Jawa renders SettingsScreen dialogs in Javanese', (tester) async {
      final storage = InMemoryLocalePreferences(initialLocale: 'jv', initialHasChosen: true);
      final controller = LocaleController(preferences: storage);
      await controller.loadSavedLocale();

      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          child: const SettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Kawicaksanan Privasi'), findsOneWidget);
      expect(find.text('Miyos'), findsOneWidget);

      // Tap logout to see Javanese confirmation dialog
      await tester.tap(find.text('Miyos'));
      await tester.pumpAndSettle();

      expect(find.text('Saestu badhe miyos?'), findsOneWidget);
    });
  });
}

