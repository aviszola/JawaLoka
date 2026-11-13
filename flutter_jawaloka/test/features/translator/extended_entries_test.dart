import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/data/translation_entries.dart';
import 'package:flutter_jawaloka/data/translation_entries_extended.dart';
import 'package:flutter_jawaloka/features/translator/data/offline_dictionary_service.dart';
import 'package:flutter_jawaloka/features/translator/domain/translation_models.dart';

void main() {
  const service = OfflineDictionaryService();

  group('Extended Dictionary Entries Integrity', () {
    test('id, en, jvNgoko, jvKrama tidak kosong', () {
      for (final entry in kAllTranslationEntries) {
        expect(entry.id.trim(), isNotEmpty, reason: 'id kosong');
        expect(entry.en.trim(), isNotEmpty, reason: 'en kosong');
        expect(entry.jvNgoko.trim(), isNotEmpty, reason: 'jvNgoko kosong');
        expect(entry.jvKrama.trim(), isNotEmpty, reason: 'jvKrama kosong');
      }
    });

    test('id unik (case-insensitive)', () {
      final ids = <String>{};
      for (final entry in kAllTranslationEntries) {
        final norm = entry.id.trim().toLowerCase();
        expect(ids.contains(norm), isFalse,
            reason: 'ID duplikat: ${entry.id}');
        ids.add(norm);
      }
    });

    test('en unik (case-insensitive)', () {
      final ens = <String>{};
      for (final entry in kAllTranslationEntries) {
        final norm = entry.en.trim().toLowerCase();
        expect(ens.contains(norm), isFalse,
            reason: 'English duplikat: ${entry.en}');
        ens.add(norm);
      }
    });

    test('jvNgoko unik (case-insensitive)', () {
      final ngokos = <String>{};
      for (final entry in kAllTranslationEntries) {
        final norm = entry.jvNgoko.trim().toLowerCase();
        expect(ngokos.contains(norm), isFalse,
            reason: 'jvNgoko duplikat: ${entry.jvNgoko}');
        ngokos.add(norm);
      }
    });

    test('jvKrama unik (case-insensitive)', () {
      final kramas = <String>{};
      for (final entry in kAllTranslationEntries) {
        final norm = entry.jvKrama.trim().toLowerCase();
        expect(kramas.contains(norm), isFalse,
            reason: 'jvKrama duplikat: ${entry.jvKrama}');
        kramas.add(norm);
      }
    });

    test('terjemahan dua arah antar keempat varian tepat sama untuk entri tambahan', () async {
      final variants = TranslationVariant.values;
      for (final entry in kExtendedTranslationEntries) {
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
              reason:
                  'Gagal menerjemahkan "$sourceText" dari $from ke $to',
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
    });

    test('jumlah entri tambahan lebih dari 0', () {
      expect(kExtendedTranslationEntries.length, greaterThan(0));
    });
  });
}
