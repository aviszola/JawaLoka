import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/features/translator/data/offline_dictionary_service.dart';
import 'package:flutter_jawaloka/features/translator/domain/translation_models.dart';

void main() {
  const service = OfflineDictionaryService();

  group('Linguistic Quality & Sentence Evaluation Dataset', () {
    // ─────────────────────────────────────────────────────────────────────────
    // 1. 30 Kalimat Indonesia -> Jawa Ngoko
    // ─────────────────────────────────────────────────────────────────────────
    group('1. Indonesia -> Jawa Ngoko (30 Kalimat)', () {
      final sentences = <String, String>{
        'Selamat pagi': 'Sugeng enjing',
        'Selamat siang': 'Sugeng siang',
        'Selamat sore': 'Sugeng sonten',
        'Selamat malam': 'Sugeng dalu',
        'Terima kasih': 'Matur nuwun',
        'Apa kabar': 'Piye kabare',
        'Baik-baik saja': 'Apik-apik wae',
        'Saya tidak mengerti': 'Aku ora ngerti',
        'Saya mengerti': 'Aku ngerti',
        'Saya tidak tahu': 'Aku ora weruh',
        'Nama saya': 'Jenengku',
        'Sampai jumpa': 'Sugeng tindak',
        'Selamat datang': 'Sugeng rawuh',
        'Permisi': 'Nuwun sewu',
        'Nasi goreng': 'Sega goreng',
        'Hari ini': 'Dina iki',
        'Berapa harganya': 'Regane piro',
        'Ini berapa': 'Iki piro',
        'Di mana toilet': 'Neng ndi toilete',
        'Selamat belajar': 'Sugeng sinau',
        'Selamat bekerja': 'Sugeng nyambut gawe',
        'Saya lapar': 'Aku luwe',
        'Saya haus': 'Aku ngelak',
        'Saya lelah': 'Aku kesel',
        'Saya senang': 'Aku seneng',
        'Saya sedih': 'Aku sedhih',
        'Saya sakit': 'Aku lara',
        'Tidak boleh': 'Ora oleh',
        'Tolong bantu saya': 'Tulung tulungana aku',
        'Senang bertemu dengan Anda': 'Seneng ketemu karo sliramu',
      };

      for (final entry in sentences.entries) {
        test('ID->Ngoko: "${entry.key}" -> "${entry.value}"', () async {
          final res = await service.translate(
            text: entry.key,
            from: TranslationVariant.id,
            to: TranslationVariant.jvNgoko,
          );
          expect(res, isA<Found>());
          expect((res as Found).text, equals(entry.value));
        });
      }
    });

    // ─────────────────────────────────────────────────────────────────────────
    // 2. 30 Kalimat Indonesia -> Jawa Krama
    // ─────────────────────────────────────────────────────────────────────────
    group('2. Indonesia -> Jawa Krama (30 Kalimat)', () {
      final sentences = <String, String>{
        'Selamat pagi': 'Sugeng enjing',
        'Selamat siang': 'Sugeng siang',
        'Selamat sore': 'Sugeng sonten',
        'Selamat malam': 'Sugeng dalu',
        'Terima kasih': 'Matur nuwun',
        'Apa kabar': 'Pripun kabaripun',
        'Baik-baik saja': 'Sae-sae kemawon',
        'Saya tidak mengerti': 'Kula mboten mangertos',
        'Saya mengerti': 'Kula mangertos',
        'Saya tidak tahu': 'Kula mboten mangertos menapa-menapa',
        'Nama saya': 'Nami kula',
        'Sampai jumpa': 'Sugeng tindak',
        'Selamat datang': 'Sugeng rawuh',
        'Permisi': 'Nuwun sewu',
        'Nasi goreng': 'Sekul goreng',
        'Hari ini': 'Dinten menika',
        'Berapa harganya': 'Reginipun pinten',
        'Ini berapa': 'Menika pinten',
        'Di mana toilet': 'Wonten pundi toiletipun',
        'Selamat belajar': 'Sugeng sinau',
        'Selamat bekerja': 'Sugeng nyambut damel',
        'Saya lapar': 'Kula luwe',
        'Saya haus': 'Kula ngelak',
        'Saya lelah': 'Kula sayah',
        'Saya senang': 'Kula remen',
        'Saya sedih': 'Kula sungkawa',
        'Saya sakit': 'Kula sakit',
        'Tidak boleh': 'Mboten pareng',
        'Tolong bantu saya': 'Nyuwun tulung biyantu kula',
        'Senang bertemu dengan Anda': 'Remen pinanggih kalian panjenengan',
      };

      for (final entry in sentences.entries) {
        test('ID->Krama: "${entry.key}" -> "${entry.value}"', () async {
          final res = await service.translate(
            text: entry.key,
            from: TranslationVariant.id,
            to: TranslationVariant.jvKrama,
          );
          expect(res, isA<Found>());
          expect((res as Found).text, equals(entry.value));
        });
      }
    });

    // ─────────────────────────────────────────────────────────────────────────
    // 3. 20 Kalimat Jawa Ngoko -> Indonesia
    // ─────────────────────────────────────────────────────────────────────────
    group('3. Jawa Ngoko -> Indonesia (20 Kalimat)', () {
      final sentences = <String, String>{
        'Sugeng enjing': 'Selamat pagi',
        'Sugeng siang': 'Selamat siang',
        'Sugeng sonten': 'Selamat sore',
        'Sugeng dalu': 'Selamat malam',
        'Matur nuwun': 'Terima kasih',
        'Piye kabare': 'Apa kabar',
        'Apik-apik wae': 'Baik-baik saja',
        'Aku ora ngerti': 'Saya tidak mengerti',
        'Aku ngerti': 'Saya mengerti',
        'Aku ora weruh': 'Saya tidak tahu',
        'Jenengku': 'Nama saya',
        'Sugeng tindak': 'Sampai jumpa',
        'Sugeng rawuh': 'Selamat datang',
        'Nuwun sewu': 'Permisi',
        'Sega goreng': 'Nasi goreng',
        'Dina iki': 'Hari ini',
        'Regane piro': 'Berapa harganya',
        'Iki piro': 'Ini berapa',
        'Neng ndi toilete': 'Di mana toilet',
        'Sugeng sinau': 'Selamat belajar',
      };

      for (final entry in sentences.entries) {
        test('Ngoko->ID: "${entry.key}" -> "${entry.value}"', () async {
          final res = await service.translate(
            text: entry.key,
            from: TranslationVariant.jvNgoko,
            to: TranslationVariant.id,
          );
          expect(res, isA<Found>());
          expect((res as Found).text, equals(entry.value));
        });
      }
    });

    // ─────────────────────────────────────────────────────────────────────────
    // 4. 20 Kalimat Jawa Krama -> Indonesia
    // ─────────────────────────────────────────────────────────────────────────
    group('4. Jawa Krama -> Indonesia (20 Kalimat)', () {
      final sentences = <String, String>{
        'Sugeng enjing': 'Selamat pagi',
        'Sugeng siang': 'Selamat siang',
        'Sugeng sonten': 'Selamat sore',
        'Sugeng dalu': 'Selamat malam',
        'Matur nuwun': 'Terima kasih',
        'Pripun kabaripun': 'Apa kabar',
        'Sae-sae kemawon': 'Baik-baik saja',
        'Kula mboten mangertos': 'Saya tidak mengerti',
        'Kula mangertos': 'Saya mengerti',
        'Kula mboten mangertos menapa-menapa': 'Saya tidak tahu',
        'Nami kula': 'Nama saya',
        'Sugeng tindak': 'Sampai jumpa',
        'Sugeng rawuh': 'Selamat datang',
        'Nuwun sewu': 'Permisi',
        'Sekul goreng': 'Nasi goreng',
        'Dinten menika': 'Hari ini',
        'Reginipun pinten': 'Berapa harganya',
        'Menika pinten': 'Ini berapa',
        'Wonten pundi toiletipun': 'Di mana toilet',
        'Sugeng nyambut damel': 'Selamat bekerja',
      };

      for (final entry in sentences.entries) {
        test('Krama->ID: "${entry.key}" -> "${entry.value}"', () async {
          final res = await service.translate(
            text: entry.key,
            from: TranslationVariant.jvKrama,
            to: TranslationVariant.id,
          );
          expect(res, isA<Found>());
          expect((res as Found).text, equals(entry.value));
        });
      }
    });

    // ─────────────────────────────────────────────────────────────────────────
    // 5. 10 Kalimat dengan Kata yang Belum Dikenal (Fallback [?])
    // ─────────────────────────────────────────────────────────────────────────
    group('5. Penanganan Kata Tidak Dikenal (10 Kasus)', () {
      test('1. Kata asing tunggal menghasilkan NotFound', () async {
        final res = await service.translate(
          text: 'supercalifragilistic',
          from: TranslationVariant.id,
          to: TranslationVariant.jvNgoko,
        );
        expect(res, isA<NotFound>());
      });

      test(
        '2. Kalimat dengan satu kata belum dikenal memberi [?] tanpa merusak kata lain',
        () async {
          final res = await service.translate(
            text: 'Saya suka makan nasi goreng',
            from: TranslationVariant.id,
            to: TranslationVariant.jvNgoko,
          );
          expect(res, isA<Found>());
          final text = (res as Found).text;
          expect(text, contains('Aku'));
          expect(text, contains('suka[?]'));
          expect(text, contains('Mangan'));
          expect(text, contains('Sega goreng'));
        },
      );

      test(
        '3. Kalimat kata depan tidak terdaftar tetap menyisipkan [?]',
        () async {
          final res = await service.translate(
            text: 'Saya pergi via sekolah',
            from: TranslationVariant.id,
            to: TranslationVariant.jvNgoko,
          );
          expect(res, isA<Found>());
          final text = (res as Found).text;
          expect(text, contains('Aku'));
          expect(text, contains('Lunga'));
          expect(text, contains('via[?]'));
          expect(text, contains('Sekolah'));
        },
      );

      test(
        '4. Nama orang yang tidak dikenal tidak dihilangkan secara diam-diam',
        () async {
          final res = await service.translate(
            text: 'Nama saya Budi',
            from: TranslationVariant.id,
            to: TranslationVariant.jvKrama,
          );
          expect(res, isA<Found>());
          final text = (res as Found).text;
          expect(text, contains('Nami kula'));
          expect(text, contains('budi[?]'));
        },
      );

      test('5. Kata kerja asing berurutan', () async {
        final res = await service.translate(
          text: 'Saya browsing internet',
          from: TranslationVariant.id,
          to: TranslationVariant.jvNgoko,
        );
        expect(res, isA<Found>());
        final text = (res as Found).text;
        expect(text, contains('Aku'));
        expect(text, contains('browsing[?]'));
        expect(text, contains('internet[?]'));
      });

      test('6. Kata benda modern belum ada di kamus', () async {
        final res = await service.translate(
          text: 'Membeli laptop baru',
          from: TranslationVariant.id,
          to: TranslationVariant.jvNgoko,
        );
        expect(res, isA<Found>());
        final text = (res as Found).text;
        expect(text, contains('Tuku'));
        expect(text, contains('laptop[?]'));
        expect(text, contains('Anyar'));
      });

      test('7. Kalimat Krama dengan kata keterangan belum dikenal', () async {
        final res = await service.translate(
          text: 'Ayah sedang tidur',
          from: TranslationVariant.id,
          to: TranslationVariant.jvKrama,
        );
        expect(res, isA<Found>());
        final text = (res as Found).text;
        expect(text, contains('Bapak'));
        expect(text, contains('sedang[?]'));
        expect(text, contains('Sare'));
      });

      test('8. Dua kata asing di awal kalimat', () async {
        final res = await service.translate(
          text: 'Download aplikasi sekarang',
          from: TranslationVariant.id,
          to: TranslationVariant.jvNgoko,
        );
        expect(res, isA<Found>());
        final text = (res as Found).text;
        expect(text, contains('download[?]'));
        expect(text, contains('aplikasi[?]'));
        expect(text, contains('Saiki'));
      });

      test('9. Kalimat tanya dengan kata sifat asing', () async {
        final res = await service.translate(
          text: 'Apa itu valid',
          from: TranslationVariant.id,
          to: TranslationVariant.jvNgoko,
        );
        expect(res, isA<Found>());
        final text = (res as Found).text;
        expect(text, contains('Opo'));
        expect(text, contains('Iku'));
        expect(text, contains('valid[?]'));
      });

      test('10. Seluruh kata acak asing mengembalikan NotFound', () async {
        final res = await service.translate(
          text: 'xyz foo bar baz',
          from: TranslationVariant.id,
          to: TranslationVariant.jvKrama,
        );
        expect(res, isA<NotFound>());
      });
    });

    // ─────────────────────────────────────────────────────────────────────────
    // 6. 10 Kasus Frasa / Kata Ambigu & Ketepatan Ragam
    // ─────────────────────────────────────────────────────────────────────────
    group('6. Kata & Frasa Ambigu (10 Kasus)', () {
      test('1. "Ini" vs "Itu" krama terpisah (Menika vs Punika)', () async {
        final resIni = await service.translate(
          text: 'Ini',
          from: TranslationVariant.id,
          to: TranslationVariant.jvKrama,
        );
        final resItu = await service.translate(
          text: 'Itu',
          from: TranslationVariant.id,
          to: TranslationVariant.jvKrama,
        );
        expect((resIni as Found).text, equals('Menika'));
        expect((resItu as Found).text, equals('Punika'));
      });

      test('2. "Tanah" vs "Lemah" dibedakan makna dan kramanya', () async {
        final resTanah = await service.translate(
          text: 'Tanah',
          from: TranslationVariant.id,
          to: TranslationVariant.jvKrama,
        );
        final resLemah = await service.translate(
          text: 'Lemah',
          from: TranslationVariant.id,
          to: TranslationVariant.jvKrama,
        );
        expect((resTanah as Found).text, equals('Siti'));
        expect((resLemah as Found).text, equals('Ringkih'));
      });

      test('3. "Pendek" vs "Rendah" dibedakan ngoko dan kramanya', () async {
        final resPendek = await service.translate(
          text: 'Pendek',
          from: TranslationVariant.id,
          to: TranslationVariant.jvNgoko,
        );
        final resRendah = await service.translate(
          text: 'Rendah',
          from: TranslationVariant.id,
          to: TranslationVariant.jvNgoko,
        );
        expect((resPendek as Found).text, equals('Cendhek'));
        expect((resRendah as Found).text, equals('Asor'));
      });

      test('4. "Baru" vs "Cepat" tidak bertabrakan kramanya', () async {
        final resBaru = await service.translate(
          text: 'Baru',
          from: TranslationVariant.id,
          to: TranslationVariant.jvKrama,
        );
        final resCepat = await service.translate(
          text: 'Cepat',
          from: TranslationVariant.id,
          to: TranslationVariant.jvKrama,
        );
        expect((resBaru as Found).text, equals('Enggal'));
        expect((resCepat as Found).text, equals('Gancang'));
      });

      test(
        '5. "Saya sakit" krama lugu/andhap "sakit", bukan krama alus "gerah"',
        () async {
          final res = await service.translate(
            text: 'Saya sakit',
            from: TranslationVariant.id,
            to: TranslationVariant.jvKrama,
          );
          expect((res as Found).text, equals('Kula sakit'));
        },
      );

      test('6. "Pagi" ngoko adalah "Esuk", bukan "Enjing"', () async {
        final res = await service.translate(
          text: 'Pagi',
          from: TranslationVariant.id,
          to: TranslationVariant.jvNgoko,
        );
        expect((res as Found).text, equals('Esuk'));
      });

      test(
        '7. "Selamat pagi" sebagai ungkapan utuh tetap "Sugeng enjing"',
        () async {
          final resNgoko = await service.translate(
            text: 'Selamat pagi',
            from: TranslationVariant.id,
            to: TranslationVariant.jvNgoko,
          );
          expect((resNgoko as Found).text, equals('Sugeng enjing'));
        },
      );

      test('8. "Pintu" krama adalah "Konten"', () async {
        final res = await service.translate(
          text: 'Pintu',
          from: TranslationVariant.id,
          to: TranslationVariant.jvKrama,
        );
        expect((res as Found).text, equals('Konten'));
      });

      test('9. "Tempat tidur" krama adalah "Pasarean"', () async {
        final res = await service.translate(
          text: 'Tempat tidur',
          from: TranslationVariant.id,
          to: TranslationVariant.jvKrama,
        );
        expect((res as Found).text, equals('Pasarean'));
      });

      test('10. "Lari" krama adalah "Mlajeng"', () async {
        final res = await service.translate(
          text: 'Lari',
          from: TranslationVariant.id,
          to: TranslationVariant.jvKrama,
        );
        expect((res as Found).text, equals('Mlajeng'));
      });
    });
  });
}
