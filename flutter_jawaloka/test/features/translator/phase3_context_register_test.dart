import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/data/translation_entries.dart';
import 'package:flutter_jawaloka/features/translator/data/offline_dictionary_service.dart';
import 'package:flutter_jawaloka/features/translator/domain/translation_models.dart';

void main() {
  const service = OfflineDictionaryService();

  group('Phase 3 - Target 1: Pemisahan Tingkat Tutur (Ngoko / Krama Lugu / Krama Inggil)', () {
    test('Model TranslationEntry memisahkan kramaLugu dan kramaInggil pada kosakata bertingkat', () {
      final byId = {for (final e in kAllTranslationEntries) e.id: e};

      expect(byId['Makan']!.kramaLugu, equals('Nedha'));
      expect(byId['Makan']!.kramaInggil, equals('Dhahar'));
      expect(byId['Tidur']!.kramaLugu, equals('Tilem'));
      expect(byId['Tidur']!.kramaInggil, equals('Sare'));
      expect(byId['Pergi']!.kramaLugu, equals('Kesah'));
      expect(byId['Pergi']!.kramaInggil, equals('Tindak'));
      expect(byId['Datang']!.kramaLugu, equals('Dhateng'));
      expect(byId['Datang']!.kramaInggil, equals('Rawuh'));
      expect(byId['Pulang']!.kramaLugu, equals('Wangsul'));
      expect(byId['Pulang']!.kramaInggil, equals('Kondur'));
      expect(byId['Rumah']!.kramaLugu, equals('Griya'));
      expect(byId['Rumah']!.kramaInggil, equals('Dalem'));
      expect(byId['Mandi']!.kramaLugu, equals('Adus'));
      expect(byId['Mandi']!.kramaInggil, equals('Siram'));
    });

    test('Reverse lookup mengenali input Krama Lugu maupun Krama Inggil ke Bahasa Indonesia', () async {
      final pairs = <String, String>{
        'Tilem': 'Tidur',
        'Sare': 'Tidur',
        'Dhahar': 'Makan',
        'Nedha': 'Makan',
        'Kesah': 'Pergi',
        'Tindak': 'Pergi',
        'Kondur': 'Pulang',
        'Wangsul': 'Pulang',
        'Dalem': 'Rumah',
        'Griya': 'Rumah',
        'Mundhut': 'Membeli',
        'Tumbas': 'Membeli',
        'Siram': 'Mandi',
        'Priksa': 'Tahu',
      };
      for (final p in pairs.entries) {
        final res = await service.translate(
          text: p.key,
          from: TranslationVariant.jvKrama,
          to: TranslationVariant.id,
        );
        expect(res, isA<Found>(), reason: 'Gagal reverse lookup Krama: ${p.key}');
        expect((res as Found).text, equals(p.value));
      }
    });

    test('translateWithRegister memilih Krama Lugu atau Krama Inggil secara eksplisit', () async {
      final lugu = await service.translateWithRegister(
        text: 'Tidur',
        from: TranslationVariant.id,
        to: TranslationVariant.jvKrama,
        register: SpeechRegister.kramaLugu,
      );
      final inggil = await service.translateWithRegister(
        text: 'Tidur',
        from: TranslationVariant.id,
        to: TranslationVariant.jvKrama,
        register: SpeechRegister.kramaInggil,
      );
      expect((lugu as Found).text, equals('Tilem'));
      expect((inggil as Found).text, equals('Sare'));
    });
  });

  group('Phase 3 - Target 2: Konteks Subjek & Disambiguasi Polisemi', () {
    test('Tidur: diri sendiri (Kula Tilem) vs orang yang dihormati (Bapak Sare)', () async {
      final selfRes = await service.translate(
        text: 'Saya tidur',
        from: TranslationVariant.id,
        to: TranslationVariant.jvKrama,
      );
      final honoredRes = await service.translate(
        text: 'Bapak tidur',
        from: TranslationVariant.id,
        to: TranslationVariant.jvKrama,
      );
      expect((selfRes as Found).text, equals('Kula Tilem'));
      expect(selfRes.appliedRegister, equals(SpeechRegister.kramaLugu));
      expect((honoredRes as Found).text, equals('Bapak Sare'));
      expect(honoredRes.appliedRegister, equals(SpeechRegister.kramaInggil));
    });

    test('Pergi: diri sendiri (Kula Kesah) vs orang yang dihormati (Ibu Tindak)', () async {
      final selfRes = await service.translate(
        text: 'Saya pergi ke pasar',
        from: TranslationVariant.id,
        to: TranslationVariant.jvKrama,
      );
      final honoredRes = await service.translate(
        text: 'Ibu pergi ke pasar',
        from: TranslationVariant.id,
        to: TranslationVariant.jvKrama,
      );
      expect((selfRes as Found).text, equals('Kula Kesah dhateng Peken'));
      expect((honoredRes as Found).text, equals('Ibu Tindak dhateng Peken'));
    });

    test('Datang: diri sendiri (Kula Dhateng) vs orang yang dihormati (Guru Rawuh)', () async {
      final selfRes = await service.translate(
        text: 'Saya datang dari rumah',
        from: TranslationVariant.id,
        to: TranslationVariant.jvKrama,
      );
      final honoredRes = await service.translate(
        text: 'Guru datang dari sekolah',
        from: TranslationVariant.id,
        to: TranslationVariant.jvKrama,
      );
      expect((selfRes as Found).text, equals('Kula Dhateng saking Griya'));
      expect((honoredRes as Found).text, equals('Guru Rawuh saking Sekolah'));
    });

    test('Pulang & Kepemilikan Rumah: diri sendiri vs orang yang dihormati', () async {
      final selfHome = await service.translate(
        text: 'Rumah saya',
        from: TranslationVariant.id,
        to: TranslationVariant.jvKrama,
      );
      final honoredHome = await service.translate(
        text: 'Rumah Bapak',
        from: TranslationVariant.id,
        to: TranslationVariant.jvKrama,
      );
      final honoredReturn = await service.translate(
        text: 'Ibu pulang',
        from: TranslationVariant.id,
        to: TranslationVariant.jvKrama,
      );
      expect((selfHome as Found).text, equals('Griya Kula'));
      expect((honoredHome as Found).text, equals('Dalem Bapak'));
      expect((honoredReturn as Found).text, equals('Ibu Kondur'));
    });

    test('Multi-klausa dengan subjek berbeda: peralihan Krama Lugu -> Krama Inggil konsisten', () async {
      final res = await service.translate(
        text: 'Saya makan nasi dan Bapak makan nasi',
        from: TranslationVariant.id,
        to: TranslationVariant.jvKrama,
      );
      expect((res as Found).text, equals('Kula Nedha Sekul kaliyan Bapak Dhahar Sekul'));

      final resSleep = await service.translate(
        text: 'Saya tidur dan Ibu tidur',
        from: TranslationVariant.id,
        to: TranslationVariant.jvKrama,
      );
      expect((resSleep as Found).text, equals('Kula Tilem kaliyan Ibu Sare'));
    });

    test('Polisemi TAHU: makanan (Tahu/Tofu) vs memahami (Ngerti/Mangertos/Priksa) + catatan kata tunggal', () async {
      final foodKrama = await service.translate(
        text: 'Saya makan tahu',
        from: TranslationVariant.id,
        to: TranslationVariant.jvKrama,
      );
      final foodEn = await service.translate(
        text: 'Saya makan tahu',
        from: TranslationVariant.id,
        to: TranslationVariant.en,
      );
      final knowSelf = await service.translate(
        text: 'Saya tahu jalan ke pasar',
        from: TranslationVariant.id,
        to: TranslationVariant.jvKrama,
      );
      final knowHonored = await service.translate(
        text: 'Bapak tahu jalan ke pasar',
        from: TranslationVariant.id,
        to: TranslationVariant.jvKrama,
      );
      final standalone = await service.translate(
        text: 'Tahu',
        from: TranslationVariant.id,
        to: TranslationVariant.jvKrama,
      );

      expect((foodKrama as Found).text, equals('Kula Nedha Tahu'));
      expect((foodEn as Found).text, equals('I Eat Tofu'));
      expect((knowSelf as Found).text, equals('Kula Mangertos Margi dhateng Peken'));
      expect((knowHonored as Found).text, equals('Bapak Priksa Margi dhateng Peken'));
      expect((standalone as Found).note, isNotNull);
      expect(standalone.note!, contains('bermakna ganda'));
    });

    test('Polisemi BISA: mampu (Iso/Saged/Can) vs racun ular (Wisa/Venom) + catatan kata tunggal', () async {
      final abilityKrama = await service.translate(
        text: 'Saya bisa membaca buku',
        from: TranslationVariant.id,
        to: TranslationVariant.jvKrama,
      );
      final venomKrama = await service.translate(
        text: 'Bisa ular berbahaya',
        from: TranslationVariant.id,
        to: TranslationVariant.jvKrama,
      );
      final venomEn = await service.translate(
        text: 'Bisa ular berbahaya',
        from: TranslationVariant.id,
        to: TranslationVariant.en,
      );
      final standalone = await service.translate(
        text: 'Bisa',
        from: TranslationVariant.id,
        to: TranslationVariant.jvKrama,
      );

      expect((abilityKrama as Found).text, equals('Kula Saged Maos Buku'));
      expect((venomKrama as Found).text, equals('Wisa Sawer Mutawatos'));
      expect((venomEn as Found).text, equals('Venom Snake Danger'));
      expect((standalone as Found).note, isNotNull);
      expect(standalone.note!, contains('bermakna ganda'));
    });
  });

  group('Phase 3 - Target 3: Kalimat Perintah, Pertanyaan, Pernyataan & Kejujuran Keterbatasan', () {
    test('Kalimat perintah, pertanyaan, dan pernyataan dengan partikel fungsional', () async {
      final cmd = await service.translate(
        text: 'Silakan duduk',
        from: TranslationVariant.id,
        to: TranslationVariant.jvKrama,
      );
      final forbid = await service.translate(
        text: 'Jangan tidur',
        from: TranslationVariant.id,
        to: TranslationVariant.jvNgoko,
      );
      final question = await service.translate(
        text: 'Ibu pergi ke mana?',
        from: TranslationVariant.id,
        to: TranslationVariant.jvKrama,
      );
      final stmt = await service.translate(
        text: 'Saya sedang membaca buku',
        from: TranslationVariant.id,
        to: TranslationVariant.jvKrama,
      );

      expect((cmd as Found).text, equals('sumangga Lenggah'));
      expect((forbid as Found).text, equals('aja Turu'));
      expect((question as Found).text, equals('Ibu Tindak dhateng pundi'));
      expect((stmt as Found).text, equals('Kula nembe Maos Buku'));
    });

    test('Kalimat dengan kata tidak dikenal menyertakan catatan keterbatasan secara jujur', () async {
      final partial = await service.translate(
        text: 'Saya makan nasi dan zzzkripton',
        from: TranslationVariant.id,
        to: TranslationVariant.jvKrama,
      );
      expect(partial, isA<Found>());
      expect((partial as Found).text, contains('zzzkripton[?]'));
      expect(partial.note, isNotNull);
      expect(partial.note!, contains('kamus offline'));
    });
  });
}
