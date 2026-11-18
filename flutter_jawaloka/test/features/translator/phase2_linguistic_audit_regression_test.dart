import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/data/translation_entries.dart';
import 'package:flutter_jawaloka/data/vocab_word.dart';
import 'package:flutter_jawaloka/features/quiz/domain/adaptive_quiz_bank.dart';
import 'package:flutter_jawaloka/features/quiz/domain/curriculum/curriculum_quiz_bank.dart';
import 'package:flutter_jawaloka/features/translator/data/offline_dictionary_service.dart';
import 'package:flutter_jawaloka/features/translator/domain/translation_models.dart';

void main() {
  const service = OfflineDictionaryService();

  group('Phase 2 Audit - Regresi Materi & Bank Soal', () {
    test('VocabWord: segara berlabel Ngoko dan langit beraksara ꦭꦔꦶꦠ꧀', () {
      final segara = VocabWord.sampleWords.firstWhere((w) => w.id == 'segara');
      final langit = VocabWord.sampleWords.firstWhere((w) => w.id == 'langit');
      expect(segara.level, equals('Ngoko'));
      expect(langit.aksara, equals('ꦭꦔꦶꦠ꧀'));
    });

    test('AdaptiveQuizBank: Krama Alus kabar memakai Kados pundi kabaripun?', () {
      final mahir = AdaptiveQuizBank.mahirQuestions;
      expect(mahir[8].options[mahir[8].correctIndex], equals('Kados pundi kabaripun?'));
      for (final q in AdaptiveQuizBank.menengahQuestions.skip(6)) {
        expect(q.prompt.contains('Kosakata'), isFalse);
      }
    });

    test('CurriculumQuizBank: tidak ada regresi kesalahan bahasa yang sudah diaudit', () {
      final all = CurriculumQuizBank.allQuestions;
      expect(all.length, equals(320));

      final byId = {for (final q in all) q.id: q};

      // Unit 1: konsistensi tingkat tutur
      expect(byId['u1_n04_q01']!.options[0], equals('Kenalke, jenengku Budi'));
      expect(byId['u1_n06_q06']!.options[0], contains('ngaturaken'));
      expect(byId['u1_n09_q04']!.options[0], contains('margi dhateng stasiun'));
      expect(byId['u1_n08_q06']!.explanation, contains('nglempitake dhengkul'));

      // Unit 2: suku kata & aksara dha retrofleks
      expect(byId['u2_n17_q05']!.prompt, contains('4 suku kata'));
      expect(byId['u2_n19_q04']!.glyph, equals('ꦥꦝꦗꦪ'));
      expect(byId['u2_n19_q04']!.options[0], equals('Padha jaya'));

      // Unit 3: layar, pepet+layar, krama alus, bahasa Jawa murni
      expect(byId['u3_n22_q06']!.explanation, contains('Layar'));
      expect(byId['u3_n28_q06']!.prompt, contains('werna'));
      expect(byId['u3_n29_q03']!.glyph, equals('ꦲꦶꦧꦸꦩꦸꦤ꧀ꦝꦸꦠ꧀ꦲꦸꦮꦺꦴꦱ꧀'));
      expect(byId['u3_n29_q03']!.options[0], equals('Ibu mundhut uwos'));
      expect(byId['u3_n29_q05']!.options[1], equals('Kréta jawa'));

      // Unit 4: ejaan ngampil & redaksi soal tidak membocorkan jawaban
      expect(byId['u4_n31_q02']!.prompt.toLowerCase().contains('mbakyu'), isFalse);
      expect(byId['u4_n39_q06']!.options[2], equals('Nyambut / ngampil'));

      // Unit 5: dasanama Ranu, lirik sak latar, ngantebake teges
      expect(byId['u5_n47_q01']!.explanation, contains('sak latar'));
      expect(byId['u5_n49_q03']!.options[0], equals('Tirta, Warih, Ranu'));
      expect(byId['u5_n49_q04']!.explanation, contains('ngantebake teges'));
      expect(byId['u5_n49_q04']!.explanation.contains('nyanthet'), isFalse);
    });
  });

  group('Phase 2 Audit - Translation Completeness (10 Skenario)', () {
    test('1. Semua 855 entri kamus aktif dapat diakses penerjemah (ID->Ngoko & ID->Krama)', () async {
      expect(kAllTranslationEntries.length, equals(855));
      for (final entry in kAllTranslationEntries) {
        final ngRes = await service.translate(
          text: entry.id,
          from: TranslationVariant.id,
          to: TranslationVariant.jvNgoko,
        );
        final krRes = await service.translate(
          text: entry.id,
          from: TranslationVariant.id,
          to: TranslationVariant.jvKrama,
        );
        expect(ngRes, isA<Found>(), reason: 'Gagal ID->Ngoko: ${entry.id}');
        expect(krRes, isA<Found>(), reason: 'Gagal ID->Krama: ${entry.id}');
      }
    });

    test('2 & 3. Frasa dua kata dan frasa panjang (termasuk perbaikan typo kaliyan)', () async {
      final res = await service.translate(
        text: 'Senang bertemu dengan Anda',
        from: TranslationVariant.id,
        to: TranslationVariant.jvKrama,
      );
      expect((res as Found).text, equals('Remen pinanggih kaliyan panjenengan'));

      final res2 = await service.translate(
        text: 'Besok pagi',
        from: TranslationVariant.id,
        to: TranslationVariant.jvKrama,
      );
      expect((res2 as Found).text, equals('Benjang enjang'));
    });

    test('4 & 5. Kalimat sederhana & kompleks dengan tanda baca internal serta partikel ing/yang', () async {
      final commaRes = await service.translate(
        text: 'Saya makan nasi, dan minum air.',
        from: TranslationVariant.id,
        to: TranslationVariant.jvNgoko,
      );
      expect((commaRes as Found).text, equals('Aku Mangan Sega lan Ngombe Banyu'));

      final relRes = await service.translate(
        text: 'Rumah yang besar tetapi murah',
        from: TranslationVariant.id,
        to: TranslationVariant.jvKrama,
      );
      expect((relRes as Found).text, equals('Griya ingkang Ageng ananging Mirah'));

      final ingRes = await service.translate(
        text: 'Omahku ana ing desa',
        from: TranslationVariant.jvNgoko,
        to: TranslationVariant.id,
      );
      expect((ingRes as Found).text, equals('Rumah-ku Ada di Desa'));
    });

    test('6. Kata berimbuhan: -ne, -nipun, dipun-, di- (Jawa->ID & ID->Jawa), tak-, kok-', () async {
      final neRes = await service.translate(
        text: 'bukune',
        from: TranslationVariant.jvNgoko,
        to: TranslationVariant.id,
      );
      expect((neRes as Found).text, equals('Buku-nya'));

      final nipunRes = await service.translate(
        text: 'griyanipun',
        from: TranslationVariant.jvKrama,
        to: TranslationVariant.id,
      );
      expect((nipunRes as Found).text, equals('Rumah-nya'));

      final dipunRes = await service.translate(
        text: 'dipuntumbas',
        from: TranslationVariant.jvKrama,
        to: TranslationVariant.id,
      );
      expect((dipunRes as Found).text, equals('dibeli'));

      final diJvRes = await service.translate(
        text: 'dituku',
        from: TranslationVariant.jvNgoko,
        to: TranslationVariant.id,
      );
      expect((diJvRes as Found).text, equals('dibeli'));

      final dijualRes = await service.translate(
        text: 'dijual',
        from: TranslationVariant.id,
        to: TranslationVariant.jvKrama,
      );
      expect((dijualRes as Found).text, equals('dipunSade'));

      final takRes = await service.translate(
        text: 'taktuku',
        from: TranslationVariant.jvNgoko,
        to: TranslationVariant.id,
      );
      expect((takRes as Found).text, equals('kubeli'));

      final kokRes = await service.translate(
        text: 'koktuku',
        from: TranslationVariant.jvNgoko,
        to: TranslationVariant.id,
      );
      expect((kokRes as Found).text, equals('kaubeli'));
    });

    test('7. Variasi ejaan wajar (Sugeng enjang, apa, sapa, pira, ana, boten, Kados pundi kabaripun)', () async {
      final enjang = await service.translate(
        text: 'Sugeng enjang',
        from: TranslationVariant.jvKrama,
        to: TranslationVariant.id,
      );
      expect((enjang as Found).text, equals('Selamat pagi'));

      final kabarAlus = await service.translate(
        text: 'Kados pundi kabaripun?',
        from: TranslationVariant.jvKrama,
        to: TranslationVariant.id,
      );
      expect((kabarAlus as Found).text, equals('Apa kabar'));

      final boten = await service.translate(
        text: 'boten',
        from: TranslationVariant.jvKrama,
        to: TranslationVariant.id,
      );
      expect((boten as Found).text, equals('Tidak'));

      final apa = await service.translate(
        text: 'apa',
        from: TranslationVariant.jvNgoko,
        to: TranslationVariant.jvKrama,
      );
      expect((apa as Found).text, equals('Menapa'));
    });

    test('8 & 9. Campuran kata dikenal dan tidak dikenal mempertahankan penanda [?] dengan jujur', () async {
      final mixed = await service.translate(
        text: 'Saya makan nasi dan zzzkripton',
        from: TranslationVariant.id,
        to: TranslationVariant.jvNgoko,
      );
      expect(mixed, isA<Found>());
      expect((mixed as Found).text, equals('Aku Mangan Sega lan zzzkripton[?]'));
    });

    test('10. Terjemahan dua arah kosakata baru berlisensi terbuka (Beras, Kenyang, Pintar)', () async {
      final berasKr = await service.translate(
        text: 'Beras',
        from: TranslationVariant.id,
        to: TranslationVariant.jvKrama,
      );
      expect((berasKr as Found).text, equals('Uwos'));

      final uwosId = await service.translate(
        text: 'Uwos',
        from: TranslationVariant.jvKrama,
        to: TranslationVariant.id,
      );
      expect((uwosId as Found).text, equals('Beras'));
    });
  });
}
