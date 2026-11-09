import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/core/validation/validation_result.dart';
import 'package:flutter_jawaloka/core/validation/validators.dart';

void main() {
  group('Validators - Display Name', () {
    test('returns empty error for empty or whitespace-only strings', () {
      expect(Validators.validateDisplayName('').errorOrNull, NameError.empty);
      expect(Validators.validateDisplayName('   ').errorOrNull, NameError.empty);
      expect(
        Validators.validateDisplayName('\u200B\u200C').errorOrNull,
        NameError.empty,
      );
    });

    test('returns tooShort for single-character input', () {
      expect(Validators.validateDisplayName('A').errorOrNull, NameError.tooShort);
      expect(
        Validators.validateDisplayName('  B  ').errorOrNull,
        NameError.tooShort,
      );
    });

    test('returns tooLong for strings exceeding 30 grapheme characters', () {
      final longName = 'A' * 31;
      expect(
        Validators.validateDisplayName(longName).errorOrNull,
        NameError.tooLong,
      );
    });

    test('validates and normalizes valid names and boundary lengths', () {
      final minRes = Validators.validateDisplayName('Ab');
      expect(minRes.isValid, isTrue);
      expect(minRes.valueOrNull, 'Ab');

      final maxName = 'A' * 30;
      final maxRes = Validators.validateDisplayName(maxName);
      expect(maxRes.isValid, isTrue);
      expect(maxRes.valueOrNull, maxName);

      // Normalization of multiple spaces and trimming
      final normRes = Validators.validateDisplayName('   Raden   Mas   Budi  ');
      expect(normRes.valueOrNull, 'Raden Mas Budi');

      // Valid special allowed characters: apostrophe, hyphen, period
      final allowedSpecial = Validators.validateDisplayName("Dr. Siti-Aminah O'Connor");
      expect(allowedSpecial.isValid, isTrue);
      expect(allowedSpecial.valueOrNull, "Dr. Siti-Aminah O'Connor");

      // Javanese script support
      final jvScript = Validators.validateDisplayName('ꦲꦤꦕꦫꦏ');
      expect(jvScript.isValid, isTrue);
      expect(jvScript.valueOrNull, 'ꦲꦤꦕꦫꦏ');
    });

    test('rejects digits, emoji, and prohibited symbols', () {
      expect(
        Validators.validateDisplayName('Budi123').errorOrNull,
        NameError.invalidChars,
      );
      expect(
        Validators.validateDisplayName('Budi 😊').errorOrNull,
        NameError.invalidChars,
      );
      expect(
        Validators.validateDisplayName('Budi@Domain').errorOrNull,
        NameError.invalidChars,
      );
      expect(
        Validators.validateDisplayName('Budi_Santoso').errorOrNull,
        NameError.invalidChars,
      );
    });
  });

  group('Validators - Email', () {
    test('returns empty error for empty input', () {
      expect(Validators.validateEmail('').errorOrNull, EmailError.empty);
      expect(Validators.validateEmail('   ').errorOrNull, EmailError.empty);
    });

    test('returns tooLong for emails exceeding 254 octets', () {
      final longEmail = '${'a' * 245}@example.com';
      expect(Validators.validateEmail(longEmail).errorOrNull, EmailError.tooLong);
    });

    test('validates valid emails and normalizes domain case', () {
      final res = Validators.validateEmail('User.Name@Example.COM');
      expect(res.isValid, isTrue);
      expect(res.valueOrNull, 'User.Name@example.com');
    });

    test('rejects invalid email formats', () {
      expect(
        Validators.validateEmail('plainaddress').errorOrNull,
        EmailError.invalidFormat,
      );
      expect(
        Validators.validateEmail('user@domain@extra.com').errorOrNull,
        EmailError.invalidFormat,
      );
      expect(
        Validators.validateEmail('user with spaces@domain.com').errorOrNull,
        EmailError.invalidFormat,
      );
      expect(
        Validators.validateEmail('user@domain').errorOrNull,
        EmailError.invalidFormat,
      );
      expect(
        Validators.validateEmail('user..name@domain.com').errorOrNull,
        EmailError.invalidFormat,
      );
      expect(
        Validators.validateEmail('.user@domain.com').errorOrNull,
        EmailError.invalidFormat,
      );
      expect(
        Validators.validateEmail('user.@domain.com').errorOrNull,
        EmailError.invalidFormat,
      );
      expect(
        Validators.validateEmail('user@.domain.com').errorOrNull,
        EmailError.invalidFormat,
      );
      expect(
        Validators.validateEmail('user@domain..com').errorOrNull,
        EmailError.invalidFormat,
      );
    });
  });

  group('Validators - Password', () {
    test('returns empty error for empty string', () {
      expect(Validators.validatePassword('').errorOrNull, PasswordError.empty);
    });

    test('returns whitespaceOnly error for spaces-only password', () {
      expect(
        Validators.validatePassword('        ').errorOrNull,
        PasswordError.whitespaceOnly,
      );
    });

    test('returns tooShort for passwords less than 8 characters', () {
      expect(
        Validators.validatePassword('1234567').errorOrNull,
        PasswordError.tooShort,
      );
    });

    test('returns tooLong for passwords exceeding 64 characters', () {
      final longPass = 'A' * 65;
      expect(
        Validators.validatePassword(longPass).errorOrNull,
        PasswordError.tooLong,
      );
    });

    test('accepts valid passwords and preserves exact spacing without trimming', () {
      final pass8 = '12345678';
      expect(Validators.validatePassword(pass8).valueOrNull, pass8);

      final pass64 = 'B' * 64;
      expect(Validators.validatePassword(pass64).valueOrNull, pass64);

      final spacedPass = ' secret password with spaces ';
      final res = Validators.validatePassword(spacedPass);
      expect(res.isValid, isTrue);
      expect(res.valueOrNull, spacedPass);
    });
  });

  group('Validators - Translation Input', () {
    test('returns empty for empty or whitespace-only input', () {
      expect(
        Validators.validateTranslationInput('').errorOrNull,
        TranslationInputError.empty,
      );
      expect(
        Validators.validateTranslationInput('   ').errorOrNull,
        TranslationInputError.empty,
      );
    });

    test('returns tooLong for input exceeding 200 characters', () {
      final longText = 'A' * 201;
      expect(
        Validators.validateTranslationInput(longText).errorOrNull,
        TranslationInputError.tooLong,
      );
    });

    test('accepts valid translation input and trims', () {
      final text200 = 'A' * 200;
      final res = Validators.validateTranslationInput('  $text200  ');
      expect(res.isValid, isTrue);
      expect(res.valueOrNull, text200);
    });
  });

  group('Validators - Quest Strokes', () {
    test('returns empty for empty strokes list', () {
      expect(
        Validators.validateQuestStrokes([]).errorOrNull,
        QuestDrawingError.empty,
      );
      expect(
        Validators.validateQuestStrokes([[]]).errorOrNull,
        QuestDrawingError.empty,
      );
    });

    test('returns invalidCoordinates for NaN or Infinite coordinates', () {
      final strokeWithNan = [
        [const Offset(0, 0), const Offset(double.nan, 10)],
      ];
      expect(
        Validators.validateQuestStrokes(strokeWithNan).errorOrNull,
        QuestDrawingError.invalidCoordinates,
      );

      final strokeWithInf = [
        [const Offset(0, 0), const Offset(10, double.infinity)],
      ];
      expect(
        Validators.validateQuestStrokes(strokeWithInf).errorOrNull,
        QuestDrawingError.invalidCoordinates,
      );
    });

    test('returns tooShort for strokes shorter than minTotalLength', () {
      final shortStroke = [
        [const Offset(10, 10), const Offset(15, 10)], // distance = 5.0
      ];
      expect(
        Validators.validateQuestStrokes(shortStroke, minTotalLength: 20.0).errorOrNull,
        QuestDrawingError.tooShort,
      );
    });

    test('accepts valid strokes with total length >= minTotalLength', () {
      final validStroke = [
        [const Offset(10, 10), const Offset(40, 10)], // distance = 30.0
      ];
      final res = Validators.validateQuestStrokes(validStroke, minTotalLength: 20.0);
      expect(res.isValid, isTrue);
      expect(res.valueOrNull, validStroke);
    });
  });

  group('Validators - Storage Sanitizers', () {
    test('sanitizeStoredInt correctly parses, clamps, and falls back', () {
      expect(Validators.sanitizeStoredInt(100), 100);
      expect(Validators.sanitizeStoredInt('250'), 250);
      expect(Validators.sanitizeStoredInt(-10, min: 0), 0);
      expect(Validators.sanitizeStoredInt(100, max: 50), 50);
      expect(Validators.sanitizeStoredInt('invalid', fallback: 42), 42);
      expect(Validators.sanitizeStoredInt(null, fallback: 5), 5);
      expect(Validators.sanitizeStoredInt(['wrong_type'], fallback: 7), 7);
    });

    test('sanitizeStoredString trims, checks whitelist, and falls back', () {
      expect(Validators.sanitizeStoredString('  hello  '), 'hello');
      expect(Validators.sanitizeStoredString(123, fallback: 'default'), 'default');
      expect(
        Validators.sanitizeStoredString(
          'surakarta',
          allowed: {'yogyakarta', 'surakarta'},
        ),
        'surakarta',
      );
      expect(
        Validators.sanitizeStoredString(
          'unknown_blangkon',
          allowed: {'yogyakarta', 'surakarta'},
          fallback: 'yogyakarta',
        ),
        'yogyakarta',
      );
    });

    test('sanitizeStoredDate validates format and calendar correctness', () {
      expect(Validators.sanitizeStoredDate('2026-05-15'), '2026-05-15');
      expect(Validators.sanitizeStoredDate(' 2026-05-15 '), '2026-05-15');
      expect(Validators.sanitizeStoredDate('2026/05/15'), '');
      expect(Validators.sanitizeStoredDate('invalid-date'), '');
      expect(Validators.sanitizeStoredDate(null), '');
      // Non-existent calendar date (February 31)
      expect(Validators.sanitizeStoredDate('2026-02-31'), '');
    });
  });
}
