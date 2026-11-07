import 'package:flutter/material.dart';

/// App Locales configuration for JawaLoka.
class AppLocales {
  AppLocales._();

  /// Default application locale: Indonesian (Bahasa Indonesia).
  static const Locale defaultLocale = Locale('id');

  /// Supported locales: Indonesian (id), Javanese (jv), and English (en).
  static const List<Locale> supportedLocales = [
    Locale('id'),
    Locale('jv'),
    Locale('en'),
  ];

  /// Endonyms: strictly written in their own language and never translated.
  static const Map<String, String> endonyms = {
    'id': 'Bahasa Indonesia',
    'jv': 'Basa Jawa',
    'en': 'English',
  };

  /// Returns the endonym for a given language code.
  static String endonymOf(String languageCode) {
    return endonyms[languageCode] ?? endonyms['id']!;
  }

  /// Normalizes and parses a raw stored language string into a supported [Locale].
  /// Maps legacy code 'jw' to 'jv'. Corrupted or unrecognized values fall back to [defaultLocale].
  static Locale parse(String? rawCode) {
    if (rawCode == null || rawCode.trim().isEmpty) {
      return defaultLocale;
    }
    final normalized = rawCode.trim().toLowerCase();
    if (normalized == 'jw' || normalized == 'jv') {
      return const Locale('jv');
    }
    if (normalized == 'en') {
      return const Locale('en');
    }
    if (normalized == 'id') {
      return const Locale('id');
    }
    return defaultLocale;
  }
}

