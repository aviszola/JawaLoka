import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/core/l10n/app_locales.dart';
import 'package:flutter_jawaloka/core/l10n/locale_preferences.dart';
import 'package:flutter_jawaloka/core/l10n/locale_controller.dart';
import 'package:flutter_jawaloka/core/l10n/jv_localizations_delegate.dart';
import 'package:flutter_jawaloka/l10n/app_localizations.dart';

void main() {
  group('AppLocales and Normalization Tests', () {
    test('default locale is Indonesian (id)', () {
      expect(AppLocales.defaultLocale, const Locale('id'));
    });

    test('supportedLocales contains id, jv, and en', () {
      expect(AppLocales.supportedLocales, const [
        Locale('id'),
        Locale('jv'),
        Locale('en'),
      ]);
    });

    test('endonyms are correctly defined and never translated', () {
      expect(AppLocales.endonymOf('id'), 'Bahasa Indonesia');
      expect(AppLocales.endonymOf('jv'), 'Basa Jawa');
      expect(AppLocales.endonymOf('en'), 'English');
      expect(AppLocales.endonymOf('unknown'), 'Bahasa Indonesia');
    });

    test(
      'parse correctly maps jw to jv, normalizes valid codes, and falls back to id',
      () {
        expect(AppLocales.parse('jv'), const Locale('jv'));
        expect(AppLocales.parse('jw'), const Locale('jv')); // Legacy mapping
        expect(AppLocales.parse('JW'), const Locale('jv'));
        expect(AppLocales.parse('en'), const Locale('en'));
        expect(AppLocales.parse('id'), const Locale('id'));
        expect(
          AppLocales.parse('fr'),
          const Locale('id'),
        ); // Corrupted / unsupported
        expect(AppLocales.parse(null), const Locale('id'));
        expect(AppLocales.parse('  '), const Locale('id'));
      },
    );
  });

  group('LocalePreferences Storage Tests', () {
    test('InMemoryLocalePreferences returns default if unset', () async {
      final prefs = InMemoryLocalePreferences();
      expect(await prefs.loadLocale(), const Locale('id'));
      expect(await prefs.hasChosenLanguage(), isFalse);
    });

    test('InMemoryLocalePreferences maps legacy jw to jv upon load', () async {
      final prefs = InMemoryLocalePreferences(initialLocale: 'jw');
      expect(await prefs.loadLocale(), const Locale('jv'));
    });

    test('InMemoryLocalePreferences saves and reloads locale', () async {
      final prefs = InMemoryLocalePreferences();
      await prefs.saveLocale(const Locale('en'));
      expect(await prefs.loadLocale(), const Locale('en'));

      await prefs.setHasChosenLanguage(true);
      expect(await prefs.hasChosenLanguage(), isTrue);
    });

    test(
      'InMemoryLocalePreferences falls back to id on corrupted value',
      () async {
        final prefs = InMemoryLocalePreferences();
        prefs.setRawLocaleForTesting('invalid_corrupted_value');
        expect(await prefs.loadLocale(), const Locale('id'));
      },
    );
  });

  group('LocaleController Tests', () {
    test('initial state defaults to id and unchosen', () {
      final controller = LocaleController(
        preferences: InMemoryLocalePreferences(),
      );
      expect(controller.locale, const Locale('id'));
      expect(controller.hasChosenLanguage, isFalse);
      expect(controller.isInitialized, isFalse);
    });

    test(
      'loadSavedLocale restores saved locale and notifies listeners',
      () async {
        final prefs = InMemoryLocalePreferences(
          initialLocale: 'en',
          initialHasChosen: true,
        );
        final controller = LocaleController(preferences: prefs);

        var notified = false;
        controller.addListener(() => notified = true);

        await controller.loadSavedLocale();

        expect(controller.locale, const Locale('en'));
        expect(controller.hasChosenLanguage, isTrue);
        expect(controller.isInitialized, isTrue);
        expect(notified, isTrue);
      },
    );

    test(
      'setLocale persists choice, normalizes legacy jw, and notifies listeners',
      () async {
        final prefs = InMemoryLocalePreferences();
        final controller = LocaleController(preferences: prefs);
        await controller.loadSavedLocale();

        var notificationCount = 0;
        controller.addListener(() => notificationCount++);

        await controller.setLocale(const Locale('jw')); // legacy jw
        expect(controller.locale, const Locale('jv')); // normalized to jv
        expect(notificationCount, 1);
        expect(await prefs.loadLocale(), const Locale('jv'));

        // Setting same locale does not trigger redundant notifications
        await controller.setLocale(const Locale('jv'));
        expect(notificationCount, 1);
      },
    );

    test('markLanguageChosen marks and notifies once', () async {
      final prefs = InMemoryLocalePreferences();
      final controller = LocaleController(preferences: prefs);
      await controller.loadSavedLocale();

      var notificationCount = 0;
      controller.addListener(() => notificationCount++);

      await controller.markLanguageChosen();
      expect(controller.hasChosenLanguage, isTrue);
      expect(notificationCount, 1);
      expect(await prefs.hasChosenLanguage(), isTrue);

      // Subsequent call does not trigger redundant notifications
      await controller.markLanguageChosen();
      expect(notificationCount, 1);
    });
  });

  group('AppLocalizations & ARB Generation Verification', () {
    test('AppLocalizations delegates include all required delegates', () {
      expect(AppLocalizations.localizationsDelegates.length, 4);
      expect(AppLocalizations.supportedLocales, contains(const Locale('id')));
      expect(AppLocalizations.supportedLocales, contains(const Locale('jv')));
      expect(AppLocalizations.supportedLocales, contains(const Locale('en')));
    });

    testWidgets('AppLocalizations renders Indonesian strings correctly', (
      tester,
    ) async {
      late AppLocalizations loc;
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('id'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Builder(
            builder: (context) {
              loc = AppLocalizations.of(context);
              return Text(loc.langSelectTitle);
            },
          ),
        ),
      );

      expect(loc.langSelectTitle, 'Pilih Bahasa Pengantar');
      expect(loc.langSelectContinueButton, 'Lanjut');
      expect(loc.settingsLanguageRow, 'Bahasa');
      expect(loc.quizProgress(3, 10), 'Soal 3 dari 10');
      expect(loc.streakDays(1), '1 hari');
      expect(loc.streakDays(5), '5 hari');
    });

    testWidgets('AppLocalizations renders English strings correctly', (
      tester,
    ) async {
      late AppLocalizations loc;
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Builder(
            builder: (context) {
              loc = AppLocalizations.of(context);
              return Text(loc.langSelectTitle);
            },
          ),
        ),
      );

      expect(loc.langSelectTitle, 'Choose App Language');
      expect(loc.langSelectContinueButton, 'Continue');
      expect(loc.settingsLanguageRow, 'Language');
      expect(loc.quizProgress(3, 10), 'Question 3 of 10');
      expect(loc.streakDays(1), '1 day');
      expect(loc.streakDays(5), '5 days');
    });

    testWidgets(
      'AppLocalizations renders Javanese draft strings correctly with jv delegate fallback',
      (tester) async {
        late AppLocalizations loc;
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('jv'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              ...AppLocalizationDelegates.delegates,
            ],
            home: Builder(
              builder: (context) {
                loc = AppLocalizations.of(context);
                return Text(loc.langSelectTitle);
              },
            ),
          ),
        );

        expect(loc.langSelectTitle, 'Pilih Basa Pitedah');
        expect(loc.langSelectContinueButton, 'Lajeng');
        expect(loc.settingsLanguageRow, 'Basa');
        expect(loc.quizProgress(3, 10), 'Pitakon 3 saka 10');
        expect(loc.streakDays(1), '1 dina');
        expect(loc.streakDays(5), '5 dina');
      },
    );

    test(
      'JvMaterialLocalizationsDelegate supports jv and loads Indonesian fallback',
      () async {
        const delegate = JvMaterialLocalizationsDelegate();
        expect(delegate.isSupported(const Locale('jv')), isTrue);
        expect(delegate.isSupported(const Locale('id')), isFalse);
        final mat = await delegate.load(const Locale('jv'));
        expect(mat.okButtonLabel, isNotEmpty);
        expect(delegate.shouldReload(delegate), isFalse);
      },
    );

    test(
      'JvCupertinoLocalizationsDelegate supports jv and loads Indonesian fallback',
      () async {
        const delegate = JvCupertinoLocalizationsDelegate();
        expect(delegate.isSupported(const Locale('jv')), isTrue);
        expect(delegate.isSupported(const Locale('id')), isFalse);
        final cup = await delegate.load(const Locale('jv'));
        expect(cup.datePickerDateOrder, isNotNull);
        expect(delegate.shouldReload(delegate), isFalse);
      },
    );

    testWidgets(
      'MaterialApp with jv locale and fallback delegate renders TextField, tooltip, and text selection without exceptions',
      (tester) async {
        final textController = TextEditingController(
          text: 'Kula sinau basa Jawa',
        );
        addTearDown(textController.dispose);

        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('jv'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              ...AppLocalizationDelegates.delegates,
            ],
            home: Scaffold(
              body: Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.info),
                    tooltip: 'Katrangan',
                    onPressed: () {},
                  ),
                  TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                      labelText: 'Tulis aksara',
                    ),
                  ),
                  const SelectableText('Teks pilihan krama'),
                ],
              ),
            ),
          ),
        );

        // Long press SelectableText to trigger text selection menu/toolbar
        await tester.longPress(find.text('Teks pilihan krama'));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      },
    );
  });
}
