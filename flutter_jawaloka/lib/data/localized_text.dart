import 'package:flutter/material.dart';

/// Immutable model representing multilingual text in Indonesian, Javanese, and English.
///
/// Designed to be const-friendly and provide safe fallback resolution.
@immutable
class LocalizedText {
  final String id;
  final String jv;
  final String en;

  const LocalizedText({
    required this.id,
    this.jv = '',
    this.en = '',
  });

  /// Resolves the text according to the provided [locale].
  ///
  /// Fallback strategy:
  /// 1. Resolves requested language code if non-empty.
  /// 2. Falls back to Indonesian ([id]) if available.
  /// 3. Falls back to the first available non-empty translation.
  /// 4. Returns empty string if all translations are blank.
  String resolve(Locale locale) {
    final code = locale.languageCode.toLowerCase();

    if (code == 'id' && id.isNotEmpty) {
      return id;
    }
    if ((code == 'jv' || code == 'jw') && jv.isNotEmpty) {
      return jv;
    }
    if (code == 'en' && en.isNotEmpty) {
      return en;
    }

    // Fallback 1: Indonesian
    if (id.isNotEmpty) {
      return id;
    }

    // Fallback 2: First non-empty
    if (jv.isNotEmpty) return jv;
    if (en.isNotEmpty) return en;

    return '';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocalizedText &&
        other.id == id &&
        other.jv == jv &&
        other.en == en;
  }

  @override
  int get hashCode => Object.hash(id, jv, en);

  @override
  String toString() => 'LocalizedText(id: "$id", jv: "$jv", en: "$en")';
}

