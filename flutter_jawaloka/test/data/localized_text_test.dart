import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/data/localized_text.dart';

void main() {
  group('LocalizedText Unit Tests', () {
    const text = LocalizedText(
      id: 'Rumah',
      jv: 'Omah',
      en: 'House',
    );

    test('resolves directly for all supported locales', () {
      expect(text.resolve(const Locale('id')), 'Rumah');
      expect(text.resolve(const Locale('jv')), 'Omah');
      expect(text.resolve(const Locale('en')), 'House');
      expect(text.resolve(const Locale('jw')), 'Omah'); // Legacy code compatibility
    });

    test('falls back to Indonesian when requested translation is empty', () {
      const partial = LocalizedText(
        id: 'Air',
        jv: 'Banyu',
        en: '', // English missing
      );

      expect(partial.resolve(const Locale('en')), 'Air');
      expect(partial.resolve(const Locale('fr')), 'Air');
    });

    test('falls back to first non-empty when Indonesian is empty', () {
      const fallback = LocalizedText(
        id: '',
        jv: 'Segara',
        en: 'Sea',
      );

      expect(fallback.resolve(const Locale('id')), 'Segara');
      expect(fallback.resolve(const Locale('de')), 'Segara');
    });

    test('returns empty string if all variants are empty', () {
      const blank = LocalizedText(id: '');
      expect(blank.resolve(const Locale('id')), '');
      expect(blank.resolve(const Locale('jv')), '');
      expect(blank.resolve(const Locale('en')), '');
    });

    test('supports equality and hashcode comparison', () {
      const a = LocalizedText(id: 'Satu', jv: 'Siji', en: 'One');
      const b = LocalizedText(id: 'Satu', jv: 'Siji', en: 'One');
      const c = LocalizedText(id: 'Dua', jv: 'Loro', en: 'Two');

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
      expect(a, isNot(equals(c)));
    });
  });
}

