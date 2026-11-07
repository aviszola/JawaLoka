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
import 'package:flutter_jawaloka/features/learn/presentation/screens/learn_hub_screen.dart';
import 'package:flutter_jawaloka/features/learn/presentation/screens/aksara_detail_screen.dart';
import 'package:flutter_jawaloka/features/learn/presentation/screens/vocabulary_detail_screen.dart';
import 'package:flutter_jawaloka/features/profile/presentation/screens/choose_blangkon_screen.dart';
import 'package:flutter_jawaloka/features/profile/presentation/screens/level_up_screen.dart';
import 'package:flutter_jawaloka/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter_jawaloka/features/profile/presentation/screens/settings_screen.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/daily_result_screen.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/drawing_canvas_screen.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/quiz_path_screen.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/quiz_question_screen.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/quiz_result_screen.dart';
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
                '/daily-result': (ctx) => const DailyResultScreen(),
                '/level-up': (ctx) => const LevelUpScreen(),
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

  group('Fase 4 Gelombang 2 - Home & Quiz Localization Suite', () {
    testWidgets('MainShell & Home render English strings when locale is en', (tester) async {
      final storage = InMemoryLocalePreferences(initialLocale: 'en', initialHasChosen: true);
      final controller = LocaleController(preferences: storage);
      await controller.loadSavedLocale();

      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          child: const MainShellScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Navigation tabs in English
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Learn'), findsOneWidget);
      expect(find.text('Quest'), findsOneWidget);
      expect(find.text('Quiz'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);

      // Home Header & widgets in English
      expect(find.text('Hello, Dimas!'), findsOneWidget);
      expect(find.text("TODAY'S QUEST"), findsOneWidget);
      expect(find.text('Start Drawing'), findsOneWidget);
      expect(find.text('Continue Quiz'), findsOneWidget);
      expect(find.text('Quick Learn'), findsOneWidget);
    });

    testWidgets('MainShell & Home render Indonesian strings when locale is id', (tester) async {
      final storage = InMemoryLocalePreferences(initialLocale: 'id', initialHasChosen: true);
      final controller = LocaleController(preferences: storage);
      await controller.loadSavedLocale();

      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          child: const MainShellScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Beranda'), findsOneWidget);
      expect(find.text('Belajar'), findsOneWidget);
      expect(find.text('Quest'), findsOneWidget);
      expect(find.text('Kuis'), findsOneWidget);
      expect(find.text('Profil'), findsOneWidget);

      expect(find.text('Halo, Dimas!'), findsOneWidget);
      expect(find.text('MISI HARI INI'), findsOneWidget);
      expect(find.text('Mulai Menggambar'), findsOneWidget);
      expect(find.text('Lanjutkan Kuis'), findsOneWidget);
      expect(find.text('Belajar Cepat'), findsOneWidget);
    });

    testWidgets('QuizPathScreen renders English topics, milestone, units, locked toast & bottom sheet', (tester) async {
      final storage = InMemoryLocalePreferences(initialLocale: 'en', initialHasChosen: true);
      final controller = LocaleController(preferences: storage);
      await controller.loadSavedLocale();

      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          child: const QuizPathScreen(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Quiz Path'), findsOneWidget);
      expect(find.text('Unit 1: Greetings and Salutations'), findsOneWidget);
      expect(find.text('Greeting'), findsOneWidget);
      expect(find.text('Farewell'), findsOneWidget);
      expect(find.text('Badge'), findsOneWidget);
      expect(find.text('Milestone Node'), findsOneWidget);
      expect(find.text('Unit 2: Family and Home (Locked)'), findsOneWidget);

      // Tap active node -> opens QuizBottomSheet
      await tester.tap(find.text('Greeting'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Start Quiz'), findsOneWidget);
      expect(find.text('Maybe later'), findsOneWidget);

      // Close bottom sheet
      await tester.tap(find.text('Maybe later'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Scroll down and tap locked node 'Family'
      await tester.scrollUntilVisible(find.text('Family'), 100);
      await tester.tap(find.text('Family'));
      await tester.pump(); // SnackBar start
      expect(find.text('Family is still locked. Complete previous topics first!'), findsOneWidget);
    });

    testWidgets('QuizPathScreen renders Javanese topics, milestone, units, locked toast & bottom sheet', (tester) async {
      final storage = InMemoryLocalePreferences(initialLocale: 'jv', initialHasChosen: true);
      final controller = LocaleController(preferences: storage);
      await controller.loadSavedLocale();

      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          child: const QuizPathScreen(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Dalan Kuis'), findsOneWidget);
      expect(find.text('Unit 1: Aruh-aruh lan Salam'), findsOneWidget);
      expect(find.text('Salam'), findsOneWidget);
      expect(find.text('Pamit'), findsOneWidget);
      expect(find.text('Lencana'), findsOneWidget);
      expect(find.text('Node Tonggak'), findsOneWidget);
      expect(find.text('Unit 2: Kulawarga lan Omah (Kakonci)'), findsOneWidget);

      // Tap active node -> opens QuizBottomSheet
      await tester.tap(find.text('Salam'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Miwiti Kuis'), findsOneWidget);
      expect(find.text('Mangke rumiyin'), findsOneWidget);

      // Close bottom sheet
      await tester.tap(find.text('Mangke rumiyin'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Scroll down and tap locked node 'Kulawarga'
      await tester.scrollUntilVisible(find.text('Kulawarga'), 100);
      await tester.tap(find.text('Kulawarga'));
      await tester.pump(); // SnackBar start
      expect(find.text('Materi Kulawarga isih kakunci. Rampungna materi sadurunge!'), findsOneWidget);
    });

    testWidgets('QuizQuestionScreen renders prompts, skip, and exit dialog across locales', (tester) async {
      final storage = InMemoryLocalePreferences(initialLocale: 'en', initialHasChosen: true);
      final controller = LocaleController(preferences: storage);
      await controller.loadSavedLocale();

      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          child: const QuizQuestionScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // English prompt and skip
      expect(find.text('What character is this?'), findsOneWidget);
      expect(find.text('Skip'), findsOneWidget);

      // Tap close (X) button -> shows English exit dialog
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Exit Quiz?'), findsOneWidget);
      expect(find.text('Current quiz progress will not be saved.'), findsOneWidget);
      expect(find.text('Exit'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);

      // Dismiss dialog
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(find.text('Exit Quiz?'), findsNothing);

      // Switch to Javanese
      await controller.setLocale(const Locale('jv'));
      await tester.pumpAndSettle();

      expect(find.text('Aksara apa iki?'), findsOneWidget);
      expect(find.text('Liwati'), findsOneWidget);

      // Tap close -> Javanese exit dialog
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Metu saka Kuis?'), findsOneWidget);
      expect(find.text('Progres kuis iki ora bakal disimpen.'), findsOneWidget);
      expect(find.text('Metu'), findsOneWidget);
      expect(find.text('Banjurake'), findsOneWidget);
    });

    testWidgets('QuizResultScreen renders awesome title, stats, and buttons across locales', (tester) async {
      final storage = InMemoryLocalePreferences(initialLocale: 'en', initialHasChosen: true);
      final controller = LocaleController(preferences: storage);
      await controller.loadSavedLocale();

      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          child: const QuizResultScreen(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // English Result UI
      expect(find.text('Awesome!'), findsOneWidget);
      expect(find.text('Back to Home'), findsOneWidget);
      expect(find.text('Retry quiz'), findsOneWidget);
      expect(find.text('Correct Answers'), findsOneWidget);
      expect(find.text('Accuracy'), findsOneWidget);

      // Switch to Javanese
      await controller.setLocale(const Locale('jv'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Luar Biasa!'), findsOneWidget);
      expect(find.text('Wangsul dhateng Beranda'), findsOneWidget);
      expect(find.text('Baleni kuis'), findsOneWidget);
      expect(find.text('Pitakenan Leres'), findsOneWidget);
      expect(find.text('Katelitian'), findsOneWidget);

      // Switch to Indonesian
      await controller.setLocale(const Locale('id'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Luar Biasa!'), findsOneWidget);
      expect(find.text('Kembali ke Beranda'), findsOneWidget);
      expect(find.text('Ulangi kuis'), findsOneWidget);
      expect(find.text('Soal Benar'), findsOneWidget);
    });

    testWidgets('Dynamic locale switching updates MainShell and QuizPath instantly', (tester) async {
      final storage = InMemoryLocalePreferences(initialLocale: 'id', initialHasChosen: true);
      final controller = LocaleController(preferences: storage);
      await controller.loadSavedLocale();

      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          child: const MainShellScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Belajar'), findsOneWidget);
      expect(find.text('Sinau'), findsNothing);
      expect(find.text('Learn'), findsNothing);

      // Switch to Javanese
      await controller.setLocale(const Locale('jv'));
      await tester.pumpAndSettle();

      expect(find.text('Sinau'), findsOneWidget);
      expect(find.text('Belajar'), findsNothing);
      expect(find.text('Learn'), findsNothing);

      // Switch to English
      await controller.setLocale(const Locale('en'));
      await tester.pumpAndSettle();

      expect(find.text('Learn'), findsOneWidget);
      expect(find.text('Sinau'), findsNothing);
      expect(find.text('Belajar'), findsNothing);
    });

    testWidgets('Text scaling resilience (scale 1.3 at 360dp width) throws no exceptions or overflows', (tester) async {
      final storage = InMemoryLocalePreferences(initialLocale: 'jv', initialHasChosen: true);
      final controller = LocaleController(preferences: storage);
      await controller.loadSavedLocale();

      // Test Home / MainShell
      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          textScaler: const TextScaler.linear(1.3),
          child: const MainShellScreen(),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // Test QuizPath
      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          textScaler: const TextScaler.linear(1.3),
          child: const QuizPathScreen(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      // Test QuizQuestion
      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          textScaler: const TextScaler.linear(1.3),
          child: const QuizQuestionScreen(),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // Test QuizResult
      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          textScaler: const TextScaler.linear(1.3),
          child: const QuizResultScreen(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.takeException(), isNull);
    });
  });

  group('Fase 4 - Gelombang 3: Learn Hub, Vocabulary Detail, Aksara Detail Integration Tests', () {
    testWidgets('LearnHubScreen renders and switches localized strings dynamically across id, jv, en', (tester) async {
      final storage = InMemoryLocalePreferences(initialLocale: 'id', initialHasChosen: true);
      final controller = LocaleController(preferences: storage);
      await controller.loadSavedLocale();

      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          child: const LearnHubScreen(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));

      // ID assertions
      expect(find.text('Pusat Belajar'), findsOneWidget);
      expect(find.text('Eksplorasi warisan budaya dan bahasa Jawa'), findsOneWidget);
      expect(find.text('Modul Pembelajaran'), findsOneWidget);
      expect(find.text('Kosa Kata (Kamus)'), findsOneWidget);
      expect(find.text('Rumah'), findsOneWidget);

      // Switch to Javanese (jv)
      await controller.setLocale(const Locale('jv'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));

      expect(find.text('Papan Sinau'), findsOneWidget);
      expect(find.text('Njlajah warisan kabudayan lan basa Jawa'), findsOneWidget);
      expect(find.text('Modul Pasinaon'), findsOneWidget);
      expect(find.text('Kosa Tembung (Bausastra)'), findsOneWidget);
      expect(find.text('Griya'), findsOneWidget);

      // Switch to English (en)
      await controller.setLocale(const Locale('en'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));

      expect(find.text('Learning Hub'), findsOneWidget);
      expect(find.text('Explore Javanese cultural heritage and language'), findsOneWidget);
      expect(find.text('Learning Modules'), findsOneWidget);
      expect(find.text('Vocabulary (Dictionary)'), findsOneWidget);
      expect(find.text('House'), findsOneWidget);
    });

    testWidgets('LearnHubScreen bottom sheets display localized content', (tester) async {
      final storage = InMemoryLocalePreferences(initialLocale: 'id', initialHasChosen: true);
      final controller = LocaleController(preferences: storage);
      await controller.loadSavedLocale();

      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          child: const LearnHubScreen(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));

      // Tap on Penggunaan Bahasa module card subtitle to open bottom sheet
      await tester.ensureVisible(find.text('Unggah-ungguh & tata krama ragam wicara'));
      await tester.tap(find.text('Unggah-ungguh & tata krama ragam wicara'));
      await tester.pumpAndSettle();

      expect(find.text('Penggunaan Bahasa'), findsWidgets);
      expect(find.text('1. Basa Ngoko Lugu'), findsOneWidget);
      expect(find.text('Contoh: "Kowe arep mangan apa?"'), findsOneWidget);

      // Close bottom sheet
      Navigator.pop(tester.element(find.text('1. Basa Ngoko Lugu')));
      await tester.pumpAndSettle();

      // Open Peribahasa sheet
      await tester.ensureVisible(find.text('Paribasan, bebasan, lan saloka warisan Jawa'));
      await tester.tap(find.text('Paribasan, bebasan, lan saloka warisan Jawa'));
      await tester.pumpAndSettle();

      expect(find.text('Peribahasa & Saloka Jawa'), findsOneWidget);
      expect(find.text('Kehormatan seseorang terletak pada tutur katanya, dan kehormatan tubuh terletak pada pakaiannya.'), findsOneWidget);

      // Close bottom sheet
      Navigator.pop(tester.element(find.text('Peribahasa & Saloka Jawa')));
      await tester.pumpAndSettle();
    });

    testWidgets('VocabularyDetailScreen renders and switches localized strings dynamically across id, jv, en', (tester) async {
      final storage = InMemoryLocalePreferences(initialLocale: 'id', initialHasChosen: true);
      final controller = LocaleController(preferences: storage);
      await controller.loadSavedLocale();

      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          child: const VocabularyDetailScreen(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));

      // ID assertions
      expect(find.text('Kosa Kata'), findsWidgets);
      expect(find.text('Makna & Tingkatan'), findsOneWidget);
      expect(find.text('Bahasa Indonesia'), findsOneWidget);
      expect(find.text('Bahasa Inggris'), findsOneWidget);
      expect(find.text('Bahasa Jawa (Ngoko)'), findsOneWidget);
      expect(find.text('Contoh Kalimat'), findsOneWidget);
      expect(find.text('Rumahku ada di desa'), findsOneWidget);
      expect(find.text('Kata Berikutnya'), findsOneWidget);

      // Switch to Javanese (jv)
      await controller.setLocale(const Locale('jv'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));

      expect(find.text('Kosa Tembung'), findsWidgets);
      expect(find.text('Teges & Tataran'), findsOneWidget);
      expect(find.text('Basa Indonesia'), findsOneWidget);
      expect(find.text('Basa Inggris'), findsOneWidget);
      expect(find.text('Basa Jawa (Ngoko)'), findsOneWidget);
      expect(find.text('Tuladha Ukara'), findsOneWidget);
      expect(find.text('Griyaku wonten ing dhusun'), findsOneWidget);
      expect(find.text('Tembung Sabanjure'), findsOneWidget);

      // Switch to English (en)
      await controller.setLocale(const Locale('en'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));

      expect(find.text('Vocabulary'), findsWidgets);
      expect(find.text('Meaning & Levels'), findsOneWidget);
      expect(find.text('Indonesian'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Javanese (Ngoko)'), findsOneWidget);
      expect(find.text('Example Sentences'), findsOneWidget);
      expect(find.text('My house is in the village'), findsOneWidget);
      expect(find.text('Next Word'), findsOneWidget);
    });

    testWidgets('AksaraDetailScreen renders and switches localized strings dynamically across id, jv, en', (tester) async {
      final storage = InMemoryLocalePreferences(initialLocale: 'id', initialHasChosen: true);
      final controller = LocaleController(preferences: storage);
      await controller.loadSavedLocale();

      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          child: const AksaraDetailScreen(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 900));

      // ID assertions
      expect(find.text('Aksara Jawa'), findsOneWidget);
      expect(find.text('Contoh Kata'), findsOneWidget);
      expect(find.text('Cabang'), findsOneWidget);
      expect(find.text('Tungku'), findsOneWidget);
      expect(find.text('Delapan'), findsOneWidget);
      expect(find.text('Latihan Menulis'), findsOneWidget);
      expect(find.text('Mulai Kuis'), findsOneWidget);

      // Switch to Javanese (jv)
      await controller.setLocale(const Locale('jv'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 900));

      expect(find.text('Aksara Jawa'), findsOneWidget);
      expect(find.text('Tuladha Tembung'), findsOneWidget);
      expect(find.text('Pang'), findsOneWidget);
      expect(find.text('Pawon / Hawu'), findsOneWidget);
      expect(find.text('Wolu'), findsOneWidget);
      expect(find.text('Gladhen Nulis'), findsOneWidget);
      expect(find.text('Miwiti Kuis'), findsOneWidget);

      // Switch to English (en)
      await controller.setLocale(const Locale('en'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 900));

      expect(find.text('Javanese Script'), findsOneWidget);
      expect(find.text('Example Words'), findsOneWidget);
      expect(find.text('Branch'), findsOneWidget);
      expect(find.text('Stove'), findsOneWidget);
      expect(find.text('Eight'), findsOneWidget);
      expect(find.text('Writing Practice'), findsOneWidget);
      expect(find.text('Start Quiz'), findsOneWidget);
    });

    testWidgets('Gelombang 3 screens layout resilience (scale 1.3 at 360dp width) throws no exceptions or overflows', (tester) async {
      final storage = InMemoryLocalePreferences(initialLocale: 'jv', initialHasChosen: true);
      final controller = LocaleController(preferences: storage);
      await controller.loadSavedLocale();

      // Test LearnHubScreen at 1.3 scale
      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          textScaler: const TextScaler.linear(1.3),
          child: const LearnHubScreen(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));
      expect(tester.takeException(), isNull);

      // Test VocabularyDetailScreen at 1.3 scale
      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          textScaler: const TextScaler.linear(1.3),
          child: const VocabularyDetailScreen(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));
      expect(tester.takeException(), isNull);

      // Test AksaraDetailScreen at 1.3 scale
      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          textScaler: const TextScaler.linear(1.3),
          child: const AksaraDetailScreen(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 900));
      expect(tester.takeException(), isNull);
    });
  });

  group('Fase 4 - Gelombang 4 - Full Localization Integration Tests', () {
    testWidgets('TranslatorScreen renders and switches localized strings dynamically across id, jv, en', (tester) async {
      final storage = InMemoryLocalePreferences(initialLocale: 'id', initialHasChosen: true);
      final controller = LocaleController(preferences: storage);
      await controller.loadSavedLocale();

      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          child: const TranslatorScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // ID assertions
      expect(find.text('Penerjemah'), findsOneWidget);
      expect(find.text('MASUKKAN TEKS'), findsOneWidget);
      expect(find.text('Terjemahkan'), findsOneWidget);
      expect(find.text('HASIL TERJEMAHAN'), findsOneWidget);

      // Switch to Javanese (jv)
      await controller.setLocale(const Locale('jv'));
      await tester.pumpAndSettle();

      expect(find.text('Penerjemah'), findsOneWidget);
      expect(find.text('LEBETAKEN TEKS'), findsOneWidget);
      expect(find.text('Jarwakake'), findsOneWidget);
      expect(find.text('ASILING JARWAN'), findsOneWidget);

      // Switch to English (en)
      await controller.setLocale(const Locale('en'));
      await tester.pumpAndSettle();

      expect(find.text('Translator'), findsOneWidget);
      expect(find.text('ENTER TEXT'), findsOneWidget);
      expect(find.text('Translate'), findsOneWidget);
      expect(find.text('TRANSLATION RESULT'), findsOneWidget);
    });

    testWidgets('DrawingCanvasScreen renders and switches localized strings dynamically across id, jv, en', (tester) async {
      final storage = InMemoryLocalePreferences(initialLocale: 'id', initialHasChosen: true);
      final controller = LocaleController(preferences: storage);
      await controller.loadSavedLocale();

      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          child: const DrawingCanvasScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // ID assertions
      expect(find.text('Latihan Menulis'), findsOneWidget);
      expect(find.text('Tulis aksara ini!'), findsOneWidget);
      expect(find.text('Hapus Semua'), findsOneWidget);
      expect(find.text('Batalkan'), findsOneWidget);
      expect(find.text('Periksa Tulisan'), findsOneWidget);

      // Switch to Javanese (jv)
      await controller.setLocale(const Locale('jv'));
      await tester.pumpAndSettle();

      expect(find.text('Gladhen Nulis'), findsOneWidget);
      expect(find.text('Serat aksara punika!'), findsOneWidget);
      expect(find.text('Busek Kabeh'), findsOneWidget);
      expect(find.text('Wurung'), findsOneWidget);
      expect(find.text('Priksa Tulisan'), findsOneWidget);

      // Switch to English (en)
      await controller.setLocale(const Locale('en'));
      await tester.pumpAndSettle();

      expect(find.text('Writing Practice'), findsOneWidget);
      expect(find.text('Write this script!'), findsOneWidget);
      expect(find.text('Clear All'), findsOneWidget);
      expect(find.text('Undo'), findsOneWidget);
      expect(find.text('Check Writing'), findsOneWidget);
    });

    testWidgets('DailyResultScreen renders and switches localized strings dynamically across id, jv, en', (tester) async {
      final storage = InMemoryLocalePreferences(initialLocale: 'id', initialHasChosen: true);
      final controller = LocaleController(preferences: storage);
      await controller.loadSavedLocale();

      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          child: const DailyResultScreen(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1600));

      // ID assertions
      expect(find.text('Hasil Quest'), findsOneWidget);
      expect(find.text('Perbandingan Tulisan'), findsOneWidget);
      expect(find.text('Tulisanmu'), findsOneWidget);
      expect(find.text('Aksara Target'), findsOneWidget);
      expect(find.text('Lanjutkan Belajar →'), findsOneWidget);
      expect(find.text('Coba Lagi'), findsOneWidget);

      // Switch to Javanese (jv)
      await controller.setLocale(const Locale('jv'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1600));

      expect(find.text('Asil Quest'), findsOneWidget);
      expect(find.text('Pabandhingan Tulisan'), findsOneWidget);
      expect(find.text('Seratan panjenengan'), findsOneWidget);
      expect(find.text('Aksara Target'), findsOneWidget);
      expect(find.text('Nglajengaken Sinau →'), findsOneWidget);
      expect(find.text('Cobi Malih'), findsOneWidget);

      // Switch to English (en)
      await controller.setLocale(const Locale('en'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1600));

      expect(find.text('Quest Result'), findsOneWidget);
      expect(find.text('Writing Comparison'), findsOneWidget);
      expect(find.text('Your Writing'), findsOneWidget);
      expect(find.text('Target Script'), findsOneWidget);
      expect(find.text('Continue Learning →'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
    });

    testWidgets('ProfileScreen & ChooseBlangkonScreen render and switch localized strings dynamically across id, jv, en', (tester) async {
      final storage = InMemoryLocalePreferences(initialLocale: 'id', initialHasChosen: true);
      final controller = LocaleController(preferences: storage);
      await controller.loadSavedLocale();

      // 1. ProfileScreen
      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          child: const ProfileScreen(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));

      expect(find.text('Profil'), findsOneWidget);
      expect(find.text('Lencana'), findsOneWidget);
      expect(find.text('Pilih Blangkon'), findsOneWidget);

      await controller.setLocale(const Locale('en'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));

      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Badges'), findsOneWidget);
      expect(find.text('Choose Blangkon'), findsOneWidget);

      // 2. ChooseBlangkonScreen
      await controller.setLocale(const Locale('id'));
      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          child: const ChooseBlangkonScreen(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Pilih Blangkon'), findsOneWidget);
      expect(find.text('Simpan Pilihan'), findsOneWidget);
      expect(find.text('Klasik, mondolan bulat menonjol'), findsOneWidget);

      await controller.setLocale(const Locale('jv'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Pilih Blangkon'), findsOneWidget);
      expect(find.text('Simpen Pilihan'), findsOneWidget);
      expect(find.text('Klasik, mondolan bunder nonjol'), findsOneWidget);

      await controller.setLocale(const Locale('en'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Choose Blangkon'), findsOneWidget);
      expect(find.text('Save Selection'), findsOneWidget);
      expect(find.text('Classic, pronounced rounded mondolan'), findsOneWidget);
    });

    testWidgets('LevelUpScreen renders and switches localized strings dynamically across id, jv, en', (tester) async {
      final storage = InMemoryLocalePreferences(initialLocale: 'id', initialHasChosen: true);
      final controller = LocaleController(preferences: storage);
      await controller.loadSavedLocale();

      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          child: const LevelUpScreen(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1000));

      // ID assertions
      expect(find.text('PENCAPAIAN JAWALOKA'), findsOneWidget);
      expect(find.text('Level 5!'), findsOneWidget);
      expect(find.text('Pakai Blangkon'), findsOneWidget);
      expect(find.text('Nanti saja'), findsOneWidget);

      // Switch to Javanese (jv)
      await controller.setLocale(const Locale('jv'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1000));

      expect(find.text('PENCAPAIAN JAWALOKA'), findsOneWidget);
      expect(find.text('Level 5!'), findsOneWidget);
      expect(find.text('Agem Blangkon'), findsOneWidget);
      expect(find.text('Mangke rumiyin'), findsOneWidget);

      // Switch to English (en)
      await controller.setLocale(const Locale('en'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1000));

      expect(find.text('JAWALOKA ACHIEVEMENT'), findsOneWidget);
      expect(find.text('Level 5!'), findsOneWidget);
      expect(find.text('Wear Blangkon'), findsOneWidget);
      expect(find.text('Maybe later'), findsOneWidget);
    });

    testWidgets('SettingsScreen renders and switches localized strings dynamically across id, jv, en', (tester) async {
      final storage = InMemoryLocalePreferences(initialLocale: 'id', initialHasChosen: true);
      final controller = LocaleController(preferences: storage);
      await controller.loadSavedLocale();

      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          child: const SettingsScreen(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));

      // ID assertions
      expect(find.text('Bahasa'), findsOneWidget);
      expect(find.text('Kebijakan Privasi'), findsOneWidget);
      expect(find.text('Keluar'), findsOneWidget);

      // Switch to Javanese (jv)
      await controller.setLocale(const Locale('jv'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));

      expect(find.text('Basa'), findsOneWidget);
      expect(find.text('Kawicaksanan Privasi'), findsOneWidget);
      expect(find.text('Miyos'), findsOneWidget);

      // Switch to English (en)
      await controller.setLocale(const Locale('en'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));

      expect(find.text('Language'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);
      expect(find.text('Log Out'), findsOneWidget);
    });

    testWidgets('Gelombang 4 screens layout resilience (scale 1.3 at 360dp width) throws no exceptions or overflows', (tester) async {
      final storage = InMemoryLocalePreferences(initialLocale: 'jv', initialHasChosen: true);
      final controller = LocaleController(preferences: storage);
      await controller.loadSavedLocale();

      // 1. TranslatorScreen
      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          textScaler: const TextScaler.linear(1.3),
          child: const TranslatorScreen(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.takeException(), isNull);

      // 2. DrawingCanvasScreen
      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          textScaler: const TextScaler.linear(1.3),
          child: const DrawingCanvasScreen(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.takeException(), isNull);

      // 3. DailyResultScreen
      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          textScaler: const TextScaler.linear(1.3),
          child: const DailyResultScreen(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1500));
      expect(tester.takeException(), isNull);

      // 4. ProfileScreen
      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          textScaler: const TextScaler.linear(1.3),
          child: const ProfileScreen(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));
      expect(tester.takeException(), isNull);

      // 5. ChooseBlangkonScreen
      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          textScaler: const TextScaler.linear(1.3),
          child: const ChooseBlangkonScreen(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.takeException(), isNull);

      // 6. LevelUpScreen
      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          textScaler: const TextScaler.linear(1.3),
          child: const LevelUpScreen(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1000));
      expect(tester.takeException(), isNull);

      // 7. SettingsScreen
      await tester.pumpWidget(
        buildTestableApp(
          controller: controller,
          textScaler: const TextScaler.linear(1.3),
          child: const SettingsScreen(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));
      expect(tester.takeException(), isNull);
    });
  });
}

