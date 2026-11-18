import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/core/l10n/app_locales.dart';
import 'package:flutter_jawaloka/core/l10n/jv_localizations_delegate.dart';
import 'package:flutter_jawaloka/core/l10n/locale_controller.dart';
import 'package:flutter_jawaloka/core/l10n/locale_preferences.dart';
import 'package:flutter_jawaloka/core/l10n/locale_scope.dart';
import 'package:flutter_jawaloka/core/theme/app_theme.dart';
import 'package:flutter_jawaloka/features/translator/data/ai_translation_service.dart';
import 'package:flutter_jawaloka/features/translator/data/offline_dictionary_service.dart';
import 'package:flutter_jawaloka/features/translator/domain/translation_models.dart';
import 'package:flutter_jawaloka/features/translator/presentation/screens/translator_screen.dart';
import 'package:flutter_jawaloka/l10n/app_localizations.dart';

class _MemLocalePrefs implements LocalePreferences {
  Locale _locale;
  bool _chosen;
  _MemLocalePrefs(String code) : _locale = Locale(code), _chosen = true;
  @override
  Future<bool> hasChosenLanguage() async => _chosen;
  @override
  Future<Locale> loadLocale() async => _locale;
  @override
  Future<void> saveLocale(Locale locale) async => _locale = locale;
  @override
  Future<void> setHasChosenLanguage(bool value) async => _chosen = value;
}

Widget _buildTranslatorHarness({
  required LocaleController controller,
  Size size = const Size(360, 640),
  TextScaler textScaler = TextScaler.noScaling,
}) {
  return LocaleScope(
    controller: controller,
    child: Builder(
      builder: (context) => MediaQuery(
        data: MediaQueryData(size: size, textScaler: textScaler),
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          locale: LocaleScope.of(context).locale,
          supportedLocales: AppLocales.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            JvMaterialLocalizationsDelegate(),
            JvCupertinoLocalizationsDelegate(),
            ...AppLocalizationDelegates.delegates,
          ],
          home: const TranslatorScreen(
            translationService: OfflineDictionaryService(),
            aiTranslationBackend: GeminiTranslationBackend(apiKey: ''),
          ),
        ),
      ),
    ),
  );
}

Future<void> _selectTargetKrama(WidgetTester tester) async {
  // Default target is "Jawa Ngoko"; tap the right language chip to switch to "Jawa Krama"
  await tester.tap(find.text('Jawa Ngoko').first);
  await tester.pumpAndSettle();
  await tester.tap(find.text('Jawa Krama').last);
  await tester.pumpAndSettle();
}

void main() {
  const service = OfflineDictionaryService();

  group('Phase 5 - Regresi Perbaikan Bug Nyata Hasil Audit Real-World', () {
    test('Bug #2: Pronomina informal "Aku" di Bahasa Indonesia tidak lagi menghasilkan aku[?]', () async {
      final ngoko = await service.translate(
        text: 'Aku pergi ke pasar beli nasi goreng',
        from: TranslationVariant.id,
        to: TranslationVariant.jvNgoko,
      );
      expect(ngoko, isA<Found>());
      expect(
        (ngoko as Found).text,
        equals('Aku Lunga menyang Pasar Tuku Sega goreng'),
      );
      expect(ngoko.note, isNull);

      final krama = await service.translate(
        text: 'Aku tidur',
        from: TranslationVariant.id,
        to: TranslationVariant.jvKrama,
      );
      expect((krama as Found).text, equals('Kula Tilem'));
      expect(krama.appliedRegister, equals(SpeechRegister.kramaLugu));
    });

    test('Bug #3: Subjek jabatan kehormatan "Kepala sekolah" memakai Krama Inggil (Ngendika), bukan Matur', () async {
      final res = await service.translate(
        text: 'Kepala sekolah berbicara kepada saya',
        from: TranslationVariant.id,
        to: TranslationVariant.jvKrama,
      );
      expect(res, isA<Found>());
      final found = res as Found;
      expect(found.text, equals('Pangarsa sekolah Ngendika dhateng Kula'));
      expect(found.appliedRegister, equals(SpeechRegister.kramaInggil));
    });

    test('Bug #4: Tindakan tersemat penerima dihormati ("Saya mengundang Kakek makan di rumah") memakai Dhahar', () async {
      final res = await service.translate(
        text: 'Saya mengundang Kakek makan di rumah',
        from: TranslationVariant.id,
        to: TranslationVariant.jvKrama,
      );
      expect(res, isA<Found>());
      final found = res as Found;
      expect(
        found.text,
        equals('Kula Ngaturi Eyang kakung Dhahar wonten Griya'),
      );
      expect(found.appliedRegister, equals(SpeechRegister.kramaAndhap));

      // Pastikan kasus kepemilikan tetap menjaga kramaAndhap
      final borrow = await service.translate(
        text: 'Saya meminjam buku Bapak',
        from: TranslationVariant.id,
        to: TranslationVariant.jvKrama,
      );
      expect((borrow as Found).text, equals('Kula Ngampil Buku Bapak'));
      expect(borrow.appliedRegister, equals(SpeechRegister.kramaAndhap));
    });
  });

  group('Phase 5.4 - Skenario Kalimat Sehari-hari (Real-World Matrix)', () {
    test('Kategori 1: Benar berdasarkan aturan (teman, guru, orang tua, dihormati, polisemi, bertingkat)', () async {
      final verified = <(String, TranslationVariant, String, SpeechRegister?)>[
        ('Jangan tidur malam ini, mari belajar!', TranslationVariant.jvNgoko, 'aja Turu Bengi Iki Ayo Sinau', null),
        ('Selamat pagi, saya bertanya kepada Guru', TranslationVariant.jvKrama, 'Sugeng enjing Kula Nyuwun pirsa dhateng Guru', SpeechRegister.kramaAndhap),
        ('Guru datang dari sekolah', TranslationVariant.jvKrama, 'Guru Rawuh saking Sekolah', SpeechRegister.kramaInggil),
        ('Ibu pergi ke pasar membeli sayuran', TranslationVariant.jvKrama, 'Ibu Tindak dhateng Peken Mundhut Janganan', SpeechRegister.kramaInggil),
        ('Saya memberi Ibu obat', TranslationVariant.jvKrama, 'Kula Nyaosi Ibu Jampi', SpeechRegister.kramaAndhap),
        ('Bapak memberi saya uang', TranslationVariant.jvKrama, 'Bapak Maringi Kula Arta', SpeechRegister.kramaInggil),
        ('Rumah Kakek jauh dari pasar', TranslationVariant.jvKrama, 'Dalem Eyang kakung Tebih saking Peken', SpeechRegister.kramaInggil),
        ('Bapak tahu jalan ke pasar', TranslationVariant.jvKrama, 'Bapak Priksa Margi dhateng Peken', SpeechRegister.kramaInggil),
        ('Bisa ular berbahaya', TranslationVariant.jvKrama, 'Wisa Sawer Mutawatos', null),
        ('Ibu tawar harga di pasar', TranslationVariant.jvKrama, 'Ibu Ngawis Regi wonten Peken', SpeechRegister.kramaInggil),
        ('Bunga bank tinggi', TranslationVariant.jvKrama, 'Anakan bank Inggil', null),
        ('Ketika Bapak tidur saya belajar di rumah karena besok ada ujian', TranslationVariant.jvKrama, 'Kala Bapak Sare Kula Sinau wonten Griya amargi Mbenjing Wonten Ujian', SpeechRegister.kramaInggil),
        ('Saya makan nasi dan Bapak makan nasi di rumah', TranslationVariant.jvKrama, 'Kula Nedha Sekul kaliyan Bapak Dhahar Sekul wonten Griya', SpeechRegister.kramaInggil),
        ('Jika Ibu pulang sore ini saya memasak sayuran di dapur', TranslationVariant.jvKrama, 'Menawi Ibu Kondur Sonten Menika Kula Masak Janganan wonten Pawon', SpeechRegister.kramaInggil),
      ];

      for (final (input, target, expected, expectedReg) in verified) {
        final res = await service.translate(
          text: input,
          from: TranslationVariant.id,
          to: target,
        );
        expect(res, isA<Found>(), reason: 'Gagal menerjemahkan: $input');
        final found = res as Found;
        expect(found.text, equals(expected), reason: 'Input: $input');
        if (expectedReg != null) {
          expect(found.appliedRegister, equals(expectedReg), reason: 'Register input: $input');
        }
      }
    });

    test('Kategori 2: Perlu konteks tambahan (Dia tidur, Tahu tunggal) memberi catatan jujur', () async {
      final third = await service.translate(
        text: 'Dia tidur',
        from: TranslationVariant.id,
        to: TranslationVariant.jvKrama,
      ) as Found;
      expect(third.text, equals('Piyambakipun Tilem'));
      expect(third.appliedRegister, equals(SpeechRegister.kramaLugu));
      expect(third.note, isNotNull);

      final singlePoly = await service.translate(
        text: 'Tahu',
        from: TranslationVariant.id,
        to: TranslationVariant.jvKrama,
      ) as Found;
      expect(singlePoly.note, isNotNull);
      expect(singlePoly.note!, contains('bermakna ganda'));
    });

    test('Kategori 3: Kata belum didukung kamus ditandai [?] tanpa mengarang', () async {
      final oov1 = await service.translate(
        text: 'Saya mengirim email ke kantor',
        from: TranslationVariant.id,
        to: TranslationVariant.jvKrama,
      ) as Found;
      expect(oov1.text, equals('Kula Ngintun email[?] dhateng Kantor'));
      expect(oov1.note, contains('[?]'));

      final oov2 = await service.translate(
        text: 'Adik bermain ponsel di kamar',
        from: TranslationVariant.id,
        to: TranslationVariant.jvNgoko,
      ) as Found;
      expect(oov2.text, equals('Adhi Dolanan ponsel[?] neng kamar[?]'));
      expect(oov2.note, contains('[?]'));

      final oov3 = await service.translate(
        text: 'Bapak memesan taksi daring',
        from: TranslationVariant.id,
        to: TranslationVariant.jvKrama,
      ) as Found;
      expect(oov3.text, equals('Bapak memesan[?] taksi[?] daring[?]'));
      expect(oov3.note, contains('[?]'));
    });
  });

  group('Phase 5.3 - TranslatorScreen UI & UX (Catatan, Lencana Register, Layar Kecil)', () {
    testWidgets('Menampilkan catatan ambiguitas & penanda ketidakpastian saat menerjemahkan "Tahu"', (tester) async {
      final ctrl = LocaleController(preferences: _MemLocalePrefs('id'));
      await ctrl.loadSavedLocale();

      await tester.pumpWidget(_buildTranslatorHarness(controller: ctrl));
      await tester.pumpAndSettle();

      await _selectTargetKrama(tester);

      await tester.enterText(find.byType(TextField), 'Tahu');
      await tester.pump();
      await tester.tap(find.text('Terjemahkan'));
      await tester.pumpAndSettle();

      expect(find.text('Mangertos'), findsOneWidget);
      expect(find.byKey(const Key('translator_uncertain_badge')), findsOneWidget);
      expect(find.byKey(const Key('translator_offline_note')), findsOneWidget);
      expect(find.textContaining('bermakna ganda'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Membedakan secara visual lencana Krama Lugu, Krama Inggil, dan Krama Andhap', (tester) async {
      final ctrl = LocaleController(preferences: _MemLocalePrefs('id'));
      await ctrl.loadSavedLocale();

      await tester.pumpWidget(_buildTranslatorHarness(controller: ctrl));
      await tester.pumpAndSettle();
      await _selectTargetKrama(tester);

      // 1. Krama Lugu
      await tester.enterText(find.byType(TextField), 'Saya tidur');
      await tester.pump();
      await tester.tap(find.text('Terjemahkan'));
      await tester.pumpAndSettle();
      expect(find.text('Kula Tilem'), findsOneWidget);
      expect(find.byKey(const Key('translator_register_badge')), findsOneWidget);
      expect(find.text('Krama Lugu (diri sendiri / netral)'), findsOneWidget);

      // 2. Krama Inggil
      await tester.enterText(find.byType(TextField), 'Bapak tidur');
      await tester.pump();
      await tester.tap(find.text('Terjemahkan'));
      await tester.pumpAndSettle();
      expect(find.text('Bapak Sare'), findsOneWidget);
      expect(find.text('Krama Inggil (menghormati)'), findsOneWidget);

      // 3. Krama Andhap
      await tester.enterText(find.byType(TextField), 'Saya memberi Bapak buku');
      await tester.pump();
      await tester.tap(find.text('Terjemahkan'));
      await tester.pumpAndSettle();
      expect(find.text('Kula Nyaosi Bapak Buku'), findsOneWidget);
      expect(find.text('Krama Andhap (merendah kepada yang dihormati)'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Layar Android kecil (360x640, textScaler 1.3) dengan lencana + catatan [?] tidak overflow di id, jv, en', (tester) async {
      for (final code in ['id', 'jv', 'en']) {
        final ctrl = LocaleController(preferences: _MemLocalePrefs(code));
        await ctrl.loadSavedLocale();

        await tester.pumpWidget(
          _buildTranslatorHarness(
            controller: ctrl,
            size: const Size(360, 640),
            textScaler: const TextScaler.linear(1.3),
          ),
        );
        await tester.pumpAndSettle();

        // Switch target to Jawa Krama via language chip (endonym across id/jv/en)
        final translateBtnLabel = switch (code) {
          'en' => 'Translate',
          'jv' => 'Jarwakake',
          _ => 'Terjemahkan',
        };

        await tester.tap(find.text('Jawa Ngoko').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Jawa Krama').last);
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), 'Dia mengirim email');
        await tester.pump();
        await tester.ensureVisible(find.text(translateBtnLabel));
        await tester.tap(find.text(translateBtnLabel));
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('translator_register_badge')), findsOneWidget);
        expect(find.byKey(const Key('translator_uncertain_badge')), findsOneWidget);
        expect(find.byKey(const Key('translator_offline_note')), findsOneWidget);
        expect(tester.takeException(), isNull);
        // Reset widget tree cleanly between locales
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();
      }
    });
  });
}
