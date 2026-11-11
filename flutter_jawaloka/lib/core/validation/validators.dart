import 'package:flutter/widgets.dart';
import 'validation_result.dart';

/// Pure Dart centralized validator functions and storage sanitizers.
/// Free of Flutter widget hierarchy and BuildContext dependencies.
class Validators {
  Validators._();

  // ──────────────────────────────────────────────────────────────────────────
  // Display Name Validator
  // ──────────────────────────────────────────────────────────────────────────

  /// Strips control characters (C0, C1) and zero-width/BOM characters.
  static final RegExp _controlAndZeroWidth = RegExp(
    r'[\x00-\x1F\x7F-\x9F\u200B-\u200D\uFEFF]',
  );

  /// Collapses consecutive whitespace characters into a single space.
  static final RegExp _multipleSpaces = RegExp(r'\s+');

  /// Allowed name characters: Unicode letters (\p{L}), combining marks (\p{M}),
  /// single spaces, apostrophes (' and ’), hyphens (-), and periods (.).
  /// Digits (\p{N}), emoji, and symbols are strictly disallowed.
  static final RegExp _validNameChars = RegExp(
    r"^[\p{L}\p{M} '\-\.\u2019]+$",
    unicode: true,
  );

  /// Validates and normalizes user display name.
  ///
  /// Normalization steps:
  /// 1. Trim leading and trailing whitespace.
  /// 2. Remove control characters and zero-width code points.
  /// 3. Collapse multiple spaces into a single space.
  /// 4. Verify length: 2 to 30 characters (counted by user-perceived graphemes).
  /// 5. Verify character set: Unicode letters (including Javanese script and Latin
  ///    diacritics), combining marks, spaces, hyphens, periods, and apostrophes.
  static ValidationResult<String, NameError> validateDisplayName(String raw) {
    var cleaned = raw.replaceAll(_controlAndZeroWidth, '');
    cleaned = cleaned.replaceAll(_multipleSpaces, ' ').trim();

    if (cleaned.isEmpty) {
      return const Invalid(NameError.empty);
    }

    final charCount = cleaned.characters.length;
    if (charCount < 2) {
      return const Invalid(NameError.tooShort);
    }
    if (charCount > 30) {
      return const Invalid(NameError.tooLong);
    }

    if (!_validNameChars.hasMatch(cleaned)) {
      return const Invalid(NameError.invalidChars);
    }

    return Valid(cleaned);
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Email Validator
  // ──────────────────────────────────────────────────────────────────────────

  /// Validates and normalizes email address per RFC 5321 length and syntax rules.
  /// Never performs network DNS lookups.
  /// Returns normalized email with lowercased domain.
  static ValidationResult<String, EmailError> validateEmail(String raw) {
    final trimmed = raw.trim();

    if (trimmed.isEmpty) {
      return const Invalid(EmailError.empty);
    }

    // RFC 5321 section 4.5.3.1.3: maximum path length is 254 octets
    if (trimmed.length > 254) {
      return const Invalid(EmailError.tooLong);
    }

    // No whitespace permitted inside email
    if (trimmed.contains(RegExp(r'\s'))) {
      return const Invalid(EmailError.invalidFormat);
    }

    // Exactly one '@' sign
    final atIndex = trimmed.indexOf('@');
    if (atIndex <= 0 || atIndex != trimmed.lastIndexOf('@')) {
      return const Invalid(EmailError.invalidFormat);
    }

    final localPart = trimmed.substring(0, atIndex);
    final domainPart = trimmed.substring(atIndex + 1);

    if (localPart.isEmpty || domainPart.isEmpty) {
      return const Invalid(EmailError.invalidFormat);
    }

    // Local part constraints: no leading/trailing dot, no consecutive dots
    if (localPart.startsWith('.') ||
        localPart.endsWith('.') ||
        localPart.contains('..')) {
      return const Invalid(EmailError.invalidFormat);
    }

    // Domain part constraints: must have at least one dot, cannot start/end with dot, no consecutive dots
    if (!domainPart.contains('.') ||
        domainPart.startsWith('.') ||
        domainPart.endsWith('.') ||
        domainPart.contains('..')) {
      return const Invalid(EmailError.invalidFormat);
    }

    final domainLabels = domainPart.split('.');
    for (final label in domainLabels) {
      if (label.isEmpty) {
        return const Invalid(EmailError.invalidFormat);
      }
    }

    final normalized = '$localPart@${domainPart.toLowerCase()}';
    return Valid(normalized);
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Password Validator
  // ──────────────────────────────────────────────────────────────────────────

  /// Validates password without trimming.
  /// Enforces length 8-64 and rejects whitespace-only passwords.
  static ValidationResult<String, PasswordError> validatePassword(String raw) {
    if (raw.isEmpty) {
      return const Invalid(PasswordError.empty);
    }

    if (raw.trim().isEmpty) {
      return const Invalid(PasswordError.whitespaceOnly);
    }

    if (raw.length < 8) {
      return const Invalid(PasswordError.tooShort);
    }

    if (raw.length > 64) {
      return const Invalid(PasswordError.tooLong);
    }

    return Valid(raw);
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Translation Input Validator
  // ──────────────────────────────────────────────────────────────────────────

  /// Validates and normalizes translator input text.
  /// Strips control characters, trims whitespace, and limits length to 200 characters.
  static ValidationResult<String, TranslationInputError>
  validateTranslationInput(String raw) {
    final cleaned = raw.replaceAll(_controlAndZeroWidth, '').trim();

    if (cleaned.isEmpty) {
      return const Invalid(TranslationInputError.empty);
    }

    if (cleaned.characters.length > 200) {
      return const Invalid(TranslationInputError.tooLong);
    }

    return Valid(cleaned);
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Quest Drawing Strokes Validator
  // ──────────────────────────────────────────────────────────────────────────

  /// Validates canvas drawing strokes before evaluating similarity.
  /// Rejects empty submissions, NaN/Infinite coordinates, and sub-threshold strokes.
  static ValidationResult<List<List<Offset>>, QuestDrawingError>
  validateQuestStrokes(
    List<List<Offset>> strokes, {
    // PERLU KEPUTUSAN: Ambang batas goresan minimum (20.0 logical pixels)
    double minTotalLength = 20.0,
  }) {
    if (strokes.isEmpty) {
      return const Invalid(QuestDrawingError.empty);
    }

    double totalLength = 0.0;
    int pointCount = 0;

    for (final stroke in strokes) {
      if (stroke.isEmpty) continue;
      for (int i = 0; i < stroke.length; i++) {
        final pt = stroke[i];
        if (pt.dx.isNaN ||
            pt.dx.isInfinite ||
            pt.dy.isNaN ||
            pt.dy.isInfinite) {
          return const Invalid(QuestDrawingError.invalidCoordinates);
        }
        pointCount++;
        if (i > 0) {
          totalLength += (pt - stroke[i - 1]).distance;
        }
      }
    }

    if (pointCount == 0) {
      return const Invalid(QuestDrawingError.empty);
    }

    if (totalLength < minTotalLength) {
      return const Invalid(QuestDrawingError.tooShort);
    }

    return Valid(strokes);
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Storage Sanitization Helpers (Resilient Persistence)
  // ──────────────────────────────────────────────────────────────────────────

  /// Safely sanitizes integer stored values with boundary clamping.
  static int sanitizeStoredInt(
    Object? raw, {
    int min = 0,
    int max = 10000000,
    int fallback = 0,
  }) {
    int value;
    if (raw is int) {
      value = raw;
    } else if (raw is String) {
      value = int.tryParse(raw) ?? fallback;
    } else {
      return fallback;
    }
    return value.clamp(min, max);
  }

  /// Safely sanitizes string stored values with optional whitelist filtering.
  static String sanitizeStoredString(
    Object? raw, {
    Set<String>? allowed,
    String fallback = '',
  }) {
    if (raw is! String) return fallback;
    final trimmed = raw.trim();
    if (allowed != null && !allowed.contains(trimmed)) {
      return fallback;
    }
    return trimmed;
  }

  /// Safely parses and validates YYYY-MM-DD stored date strings.
  static String sanitizeStoredDate(Object? raw) {
    if (raw is! String) return '';
    final str = raw.trim();
    final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dateRegex.hasMatch(str)) return '';

    final parsed = DateTime.tryParse(str);
    if (parsed == null) return '';

    // Verify roundtrip to reject invalid calendar days like 2026-02-31
    final y = parsed.year.toString().padLeft(4, '0');
    final m = parsed.month.toString().padLeft(2, '0');
    final d = parsed.day.toString().padLeft(2, '0');
    if ('$y-$m-$d' != str) return '';

    return str;
  }
}
