import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/features/translator/data/offline_dictionary_service.dart';
import 'package:flutter_jawaloka/features/translator/domain/translation_models.dart';

void main() {
  const service = OfflineDictionaryService();

  group('Verifikasi Terjemahan Kalimat Probe (Bebas Kata Jawa di Keluaran ID)', () {
    test('1. ngoko ke id: "Aku arep tuku buku" -> "Saya Akan Membeli Buku"', () async {
      final res = await service.translate(
        text: 'Aku arep tuku buku',
        from: TranslationVariant.jvNgoko,
        to: TranslationVariant.id,
      );
      expect(res, isA<Found>());
      final text = (res as Found).text;
      expect(text, equals('Saya Akan Membeli Buku'));
      expect(text.contains('arep'), isFalse);
    });

    test('2. ngoko ke id: "Omahe adoh" -> "Rumah-nya Jauh"', () async {
      final res = await service.translate(
        text: 'Omahe adoh',
        from: TranslationVariant.jvNgoko,
        to: TranslationVariant.id,
      );
      expect(res, isA<Found>());
      final text = (res as Found).text;
      expect(text, equals('Rumah-nya Jauh'));
      expect(text.contains('adoh'), isFalse);
    });

    test('3. ngoko ke id: "Aku arep mangan sega" -> "Saya Akan Makan Nasi"', () async {
      final res = await service.translate(
        text: 'Aku arep mangan sega',
        from: TranslationVariant.jvNgoko,
        to: TranslationVariant.id,
      );
      expect(res, isA<Found>());
      final text = (res as Found).text;
      expect(text, equals('Saya Akan Makan Nasi'));
      expect(text.contains('arep'), isFalse);
      expect(text.contains('mangan'), isFalse);
      expect(text.contains('sega'), isFalse);
    });

    test('4. krama ke id: "Kula badhe tumbas buku" -> "Saya Akan Membeli Buku"', () async {
      final res = await service.translate(
        text: 'Kula badhe tumbas buku',
        from: TranslationVariant.jvKrama,
        to: TranslationVariant.id,
      );
      expect(res, isA<Found>());
      final text = (res as Found).text;
      expect(text, equals('Saya Akan Membeli Buku'));
      expect(text.contains('badhe'), isFalse);
    });

    test('5. krama ke id: "Griya kula tebih" -> "Rumah Saya Jauh"', () async {
      final res = await service.translate(
        text: 'Griya kula tebih',
        from: TranslationVariant.jvKrama,
        to: TranslationVariant.id,
      );
      expect(res, isA<Found>());
      final text = (res as Found).text;
      expect(text, equals('Rumah Saya Jauh'));
      expect(text.contains('tebih'), isFalse);
    });

    test('6. id ke ngoko: "Saya mau makan nasi" -> "Aku Gelem Mangan Sega"', () async {
      final res = await service.translate(
        text: 'Saya mau makan nasi',
        from: TranslationVariant.id,
        to: TranslationVariant.jvNgoko,
      );
      expect(res, isA<Found>());
      final text = (res as Found).text;
      expect(text, equals('Aku Gelem Mangan Sega'));
    });

    test('7. id ke ngoko: "Rumah saya jauh" -> "Omah Aku Adoh"', () async {
      final res = await service.translate(
        text: 'Rumah saya jauh',
        from: TranslationVariant.id,
        to: TranslationVariant.jvNgoko,
      );
      expect(res, isA<Found>());
      final text = (res as Found).text;
      expect(text, equals('Omah Aku Adoh'));
    });

    test('8. id ke ngoko: "Berapa harga buku ini?" -> "Piro Rega Buku Iki"', () async {
      final res = await service.translate(
        text: 'Berapa harga buku ini?',
        from: TranslationVariant.id,
        to: TranslationVariant.jvNgoko,
      );
      expect(res, isA<Found>());
      final text = (res as Found).text;
      expect(text, equals('Piro Rega Buku Iki'));
      expect(text.contains('[?]'), isFalse);
    });
  });
}
