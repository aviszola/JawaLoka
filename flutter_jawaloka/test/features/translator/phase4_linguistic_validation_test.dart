import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/data/translation_entries.dart';
import 'package:flutter_jawaloka/data/vocab_word.dart';
import 'package:flutter_jawaloka/features/quiz/domain/adaptive_quiz_bank.dart';
import 'package:flutter_jawaloka/features/quiz/domain/curriculum/curriculum_quiz_bank.dart';
import 'package:flutter_jawaloka/features/quiz/domain/models/quiz_question.dart';
import 'package:flutter_jawaloka/features/translator/data/offline_dictionary_service.dart';
import 'package:flutter_jawaloka/features/translator/domain/translation_models.dart';

void main() {
  const service = OfflineDictionaryService();

  Future<Found> expectFound(
    String text,
    TranslationVariant from,
    TranslationVariant to, {
    SpeechRegister? register,
  }) async {
    final res = await service.translateWithRegister(
      text: text,
      from: from,
      to: to,
      register: register,
    );
    expect(
      res,
      isA<Found>(),
      reason: 'Expected Found for "$text" ($from -> $to, reg=$register)',
    );
    return res as Found;
  }

  group('Phase 4 - Target 1: Audit 855 Entri & Perbaikan Leksikon Terverifikasi', () {
    test('Jumlah entri aktif tetap 855 dan entri berdistingsi register >= 50', () {
      expect(kAllTranslationEntries.length, equals(855));
      final distinguished =
          kAllTranslationEntries.where((e) => e.hasHonorificDistinction).length;
      expect(distinguished, greaterThanOrEqualTo(50));
    });

    test('Perbaikan kesalahan register & padanan Krama baku pada kamus aktif', () {
      final byId = {for (final e in kAllTranslationEntries) e.id: e};

      expect(byId['Harga']!.jvKrama, equals('Regi'));
      expect(byId['Panas']!.jvKrama, equals('Benter'));
      expect(byId['Minyak']!.jvKrama, equals('Lisah'));
      expect(byId['Pusing']!.jvKrama, equals('Puyeng'));
      expect(byId['Bulan']!.jvNgoko, equals('Rembulan'));
      expect(byId['Bulan']!.jvKrama, equals('Wulan'));
      expect(byId['Bacaan']!.jvNgoko, equals('Wacan'));
      expect(byId['Bacaan']!.jvKrama, equals('Waosan'));
      expect(byId['Coba']!.jvNgoko, equals('Coba'));
      expect(byId['Coba']!.jvKrama, equals('Cobi'));
      expect(byId['Dewasa']!.jvNgoko, equals('Wis umur'));
      expect(byId['Dewasa']!.jvKrama, equals('Sampun umur'));
      expect(byId['Duga']!.jvNgoko, equals('Duga'));
      expect(byId['Duga']!.jvKrama, equals('Dugi'));
      expect(byId['Bertelur']!.jvNgoko, equals('Ngendhog'));
      expect(byId['Mulut']!.kramaLugu, equals('Lesan'));
      expect(byId['Hidung']!.kramaLugu, equals('Irung'));
      expect(byId['Hidung']!.kramaInggil, equals('Grana'));
      expect(byId['Gigi']!.kramaLugu, equals('Untu'));
      expect(byId['Gigi']!.kramaInggil, equals('Waja'));
      expect(byId['Malu']!.kramaLugu, equals('Isin'));
      expect(byId['Malu']!.kramaInggil, equals('Lingsem'));
      expect(byId['Bekerja']!.kramaInggil, equals('Ngasta'));
      expect(byId['Obat']!.kramaInggil, equals('Usada'));
      expect(byId['Bibir']!.kramaInggil, equals('Lathi'));
      expect(byId['Umur']!.kramaInggil, equals('Yuswa'));
    });
  });

  group('Phase 4 - Target 2: Validasi Unggah-Ungguh (Lugu, Inggil, Andhap & Ketidakpastian)', () {
    test('Krama Andhap: diri sendiri bertindak kepada orang dihormati (memberi, bertanya, berbicara, mengundang, meminjam)', () async {
      final giveHonored = await expectFound(
        'Saya memberi Bapak buku',
        TranslationVariant.id,
        TranslationVariant.jvKrama,
      );
      expect(giveHonored.text, equals('Kula Nyaosi Bapak Buku'));
      expect(giveHonored.appliedRegister, equals(SpeechRegister.kramaAndhap));

      final giveToMother = await expectFound(
        'Saya memberi buku kepada Ibu',
        TranslationVariant.id,
        TranslationVariant.jvKrama,
      );
      expect(giveToMother.text, equals('Kula Nyaosi Buku dhateng Ibu'));
      expect(giveToMother.appliedRegister, equals(SpeechRegister.kramaAndhap));

      final askTeacher = await expectFound(
        'Saya bertanya kepada Guru',
        TranslationVariant.id,
        TranslationVariant.jvKrama,
      );
      expect(askTeacher.text, equals('Kula Nyuwun pirsa dhateng Guru'));
      expect(askTeacher.appliedRegister, equals(SpeechRegister.kramaAndhap));

      final speakFather = await expectFound(
        'Saya berbicara kepada Bapak',
        TranslationVariant.id,
        TranslationVariant.jvKrama,
      );
      expect(speakFather.text, equals('Kula Matur dhateng Bapak'));
      expect(speakFather.appliedRegister, equals(SpeechRegister.kramaAndhap));

      final inviteGrandpa = await expectFound(
        'Saya mengundang Kakek',
        TranslationVariant.id,
        TranslationVariant.jvKrama,
      );
      expect(inviteGrandpa.text, equals('Kula Ngaturi Eyang kakung'));
      expect(inviteGrandpa.appliedRegister, equals(SpeechRegister.kramaAndhap));

      final borrowFather = await expectFound(
        'Saya meminjam buku Bapak',
        TranslationVariant.id,
        TranslationVariant.jvKrama,
      );
      expect(borrowFather.text, equals('Kula Ngampil Buku Bapak'));
      expect(borrowFather.appliedRegister, equals(SpeechRegister.kramaAndhap));
    });

    test('Krama Inggil vs Krama Lugu: tidak meninggikan diri sendiri dan membedakan arah tindakan', () async {
      final fatherGivesMe = await expectFound(
        'Bapak memberi saya buku',
        TranslationVariant.id,
        TranslationVariant.jvKrama,
      );
      expect(fatherGivesMe.text, equals('Bapak Maringi Kula Buku'));
      expect(fatherGivesMe.appliedRegister, equals(SpeechRegister.kramaInggil));

      final selfGivesSibling = await expectFound(
        'Saya memberi adik buku',
        TranslationVariant.id,
        TranslationVariant.jvKrama,
      );
      expect(selfGivesSibling.text, equals('Kula Nyukani Adhi Buku'));
      expect(selfGivesSibling.appliedRegister, equals(SpeechRegister.kramaLugu));

      final motherAsksMe = await expectFound(
        'Ibu bertanya kepada saya',
        TranslationVariant.id,
        TranslationVariant.jvKrama,
      );
      expect(motherAsksMe.text, equals('Ibu Ndangu dhateng Kula'));
      expect(motherAsksMe.appliedRegister, equals(SpeechRegister.kramaInggil));

      final fatherSpeaksMe = await expectFound(
        'Bapak berbicara kepada saya',
        TranslationVariant.id,
        TranslationVariant.jvKrama,
      );
      expect(fatherSpeaksMe.text, equals('Bapak Ngendika dhateng Kula'));
      expect(fatherSpeaksMe.appliedRegister, equals(SpeechRegister.kramaInggil));

      final selfSpeaksFriend = await expectFound(
        'Saya berbicara dengan teman',
        TranslationVariant.id,
        TranslationVariant.jvKrama,
      );
      expect(selfSpeaksFriend.text, equals('Kula Wicanten kaliyan Rencang'));
      expect(selfSpeaksFriend.appliedRegister, equals(SpeechRegister.kramaLugu));

      final fatherWorks = await expectFound(
        'Bapak bekerja di kantor',
        TranslationVariant.id,
        TranslationVariant.jvKrama,
      );
      expect(fatherWorks.text, equals('Bapak Ngasta wonten Kantor'));

      final selfSeesFatherSleep = await expectFound(
        'Saya melihat Bapak tidur',
        TranslationVariant.id,
        TranslationVariant.jvKrama,
      );
      expect(selfSeesFatherSleep.text, equals('Kula Ningali Bapak Sare'));

      final selfNose = await expectFound(
        'Hidung saya',
        TranslationVariant.id,
        TranslationVariant.jvKrama,
      );
      final fatherNose = await expectFound(
        'Hidung Bapak',
        TranslationVariant.id,
        TranslationVariant.jvKrama,
      );
      expect(selfNose.text, equals('Irung Kula'));
      expect(fatherNose.text, equals('Grana Bapak'));
    });

    test('Ketidakpastian status orang ketiga ("Dia tidur") memakai fallback aman Krama Lugu + catatan jujur', () async {
      final thirdPerson = await expectFound(
        'Dia tidur',
        TranslationVariant.id,
        TranslationVariant.jvKrama,
      );
      expect(thirdPerson.text, equals('Piyambakipun Tilem'));
      expect(thirdPerson.appliedRegister, equals(SpeechRegister.kramaLugu));
      expect(thirdPerson.note, isNotNull);
      expect(thirdPerson.note!, contains('Krama Lugu'));

      final standaloneSleep = await expectFound(
        'Tidur',
        TranslationVariant.id,
        TranslationVariant.jvKrama,
      );
      expect(standaloneSleep.note, isNotNull);
      expect(standaloneSleep.note!, contains('Tilem'));
      expect(standaloneSleep.note!, contains('Sare'));
    });

    test('Reverse lookup mengenali Krama Andhap & bentuk Krama baru ke Bahasa Indonesia', () async {
      const pairs = <String, String>{
        'Nyaosi': 'Memberi',
        'Nyuwun pirsa': 'Bertanya',
        'Ndangu': 'Bertanya',
        'Ngaturi': 'Mengundang',
        'Wicanten': 'Berbicara',
        'Lesan': 'Mulut',
        'Lathi': 'Bibir',
        'Yuswa': 'Umur',
        'Usada': 'Obat',
        'Regi': 'Harga',
        'Benter': 'Panas',
        'Puyeng': 'Pusing',
        'Lisah': 'Minyak',
      };
      for (final p in pairs.entries) {
        final res = await expectFound(
          p.key,
          TranslationVariant.jvKrama,
          TranslationVariant.id,
        );
        expect(res.text, equals(p.value), reason: 'Reverse lookup gagal: ${p.key}');
      }
    });
  });

  group('Phase 4 - Target 3: Disambiguasi 19 Kelompok Kata Polisemi', () {
    test('1. bulan (benda langit vs bulan kalender)', () async {
      final moonNgoko = await expectFound('Bulan di langit malam', TranslationVariant.id, TranslationVariant.jvNgoko);
      final moonEn = await expectFound('Bulan di langit malam', TranslationVariant.id, TranslationVariant.en);
      final monthNgoko = await expectFound('Bulan depan saya pergi', TranslationVariant.id, TranslationVariant.jvNgoko);
      final monthEn = await expectFound('Bulan depan saya pergi', TranslationVariant.id, TranslationVariant.en);

      expect(moonNgoko.text, startsWith('Rembulan '));
      expect(moonEn.text, startsWith('Moon '));
      expect(monthNgoko.text, startsWith('Sasi '));
      expect(monthEn.text, startsWith('Month '));
    });

    test('2. kali (frekuensi/pengali vs sungai)', () async {
      final timesKrama = await expectFound('Dua kali makan', TranslationVariant.id, TranslationVariant.jvKrama);
      final timesEn = await expectFound('Dua kali makan', TranslationVariant.id, TranslationVariant.en);
      final riverKrama = await expectFound('Air di kali bersih', TranslationVariant.id, TranslationVariant.jvKrama);
      final riverEn = await expectFound('Air di kali bersih', TranslationVariant.id, TranslationVariant.en);

      expect(timesKrama.text, contains('Kaping'));
      expect(timesEn.text, contains('Times'));
      expect(riverKrama.text, contains('Lepen'));
      expect(riverEn.text, contains('River'));
    });

    test('3. bunga (tanaman vs bunga bank)', () async {
      final flowerKrama = await expectFound('Bunga di kebun', TranslationVariant.id, TranslationVariant.jvKrama);
      final flowerEn = await expectFound('Bunga di kebun', TranslationVariant.id, TranslationVariant.en);
      final bankKrama = await expectFound('Bunga bank tinggi', TranslationVariant.id, TranslationVariant.jvKrama);
      final bankEn = await expectFound('Bunga bank tinggi', TranslationVariant.id, TranslationVariant.en);

      expect(flowerKrama.text, startsWith('Sekar '));
      expect(flowerEn.text, startsWith('Flower '));
      expect(bankKrama.text, startsWith('Anakan bank '));
      expect(bankEn.text, startsWith('Bank interest '));
    });

    test('4. pukul (jam/waktu vs memukul)', () async {
      final timeKrama = await expectFound('Saya datang pukul 7 pagi', TranslationVariant.id, TranslationVariant.jvKrama);
      final timeEn = await expectFound('Saya datang pukul 7 pagi', TranslationVariant.id, TranslationVariant.en);
      final hitNgoko = await expectFound('Jangan pukul meja', TranslationVariant.id, TranslationVariant.jvNgoko);
      final hitEn = await expectFound('Jangan pukul meja', TranslationVariant.id, TranslationVariant.en);

      expect(timeKrama.text, contains('Tabuh 7'));
      expect(timeEn.text, contains("O'clock 7"));
      expect(hitNgoko.text, equals('aja Gebug Meja'));
      expect(hitEn.text, equals('do not Hit Table'));
    });

    test('5. tawar (air tawar vs hambar vs menawar harga)', () async {
      final freshKrama = await expectFound('Air tawar dingin', TranslationVariant.id, TranslationVariant.jvKrama);
      final freshEn = await expectFound('Air tawar dingin', TranslationVariant.id, TranslationVariant.en);
      final blandKrama = await expectFound('Sayur ini tawar', TranslationVariant.id, TranslationVariant.jvKrama);
      final bargainKrama = await expectFound('Ibu tawar harga di pasar', TranslationVariant.id, TranslationVariant.jvKrama);
      final bargainEn = await expectFound('Ibu tawar harga di pasar', TranslationVariant.id, TranslationVariant.en);

      expect(freshKrama.text, startsWith('Toya tawa'));
      expect(freshEn.text, startsWith('Fresh water'));
      expect(blandKrama.text, endsWith('Cemplang'));
      expect(bargainKrama.text, contains('Ngawis Regi'));
      expect(bargainEn.text, contains('Bargain Price'));
    });

    test('6. jadi (konektor "oleh karena itu" vs verba "menjadi")', () async {
      final connKrama = await expectFound('Jadi saya pergi', TranslationVariant.id, TranslationVariant.jvKrama);
      final connEn = await expectFound('Jadi saya pergi', TranslationVariant.id, TranslationVariant.en);
      final verbKrama = await expectFound('Saya ingin jadi guru', TranslationVariant.id, TranslationVariant.jvKrama);
      final verbEn = await expectFound('Saya ingin jadi guru', TranslationVariant.id, TranslationVariant.en);

      expect(connKrama.text, equals('Dadosipun Kula Kesah'));
      expect(connEn.text, startsWith('So '));
      expect(verbKrama.text, contains('Dados Guru'));
      expect(verbEn.text, contains('Become Teacher'));
    });

    test('7. jam (jam tangan vs pukul waktu vs durasi jam)', () async {
      final watchEn = await expectFound('Jam tangan baru', TranslationVariant.id, TranslationVariant.en);
      final oclockKrama = await expectFound('Bapak datang jam 8 pagi', TranslationVariant.id, TranslationVariant.jvKrama);
      final durationEn = await expectFound('Saya belajar dua jam', TranslationVariant.id, TranslationVariant.en);

      expect(watchEn.text, startsWith('Wristwatch'));
      expect(oclockKrama.text, contains('Tabuh 8'));
      expect(durationEn.text, endsWith('Two Hour'));
    });

    test('8. sore (sapaan vs waktu petang)', () async {
      final greet = await expectFound('Selamat sore Bapak', TranslationVariant.id, TranslationVariant.jvKrama);
      final time = await expectFound('Ibu pulang sore ini', TranslationVariant.id, TranslationVariant.jvKrama);

      expect(greet.text, equals('Sugeng sonten Bapak'));
      expect(time.text, equals('Ibu Kondur Sonten Menika'));
    });

    test('9. malu (diri sendiri Krama Lugu Isin vs orang dihormati Lingsem vs aib Wirang)', () async {
      final selfShy = await expectFound('Saya malu', TranslationVariant.id, TranslationVariant.jvKrama);
      final motherShy = await expectFound('Ibu malu', TranslationVariant.id, TranslationVariant.jvKrama);
      final disgrace = await expectFound('Jangan buat malu', TranslationVariant.id, TranslationVariant.jvNgoko);

      expect(selfShy.text, equals('Kula Isin'));
      expect(motherShy.text, equals('Ibu Lingsem'));
      expect(disgrace.text, contains('Wirang'));
    });

    test('10. keras (suara nyaring vs benda padat vs bekerja sungguh-sungguh)', () async {
      final loudKrama = await expectFound('Suara keras', TranslationVariant.id, TranslationVariant.jvKrama);
      final loudEn = await expectFound('Suara keras', TranslationVariant.id, TranslationVariant.en);
      final solidKrama = await expectFound('Batu keras', TranslationVariant.id, TranslationVariant.jvKrama);
      final effortKrama = await expectFound('Saya bekerja keras', TranslationVariant.id, TranslationVariant.jvKrama);

      expect(loudKrama.text, endsWith('Sora'));
      expect(loudEn.text, endsWith('Loud'));
      expect(solidKrama.text, endsWith('Atos'));
      expect(effortKrama.text, equals('Kula Nyambut damel Estu'));
    });

    test('11. berat (bobot fisik vs tingkat keparahan)', () async {
      final heavyEn = await expectFound('Batu berat', TranslationVariant.id, TranslationVariant.en);
      final severeEn = await expectFound('Sakit berat', TranslationVariant.id, TranslationVariant.en);
      final severeKrama = await expectFound('Bapak sakit berat', TranslationVariant.id, TranslationVariant.jvKrama);

      expect(heavyEn.text, endsWith('Heavy'));
      expect(severeEn.text, endsWith('Severe'));
      expect(severeKrama.text, equals('Bapak Gerah Awrat'));
    });

    test('12. ringan (bobot fisik vs tingkat keparahan ringan)', () async {
      final lightEn = await expectFound('Baju ringan', TranslationVariant.id, TranslationVariant.en);
      final mildEn = await expectFound('Demam ringan', TranslationVariant.id, TranslationVariant.en);
      final mildKrama = await expectFound('Demam ringan', TranslationVariant.id, TranslationVariant.jvKrama);

      expect(lightEn.text, endsWith('Light'));
      expect(mildEn.text, endsWith('Mild'));
      expect(mildKrama.text, endsWith('Entheng'));
    });

    test('13. hati (perasaan diri/hormat vs organ ayam vs hati-hati)', () async {
      final selfHeart = await expectFound('Hati saya senang', TranslationVariant.id, TranslationVariant.jvKrama);
      final motherHeart = await expectFound('Hati Ibu senang', TranslationVariant.id, TranslationVariant.jvKrama);
      final organEn = await expectFound('Saya makan hati ayam', TranslationVariant.id, TranslationVariant.en);
      final carefulKrama = await expectFound('Hati-hati di jalan', TranslationVariant.id, TranslationVariant.jvKrama);

      expect(selfHeart.text, startsWith('Manah Kula'));
      expect(motherHeart.text, startsWith('Penggalih Ibu'));
      expect(organEn.text, contains('Liver'));
      expect(carefulKrama.text, contains('Margi'));
    });

    test('14. kepala (jabatan kepala sekolah vs anggota tubuh diri/hormat)', () async {
      final principalKrama = await expectFound('Kepala sekolah datang', TranslationVariant.id, TranslationVariant.jvKrama);
      final selfHead = await expectFound('Kepala saya pusing', TranslationVariant.id, TranslationVariant.jvKrama);
      final fatherHead = await expectFound('Kepala Bapak pusing', TranslationVariant.id, TranslationVariant.jvKrama);

      expect(principalKrama.text, startsWith('Pangarsa sekolah'));
      expect(principalKrama.text, isNot(contains('Mustaka')));
      expect(selfHead.text, equals('Sirah Kula Puyeng'));
      expect(fatherHead.text, equals('Mustaka Bapak Puyeng'));
    });

    test('15. tangan (anggota tubuh diri/hormat vs idiom buah tangan)', () async {
      final selfHand = await expectFound('Tangan saya bersih', TranslationVariant.id, TranslationVariant.jvKrama);
      final fatherHand = await expectFound('Tangan Bapak bersih', TranslationVariant.id, TranslationVariant.jvKrama);
      final souvenirKrama = await expectFound('Ibu membawa buah tangan', TranslationVariant.id, TranslationVariant.jvKrama);
      final souvenirEn = await expectFound('Ibu membawa buah tangan', TranslationVariant.id, TranslationVariant.en);

      expect(selfHand.text, equals('Tangan Kula Resik'));
      expect(fatherHand.text, equals('Asta Bapak Resik'));
      expect(souvenirKrama.text, equals('Ibu Ngasta Angsal-angsal'));
      expect(souvenirEn.text, endsWith('Souvenir'));
    });

    test('16. kaki (anggota tubuh diri/hormat vs kaki gunung & kaki meja)', () async {
      final selfFoot = await expectFound('Kaki saya sakit', TranslationVariant.id, TranslationVariant.jvKrama);
      final fatherFoot = await expectFound('Kaki Bapak sakit', TranslationVariant.id, TranslationVariant.jvKrama);
      final mountainFoot = await expectFound('Kaki gunung dingin', TranslationVariant.id, TranslationVariant.jvKrama);
      final tableLeg = await expectFound('Kaki meja kayu', TranslationVariant.id, TranslationVariant.jvKrama);

      expect(selfFoot.text, equals('Suku Kula sakit'));
      expect(fatherFoot.text, equals('Ampeyan Bapak Gerah'));
      expect(mountainFoot.text, startsWith('Suku redi'));
      expect(mountainFoot.text, isNot(contains('Ampeyan')));
      expect(tableLeg.text, startsWith('Suku meja'));
    });

    test('17. jalan (jalan raya vs aktivitas berjalan)', () async {
      final roadKrama = await expectFound('Saya tahu jalan ke pasar', TranslationVariant.id, TranslationVariant.jvKrama);
      final strollKrama = await expectFound('Ibu jalan jalan sore', TranslationVariant.id, TranslationVariant.jvKrama);
      final walkFather = await expectFound('Bapak sedang jalan', TranslationVariant.id, TranslationVariant.jvKrama);

      expect(roadKrama.text, equals('Kula Mangertos Margi dhateng Peken'));
      expect(strollKrama.text, startsWith('Ibu Mlampah-mlampah'));
      expect(walkFather.text, equals('Bapak nembe Tindak'));
    });

    test('18 & 19. tahu & bisa serta catatan ambiguitas jujur pada semua 19 kata tunggal', () async {
      const all19 = [
        'bulan', 'kali', 'bunga', 'pukul', 'tawar', 'jadi', 'jam', 'sore',
        'malu', 'keras', 'berat', 'ringan', 'hati', 'kepala', 'tangan',
        'kaki', 'jalan', 'tahu', 'bisa',
      ];
      for (final word in all19) {
        final res = await expectFound(word, TranslationVariant.id, TranslationVariant.jvKrama);
        expect(
          res.note,
          isNotNull,
          reason: 'Kata polisemi tunggal "$word" wajib menyertakan catatan ambiguitas jujur.',
        );
      }
    });
  });

  group('Phase 4 - Target 4: Translation Completeness Matrix', () {
    test('Matriks lengkap: tunggal, frasa, sederhana, kompleks, bertingkat, tanya, perintah, larangan, campuran, dua arah, 4 register', () async {
      // 1. Kata tunggal
      expect((await expectFound('Rumah', TranslationVariant.id, TranslationVariant.jvNgoko)).text, equals('Omah'));
      // 2. Frasa
      expect((await expectFound('Terima kasih', TranslationVariant.id, TranslationVariant.jvKrama)).text, equals('Matur nuwun'));
      // 3. Kalimat sederhana
      expect((await expectFound('Saya minum air', TranslationVariant.id, TranslationVariant.jvKrama)).text, equals('Kula Nginum Toya'));
      // 4. Kalimat kompleks (sebab-akibat / syarat)
      final complex = await expectFound(
        'Saya minum obat karena saya sakit',
        TranslationVariant.id,
        TranslationVariant.jvKrama,
      );
      expect(complex.text, equals('Kula Nginum Jampi amargi Kula sakit'));
      // 5. Kalimat bertingkat (multi-klausa dengan perpindahan subjek)
      final compound = await expectFound(
        'Ketika Bapak tidur saya belajar di rumah',
        TranslationVariant.id,
        TranslationVariant.jvKrama,
      );
      expect(compound.text, equals('Kala Bapak Sare Kula Sinau wonten Griya'));
      // 6. Pertanyaan
      final question = await expectFound(
        'Apakah Bapak sudah makan?',
        TranslationVariant.id,
        TranslationVariant.jvKrama,
      );
      expect(question.text, equals('punapa Bapak Sampun Dhahar'));
      // 7. Perintah sopan & ajakan
      final imperative = await expectFound(
        'Mari belajar di sekolah',
        TranslationVariant.id,
        TranslationVariant.jvKrama,
      );
      expect(imperative.text, equals('Mangga Sinau wonten Sekolah'));
      // 8. Larangan
      final prohibition = await expectFound(
        'Jangan pergi malam ini',
        TranslationVariant.id,
        TranslationVariant.jvNgoko,
      );
      expect(prohibition.text, equals('aja Lunga Bengi Iki'));
      // 9. Campuran kata dikenal & tak dikenal -> penanda [?] + catatan jujur
      final mixed = await expectFound(
        'Saya membeli gawai baru',
        TranslationVariant.id,
        TranslationVariant.jvKrama,
      );
      expect(mixed.text, contains('gawai[?]'));
      expect(mixed.note, isNotNull);
      expect(mixed.note!, contains('kamus offline'));
      // 10. Dua arah (ID <-> JV Ngoko, ID <-> JV Krama, ID <-> EN)
      expect((await expectFound('Kula Tilem', TranslationVariant.jvKrama, TranslationVariant.id)).text, equals('Saya Tidur'));
      expect((await expectFound('Aku Turu', TranslationVariant.jvNgoko, TranslationVariant.id)).text, equals('Saya Tidur'));
      expect((await expectFound('Good morning', TranslationVariant.en, TranslationVariant.jvKrama)).text, equals('Sugeng enjing'));
      // 11. Variasi 4 register eksplisit pada kata kerja relasional 'Memberi'
      expect((await expectFound('Memberi', TranslationVariant.id, TranslationVariant.jvNgoko)).text, equals('Menehi'));
      expect((await expectFound('Memberi', TranslationVariant.id, TranslationVariant.jvKrama, register: SpeechRegister.kramaLugu)).text, equals('Nyukani'));
      expect((await expectFound('Memberi', TranslationVariant.id, TranslationVariant.jvKrama, register: SpeechRegister.kramaInggil)).text, equals('Maringi'));
      expect((await expectFound('Memberi', TranslationVariant.id, TranslationVariant.jvKrama, register: SpeechRegister.kramaAndhap)).text, equals('Nyaosi'));
    });
  });

  group('Phase 4 - Target 5: Integritas Materi & 350 Soal Kuis', () {
    test('Total 350 soal (320 kurikuler + 30 adaptif) bebas kebocoran jawaban pada glyph', () {
      final curriculum = CurriculumQuizBank.allQuestions;
      final adaptive = [
        ...AdaptiveQuizBank.pemulaQuestions,
        ...AdaptiveQuizBank.menengahQuestions,
        ...AdaptiveQuizBank.mahirQuestions,
      ];
      expect(curriculum.length, equals(320));
      expect(adaptive.length, equals(30));
      expect(curriculum.length + adaptive.length, equals(350));

      for (final q in curriculum) {
        final answer = q.options[q.correctIndex];
        if (q.type == QuestionType.textToAksara) {
          expect(
            q.glyph,
            isEmpty,
            reason: 'Soal textToAksara ${q.id} tidak boleh membocorkan jawaban di field glyph.',
          );
        }
        if (q.glyph.isNotEmpty) {
          expect(
            q.glyph,
            isNot(equals(answer)),
            reason: 'Soal ${q.id} menampilkan glyph yang identik dengan kunci jawaban.',
          );
        }
      }
    });

    test('Penulisan aksara Jawa "Banyu" baku menggunakan ꦚ (ꦧꦚꦸ), bukan na+pengkal (ꦧꦤꦾꦸ)', () {
      final banyuVocab = VocabWord.sampleWords.firstWhere((w) => w.id == 'banyu');
      expect(banyuVocab.aksara, equals('ꦧꦚꦸ'));

      final banyuQuiz = AdaptiveQuizBank.menengahQuestions
          .firstWhere((q) => q.options[q.correctIndex] == 'Banyu');
      expect(banyuQuiz.glyph, equals('ꦧꦚꦸ'));
    });
  });
}
