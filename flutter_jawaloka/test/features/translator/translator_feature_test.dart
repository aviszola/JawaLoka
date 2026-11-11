import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/core/l10n/app_locales.dart';
import 'package:flutter_jawaloka/core/l10n/jv_localizations_delegate.dart';
import 'package:flutter_jawaloka/core/l10n/locale_controller.dart';
import 'package:flutter_jawaloka/core/l10n/locale_preferences.dart';
import 'package:flutter_jawaloka/core/l10n/locale_scope.dart';
import 'package:flutter_jawaloka/core/theme/app_theme.dart';
import 'package:flutter_jawaloka/data/translation_entries.dart';
import 'package:flutter_jawaloka/features/translator/data/offline_dictionary_service.dart';
import 'package:flutter_jawaloka/features/translator/domain/translation_models.dart';
import 'package:flutter_jawaloka/features/translator/presentation/screens/translator_screen.dart';
import 'package:flutter_jawaloka/l10n/app_localizations.dart';

Widget buildTestableApp({
  required LocaleController controller,
  required Widget child,
  TextScaler textScaler = TextScaler.noScaling,
  Size screenSize = const Size(360, 800),
}) {
  return LocaleScope(
    controller: controller,
    child: Builder(
      builder: (context) {
        final activeLocale = LocaleScope.of(context).locale;
        return MediaQuery(
          data: MediaQueryData(size: screenSize, textScaler: textScaler),
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
            home: child,
          ),
        );
      },
    ),
  );
}

void main() {
  const service = OfflineDictionaryService();

  group('Fase 4 - Kamus & Layanan Penerjemah Unit Tests', () {
    test('h. Tidak ada entri yang id-nya muncul dua kali di kamus gabungan', () {
      final ids = kTranslationEntries
          .map((e) => e.id.toLowerCase().trim())
          .toList();
      final uniqueIds = ids.toSet();
      expect(
        ids.length,
        equals(uniqueIds.length),
        reason: 'Terdapat ID duplikat pada kTranslationEntries',
      );
      // Ratchet: kamus diperluas ke 239 entri — nilai ini tidak boleh dikurangi.
      expect(kTranslationEntries.length, greaterThanOrEqualTo(239));
    });

    test(
      'a. Data-driven: setiap entri dan pasangan varian berhasil diterjemahkan',
      () async {
        final variants = TranslationVariant.values;

        for (final entry in kTranslationEntries) {
          for (final from in variants) {
            for (final to in variants) {
              if (from == to) continue;

              final sourceText = entry.getVariant(from);
              final expectedTarget = entry.getVariant(to);

              final result = await service.translate(
                text: sourceText,
                from: from,
                to: to,
              );

              expect(
                result,
                isA<Found>(),
                reason: 'Gagal menerjemahkan "$sourceText" dari $from ke $to',
              );

              final found = result as Found;
              expect(
                found.text,
                equals(expectedTarget),
                reason:
                    'Hasil terjemahan "$sourceText" ($from -> $to) harus "$expectedTarget", tapi didapat "${found.text}"',
              );
            }
          }
        }
      },
    );

    test(
      'b. Normalisasi: huruf besar, spasi berlebih, dan tanda baca di ujung memberi hasil sama',
      () async {
        final variations = [
          'Selamat pagi',
          'SELAMAT PAGI',
          '  selamat   pagi ',
          'Selamat pagi!',
          'Selamat pagi?',
          'Selamat pagi.',
          'Selamat pagi,',
          'Selamat pagi;',
        ];

        for (final input in variations) {
          final result = await service.translate(
            text: input,
            from: TranslationVariant.id,
            to: TranslationVariant.en,
          );

          expect(
            result,
            isA<Found>(),
            reason: 'Variasi "$input" gagal dinormalisasi',
          );
          expect((result as Found).text, equals('Good morning'));
        }
      },
    );

    test(
      'c. Kata tidak dikenal: input dengan kata yang sama sekali tidak ada menghasilkan NotFound',
      () async {
        // Frasa yang tidak ada satu pun token-nya di kamus menghasilkan NotFound
        final resultAllUnknown = await service.translate(
          text: 'Xylophone glorfindel blargh',
          from: TranslationVariant.id,
          to: TranslationVariant.jvNgoko,
        );
        expect(resultAllUnknown, isA<NotFound>());
      },
    );

    test(
      'c2. Token matching: frasa dengan kata dikenal dan tidak dikenal menghasilkan Found dengan penanda [?]',
      () async {
        // "Saya" ada, "suka" tidak ada, "makan" ada, "nasi goreng" ada (sebagai frasa)
        final result = await service.translate(
          text: 'Saya suka makan nasi goreng',
          from: TranslationVariant.id,
          to: TranslationVariant.jvNgoko,
        );
        expect(result, isA<Found>());
        final text = (result as Found).text;
        // Kata dikenal harus diterjemahkan
        expect(text, contains('Aku')); // Saya -> Aku
        expect(text, contains('Mangan')); // Makan -> Mangan
        expect(text, contains('Sega goreng')); // Nasi goreng -> Sega goreng
        // Kata tidak dikenal harus diberi penanda [?]
        expect(text, contains('suka[?]'));
      },
    );

    test(
      'd. Ngoko ke Krama dwiarah berfungsi tepat lewat entri yang sama',
      () async {
        final ngokoToKrama = await service.translate(
          text: 'Aku ora ngerti',
          from: TranslationVariant.jvNgoko,
          to: TranslationVariant.jvKrama,
        );
        expect(ngokoToKrama, isA<Found>());
        expect((ngokoToKrama as Found).text, equals('Kula mboten mangertos'));

        final kramaToNgoko = await service.translate(
          text: 'Kula mboten mangertos',
          from: TranslationVariant.jvKrama,
          to: TranslationVariant.jvNgoko,
        );
        expect(kramaToNgoko, isA<Found>());
        expect((kramaToNgoko as Found).text, equals('Aku ora ngerti'));
      },
    );

    test(
      'e. Varian sama (id ke id): masukan dikembalikan apa adanya tanpa error',
      () async {
        const input = 'Selamat pagi dunia';
        final result = await service.translate(
          text: input,
          from: TranslationVariant.id,
          to: TranslationVariant.id,
        );

        expect(result, isA<Found>());
        expect((result as Found).text, equals(input));
      },
    );

    test('examples() mengembalikan daftar contoh yang valid sesuai varian', () {
      final examplesId = service.examples(TranslationVariant.id, max: 4);
      expect(examplesId.length, equals(4));
      expect(examplesId[0], equals('Selamat pagi'));
      expect(examplesId[3], equals('Terima kasih'));

      final examplesEn = service.examples(TranslationVariant.en, max: 3);
      expect(examplesEn.length, equals(3));
      expect(examplesEn[0], equals('Good morning'));
    });

    // ── Tes kualitas kosakata baru ────────────────────────────────────────────

    group(
      'g. Kualitas kosakata: kata-kata umum yang wajib dapat diterjemahkan',
      () {
        // Referensi: Kamus Besar Bahasa Jawa-Indonesia, Poerwadarminta
        final verifiedPairs =
            <String, (TranslationVariant, TranslationVariant, String)>{
              // kata ganti
              'Saya': (
                TranslationVariant.id,
                TranslationVariant.jvNgoko,
                'Aku',
              ),
              'Kamu': (
                TranslationVariant.id,
                TranslationVariant.jvNgoko,
                'Kowe',
              ),
              // sapaan
              'Halo': (TranslationVariant.id, TranslationVariant.en, 'Hello'),
              'Terima kasih': (
                TranslationVariant.id,
                TranslationVariant.en,
                'Thank you',
              ),
              'Selamat datang': (
                TranslationVariant.id,
                TranslationVariant.jvNgoko,
                'Sugeng rawuh',
              ),
              'Maaf': (
                TranslationVariant.id,
                TranslationVariant.jvKrama,
                'Nyuwun pangapunten',
              ),
              // kata kerja
              'Makan': (
                TranslationVariant.id,
                TranslationVariant.jvNgoko,
                'Mangan',
              ),
              'Minum': (
                TranslationVariant.id,
                TranslationVariant.jvKrama,
                'Ngunjuk',
              ),
              'Tidur': (
                TranslationVariant.id,
                TranslationVariant.jvNgoko,
                'Turu',
              ),
              'Pergi': (
                TranslationVariant.id,
                TranslationVariant.jvNgoko,
                'Lunga',
              ),
              'Datang': (
                TranslationVariant.id,
                TranslationVariant.jvKrama,
                'Rawuh',
              ),
              'Belajar': (
                TranslationVariant.id,
                TranslationVariant.jvNgoko,
                'Sinau',
              ),
              'Membeli': (
                TranslationVariant.id,
                TranslationVariant.jvKrama,
                'Tumbas',
              ),
              // kata benda umum
              'Rumah': (
                TranslationVariant.id,
                TranslationVariant.jvNgoko,
                'Omah',
              ),
              'Air': (
                TranslationVariant.id,
                TranslationVariant.jvKrama,
                'Toya',
              ),
              'Matahari': (
                TranslationVariant.id,
                TranslationVariant.jvNgoko,
                'Srengenge',
              ),
              'Nasi': (
                TranslationVariant.id,
                TranslationVariant.jvNgoko,
                'Sega',
              ),
              // angka
              'Satu': (
                TranslationVariant.id,
                TranslationVariant.jvKrama,
                'Setunggal',
              ),
              'Dua': (
                TranslationVariant.id,
                TranslationVariant.jvNgoko,
                'Loro',
              ),
              'Lima': (
                TranslationVariant.id,
                TranslationVariant.jvKrama,
                'Gangsal',
              ),
              // waktu
              'Sekarang': (
                TranslationVariant.id,
                TranslationVariant.jvNgoko,
                'Saiki',
              ),
              'Hari ini': (
                TranslationVariant.id,
                TranslationVariant.jvNgoko,
                'Dina iki',
              ),
              'Besok': (
                TranslationVariant.id,
                TranslationVariant.jvKrama,
                'Mbenjing',
              ),
              // keluarga
              'Ayah': (
                TranslationVariant.id,
                TranslationVariant.jvNgoko,
                'Bapak',
              ),
              'Ibu': (TranslationVariant.id, TranslationVariant.jvNgoko, 'Ibu'),
              'Teman': (
                TranslationVariant.id,
                TranslationVariant.jvKrama,
                'Rencang',
              ),
              // kata sifat
              'Bagus': (
                TranslationVariant.id,
                TranslationVariant.jvKrama,
                'Sae',
              ),
              'Besar': (
                TranslationVariant.id,
                TranslationVariant.jvNgoko,
                'Gedhe',
              ),
              'Senang': (
                TranslationVariant.id,
                TranslationVariant.jvNgoko,
                'Seneng',
              ),
              'Lapar': (
                TranslationVariant.id,
                TranslationVariant.jvNgoko,
                'Luwe',
              ),
              // frasa khas
              'Nasi goreng': (
                TranslationVariant.id,
                TranslationVariant.jvNgoko,
                'Sega goreng',
              ),
              'Kemarin': (
                TranslationVariant.id,
                TranslationVariant.en,
                'Yesterday',
              ),
            };

        for (final entry in verifiedPairs.entries) {
          final sourceText = entry.key;
          final (from, to, expected) = entry.value;
          test('[$sourceText] $from→$to = "$expected"', () async {
            final result = await service.translate(
              text: sourceText,
              from: from,
              to: to,
            );
            expect(
              result,
              isA<Found>(),
              reason: '"$sourceText" harus ada di kamus',
            );
            expect((result as Found).text, equals(expected));
          });
        }
      },
    );

    test('g2. Input EN→JvNgoko: "Sleep" → "Turu"', () async {
      final result = await service.translate(
        text: 'Sleep',
        from: TranslationVariant.en,
        to: TranslationVariant.jvNgoko,
      );
      expect(result, isA<Found>());
      expect((result as Found).text, equals('Turu'));
    });

    test('g3. Input JvNgoko→ID: "Mangan" → "Makan"', () async {
      final result = await service.translate(
        text: 'Mangan',
        from: TranslationVariant.jvNgoko,
        to: TranslationVariant.id,
      );
      expect(result, isA<Found>());
      expect((result as Found).text, equals('Makan'));
    });

    test('g4. Input JvKrama→ID: "Nedha" → "Makan"', () async {
      final result = await service.translate(
        text: 'Nedha',
        from: TranslationVariant.jvKrama,
        to: TranslationVariant.id,
      );
      expect(result, isA<Found>());
      expect((result as Found).text, equals('Makan'));
    });

    test('g5. Normalisasi kapital + tanda baca: "SAYA!" → Aku/Kula', () async {
      final resultNgoko = await service.translate(
        text: 'SAYA!',
        from: TranslationVariant.id,
        to: TranslationVariant.jvNgoko,
      );
      expect(resultNgoko, isA<Found>());
      expect((resultNgoko as Found).text, equals('Aku'));
    });

    test(
      'g6. Fallback kata tidak dikenal: "blub" menghasilkan NotFound saat single unknown token',
      () async {
        final result = await service.translate(
          text: 'blub',
          from: TranslationVariant.id,
          to: TranslationVariant.jvNgoko,
        );
        // Token tunggal yang tidak dikenal → Found dengan penanda [?], bukan NotFound
        // karena anyFound=false → NotFound
        expect(result, isA<NotFound>());
      },
    );

    test('g7. Spasi berlebih dinormalisasi: "  Saya   " → Aku', () async {
      final result = await service.translate(
        text: '  Saya   ',
        from: TranslationVariant.id,
        to: TranslationVariant.jvNgoko,
      );
      expect(result, isA<Found>());
      expect((result as Found).text, equals('Aku'));
    });

    test(
      'g8. Regression — 4 entri pertama contoh tidak berubah posisi atau nilai',
      () async {
        // Memastikan contoh frasa yang tampil di UI tetap benar
        expect(
          service.examples(TranslationVariant.id, max: 4),
          equals([
            'Selamat pagi',
            'Selamat siang',
            'Selamat sore',
            'Terima kasih',
          ]),
        );
      },
    );
  });

  group('Fase 4 - Layar Penerjemah Widget Tests', () {
    testWidgets(
      'f1. Tiga bahasa UI x textScaler 1.0 & 1.3 pada lebar 360 dp tidak throw exception',
      (tester) async {
        final locales = ['id', 'jv', 'en'];
        final scalers = [
          const TextScaler.linear(1.0),
          const TextScaler.linear(1.3),
        ];

        for (final loc in locales) {
          for (final scaler in scalers) {
            final storage = InMemoryLocalePreferences(
              initialLocale: loc,
              initialHasChosen: true,
            );
            final controller = LocaleController(preferences: storage);
            await controller.loadSavedLocale();

            await tester.pumpWidget(
              buildTestableApp(
                controller: controller,
                textScaler: scaler,
                screenSize: const Size(360, 800),
                child: const TranslatorScreen(),
              ),
            );
            await tester.pumpAndSettle();

            expect(tester.takeException(), isNull);
          }
        }
      },
    );

    testWidgets(
      'f2. Mengetik "Terima kasih" lalu terjemahkan Indonesia ke English memberi "Thank you"',
      (tester) async {
        final storage = InMemoryLocalePreferences(
          initialLocale: 'id',
          initialHasChosen: true,
        );
        final controller = LocaleController(preferences: storage);
        await controller.loadSavedLocale();

        await tester.pumpWidget(
          buildTestableApp(
            controller: controller,
            child: const TranslatorScreen(),
          ),
        );
        await tester.pumpAndSettle();

        // Secara bawaan: dari Indonesia ke Jawa Ngoko. Ubah bahasa tujuan ke English.
        // Buka bottom sheet picker bahasa tujuan dengan mengetuk chip kanan
        await tester.tap(find.text('Jawa Ngoko').first);
        await tester.pumpAndSettle();

        // Pilih English di bottom sheet
        await tester.tap(find.text('English').last);
        await tester.pumpAndSettle();

        // Ketik "Terima kasih" di kolom input
        await tester.enterText(find.byType(TextField), 'Terima kasih');
        await tester.pumpAndSettle();

        // Ketuk tombol Terjemahkan
        await tester.tap(find.text('Terjemahkan'));
        await tester.pumpAndSettle();

        // Pastikan hasil "Thank you" tampil
        expect(find.text('Thank you'), findsOneWidget);
      },
    );

    testWidgets(
      'f3. Mengganti bahasa UI mengubah label, judul, dan petunjuk secara dinamis',
      (tester) async {
        final storage = InMemoryLocalePreferences(
          initialLocale: 'id',
          initialHasChosen: true,
        );
        final controller = LocaleController(preferences: storage);
        await controller.loadSavedLocale();

        await tester.pumpWidget(
          buildTestableApp(
            controller: controller,
            child: const TranslatorScreen(),
          ),
        );
        await tester.pumpAndSettle();

        // Teks Indonesia
        expect(find.text('Penerjemah'), findsOneWidget);
        expect(find.text('MASUKKAN TEKS'), findsOneWidget);
        expect(find.text('Terjemahkan'), findsOneWidget);
        expect(find.text('HASIL TERJEMAHAN'), findsOneWidget);

        // Ganti ke English
        await controller.setLocale(const Locale('en'));
        await tester.pumpAndSettle();

        expect(find.text('Translator'), findsOneWidget);
        expect(find.text('ENTER TEXT'), findsOneWidget);
        expect(find.text('Translate'), findsOneWidget);
        expect(find.text('TRANSLATION RESULT'), findsOneWidget);

        // Ganti ke Basa Jawa
        await controller.setLocale(const Locale('jv'));
        await tester.pumpAndSettle();

        expect(find.text('Penerjemah'), findsOneWidget);
        expect(find.text('LEBETAKEN TEKS'), findsOneWidget);
        expect(find.text('Jarwakake'), findsOneWidget);
        expect(find.text('ASILING JARWAN'), findsOneWidget);
      },
    );

    testWidgets(
      'f4. Tombol tukar menukar bahasa dan memindahkan teks hasil ke input',
      (tester) async {
        final storage = InMemoryLocalePreferences(
          initialLocale: 'id',
          initialHasChosen: true,
        );
        final controller = LocaleController(preferences: storage);
        await controller.loadSavedLocale();

        await tester.pumpWidget(
          buildTestableApp(
            controller: controller,
            child: const TranslatorScreen(),
          ),
        );
        await tester.pumpAndSettle();

        // Ganti tujuan ke English
        await tester.tap(find.text('Jawa Ngoko').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('English').last);
        await tester.pumpAndSettle();

        // Input "Halo"
        await tester.enterText(find.byType(TextField), 'Halo');
        await tester.pumpAndSettle();

        // Terjemahkan
        await tester.tap(find.text('Terjemahkan'));
        await tester.pumpAndSettle();

        expect(find.text('Hello'), findsOneWidget);

        // Ketuk tombol swap
        await tester.tap(find.byIcon(Icons.swap_horiz_rounded));
        await tester.pumpAndSettle();

        // Bahasa asal sekarang English, tujuan Indonesia, dan input field memuat "Hello"
        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.controller?.text, equals('Hello'));
      },
    );
  });
}
