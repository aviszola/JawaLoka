import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/features/translator/data/offline_dictionary_service.dart';
import 'package:flutter_jawaloka/features/translator/domain/translation_models.dart';

void main() {
  const service = OfflineDictionaryService();

  group('Phase 3 - Engine Enhancement Tests', () {
    // ─────────────────────────────────────────────────────────────────────────
    // 1. Grammatical Particles & Conjunctions
    // ─────────────────────────────────────────────────────────────────────────
    group('1. Partikel & Kata Hubung Baku', () {
      test('dan / lan / kaliyan', () async {
        final resNgoko = await service.translate(
          text: 'Makan dan minum',
          from: TranslationVariant.id,
          to: TranslationVariant.jvNgoko,
        );
        expect((resNgoko as Found).text, equals('Mangan lan Ngombe'));

        final resKrama = await service.translate(
          text: 'Makan dan minum',
          from: TranslationVariant.id,
          to: TranslationVariant.jvKrama,
        );
        expect((resKrama as Found).text, equals('Nedha kaliyan Ngunjuk'));
      });

      test('atau / utawa / utawi', () async {
        final resNgoko = await service.translate(
          text: 'Teh atau kopi',
          from: TranslationVariant.id,
          to: TranslationVariant.jvNgoko,
        );
        expect((resNgoko as Found).text, equals('Teh utawa Kopi'));

        final resKrama = await service.translate(
          text: 'Teh atau kopi',
          from: TranslationVariant.id,
          to: TranslationVariant.jvKrama,
        );
        expect((resKrama as Found).text, equals('Teh utawi Kopi'));
      });

      test('tetapi / nanging / ananging', () async {
        final resNgoko = await service.translate(
          text: 'Besar tetapi murah',
          from: TranslationVariant.id,
          to: TranslationVariant.jvNgoko,
        );
        expect((resNgoko as Found).text, equals('Gedhe nanging Murah'));

        final resKrama = await service.translate(
          text: 'Besar tetapi murah',
          from: TranslationVariant.id,
          to: TranslationVariant.jvKrama,
        );
        expect((resKrama as Found).text, equals('Ageng ananging Mirah'));
      });

      test('karena / amarga / amargi', () async {
        final resNgoko = await service.translate(
          text: 'Lapar karena bekerja',
          from: TranslationVariant.id,
          to: TranslationVariant.jvNgoko,
        );
        expect((resNgoko as Found).text, equals('Luwe amarga Nyambut gawe'));

        final resKrama = await service.translate(
          text: 'Lapar karena bekerja',
          from: TranslationVariant.id,
          to: TranslationVariant.jvKrama,
        );
        expect((resKrama as Found).text, equals('Luwe amargi Nyambut damel'));
      });

      test('di / neng / wonten', () async {
        final resNgoko = await service.translate(
          text: 'Tidur di rumah',
          from: TranslationVariant.id,
          to: TranslationVariant.jvNgoko,
        );
        expect((resNgoko as Found).text, equals('Turu neng Omah'));

        final resKrama = await service.translate(
          text: 'Tidur di rumah',
          from: TranslationVariant.id,
          to: TranslationVariant.jvKrama,
        );
        expect((resKrama as Found).text, equals('Sare wonten Griya'));
      });

      test('ke / menyang / dhateng', () async {
        final resNgoko = await service.translate(
          text: 'Pergi ke pasar',
          from: TranslationVariant.id,
          to: TranslationVariant.jvNgoko,
        );
        expect((resNgoko as Found).text, equals('Lunga menyang Pasar'));

        final resKrama = await service.translate(
          text: 'Pergi ke pasar',
          from: TranslationVariant.id,
          to: TranslationVariant.jvKrama,
        );
        expect((resKrama as Found).text, equals('Tindak dhateng Peken'));
      });

      test('dari / saka / saking', () async {
        final resNgoko = await service.translate(
          text: 'Datang dari kota',
          from: TranslationVariant.id,
          to: TranslationVariant.jvNgoko,
        );
        expect((resNgoko as Found).text, equals('Teka saka Kutha'));

        final resKrama = await service.translate(
          text: 'Datang dari kota',
          from: TranslationVariant.id,
          to: TranslationVariant.jvKrama,
        );
        expect((resKrama as Found).text, equals('Rawuh saking Kitha'));
      });

      test('dengan / karo / kaliyan', () async {
        final resNgoko = await service.translate(
          text: 'Belajar dengan teman',
          from: TranslationVariant.id,
          to: TranslationVariant.jvNgoko,
        );
        expect((resNgoko as Found).text, equals('Sinau karo Kanca'));

        final resKrama = await service.translate(
          text: 'Belajar dengan teman',
          from: TranslationVariant.id,
          to: TranslationVariant.jvKrama,
        );
        expect((resKrama as Found).text, equals('Sinau kaliyan Rencang'));
      });
    });

    // ─────────────────────────────────────────────────────────────────────────
    // 2. Morphological Affix & Clitic Handling
    // ─────────────────────────────────────────────────────────────────────────
    group('2. Penanganan Morfologi & Klitika', () {
      test('Klitika posesif -ku (rumahku -> omah-ku / griya kula)', () async {
        final resNgoko = await service.translate(
          text: 'rumahku',
          from: TranslationVariant.id,
          to: TranslationVariant.jvNgoko,
        );
        expect((resNgoko as Found).text, equals('Omah-ku'));

        final resKrama = await service.translate(
          text: 'rumahku',
          from: TranslationVariant.id,
          to: TranslationVariant.jvKrama,
        );
        expect((resKrama as Found).text, equals('Griya kula'));
      });

      test(
        'Klitika posesif -mu (bukumu -> buku-mu / buku panjenengan)',
        () async {
          final resNgoko = await service.translate(
            text: 'bukumu',
            from: TranslationVariant.id,
            to: TranslationVariant.jvNgoko,
          );
          expect((resNgoko as Found).text, equals('Buku-mu'));

          final resKrama = await service.translate(
            text: 'bukumu',
            from: TranslationVariant.id,
            to: TranslationVariant.jvKrama,
          );
          expect((resKrama as Found).text, equals('Buku panjenengan'));
        },
      );

      test('Klitika posesif -nya (rumahnya -> omah-e / griya-ipun)', () async {
        final resNgoko = await service.translate(
          text: 'rumahnya',
          from: TranslationVariant.id,
          to: TranslationVariant.jvNgoko,
        );
        expect((resNgoko as Found).text, equals('Omah-e'));

        final resKrama = await service.translate(
          text: 'rumahnya',
          from: TranslationVariant.id,
          to: TranslationVariant.jvKrama,
        );
        expect((resKrama as Found).text, equals('Griya-ipun'));
      });

      test('Awalan pasif di- (dibeli -> ditumbas / dituku)', () async {
        final resNgoko = await service.translate(
          text: 'dibeli',
          from: TranslationVariant.id,
          to: TranslationVariant.jvNgoko,
        );
        expect((resNgoko as Found).text, equals('diTuku'));

        final resKrama = await service.translate(
          text: 'dibeli',
          from: TranslationVariant.id,
          to: TranslationVariant.jvKrama,
        );
        expect((resKrama as Found).text, equals('dipunTumbas'));
      });

      test(
        'Jawa Ngoko posesif -ku ke Indonesia (omahku -> rumah-ku)',
        () async {
          final res = await service.translate(
            text: 'omahku',
            from: TranslationVariant.jvNgoko,
            to: TranslationVariant.id,
          );
          expect((res as Found).text, equals('Rumah-ku'));
        },
      );

      test(
        'Jawa Krama posesif -ipun ke Indonesia (griyaipun -> rumah-nya)',
        () async {
          final res = await service.translate(
            text: 'griyaipun',
            from: TranslationVariant.jvKrama,
            to: TranslationVariant.id,
          );
          expect((res as Found).text, equals('Rumah-nya'));
        },
      );
    });

    // ─────────────────────────────────────────────────────────────────────────
    // 3. Kalimat Kompleks Multi-Klausa
    // ─────────────────────────────────────────────────────────────────────────
    group('3. Kalimat Kompleks Multi-Klausa', () {
      test('Kalimat gabungan dengan kata hubung & kata kerja', () async {
        final res = await service.translate(
          text: 'Saya makan nasi dan minum air',
          from: TranslationVariant.id,
          to: TranslationVariant.jvNgoko,
        );
        expect(res, isA<Found>());
        final text = (res as Found).text;
        expect(text, equals('Aku Mangan Sega lan Ngombe Banyu'));
      });

      test('Kalimat Krama majemuk dengan kata depan & kata sambung', () async {
        final res = await service.translate(
          text: 'Ayah pergi ke pasar tetapi ibu di rumah',
          from: TranslationVariant.id,
          to: TranslationVariant.jvKrama,
        );
        expect(res, isA<Found>());
        final text = (res as Found).text;
        expect(text, contains('Bapak'));
        expect(text, contains('Tindak'));
        expect(text, contains('dhateng Peken'));
        expect(text, contains('ananging'));
        expect(text, contains('Ibu'));
        expect(text, contains('wonten Griya'));
      });

      test('Kalimat tanya dengan partikel lokasi', () async {
        final res = await service.translate(
          text: 'Di mana kantor guru',
          from: TranslationVariant.id,
          to: TranslationVariant.jvKrama,
        );
        expect(res, isA<Found>());
        final text = (res as Found).text;
        expect(text, contains('Wonten pundi'));
        expect(text, contains('Kantor Guru'));
      });
    });

    // ─────────────────────────────────────────────────────────────────────────
    // 4. Pengurangan Penanda [?] untuk Kata yang Dikenali
    // ─────────────────────────────────────────────────────────────────────────
    group('4. Pengurangan Penanda [?] yang Tidak Perlu', () {
      test('"ke sekolah" tidak lagi menghasilkan "ke[?]"', () async {
        final res = await service.translate(
          text: 'Pergi ke sekolah',
          from: TranslationVariant.id,
          to: TranslationVariant.jvNgoko,
        );
        expect(res, isA<Found>());
        final found = res as Found;
        expect(found.text, isNot(contains('[?]')));
        expect(found.text, equals('Lunga menyang Sekolah'));
      });

      test('"dan kopi" tidak lagi menghasilkan "dan[?]"', () async {
        final res = await service.translate(
          text: 'Teh dan kopi',
          from: TranslationVariant.id,
          to: TranslationVariant.jvKrama,
        );
        expect(res, isA<Found>());
        final found = res as Found;
        expect(found.text, isNot(contains('[?]')));
        expect(found.text, equals('Teh kaliyan Kopi'));
      });
    });
  });
}
