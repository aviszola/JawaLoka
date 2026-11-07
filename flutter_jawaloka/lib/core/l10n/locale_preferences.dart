import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_locales.dart';

/// Abstract storage interface for language preferences.
abstract class LocalePreferences {
  static const String keyLocale = 'app_locale';
  static const String keyHasChosenLanguage = 'has_chosen_language';

  /// Loads the saved locale, falling back to [AppLocales.defaultLocale] if absent or invalid.
  Future<Locale> loadLocale();

  /// Saves the chosen locale.
  Future<void> saveLocale(Locale locale);

  /// Checks if the user has explicitly chosen a language onboarding option.
  Future<bool> hasChosenLanguage();

  /// Records whether the user has explicitly chosen a language onboarding option.
  Future<void> setHasChosenLanguage(bool value);
}

/// SharedPreferences implementation of [LocalePreferences].
class SharedPrefsLocalePreferences implements LocalePreferences {
  final Future<SharedPreferences> Function() _prefsProvider;

  SharedPrefsLocalePreferences({
    Future<SharedPreferences> Function()? prefsProvider,
  }) : _prefsProvider = prefsProvider ?? SharedPreferences.getInstance;

  @override
  Future<Locale> loadLocale() async {
    try {
      final prefs = await _prefsProvider();
      final raw = prefs.getString(LocalePreferences.keyLocale);
      return AppLocales.parse(raw);
    } catch (_) {
      return AppLocales.defaultLocale;
    }
  }

  @override
  Future<void> saveLocale(Locale locale) async {
    try {
      final prefs = await _prefsProvider();
      await prefs.setString(LocalePreferences.keyLocale, locale.languageCode);
    } catch (_) {
      // Fallback silently without throwing to preserve UI stability
    }
  }

  @override
  Future<bool> hasChosenLanguage() async {
    try {
      final prefs = await _prefsProvider();
      return prefs.getBool(LocalePreferences.keyHasChosenLanguage) ?? false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> setHasChosenLanguage(bool value) async {
    try {
      final prefs = await _prefsProvider();
      await prefs.setBool(LocalePreferences.keyHasChosenLanguage, value);
    } catch (_) {
      // Fallback silently without throwing to preserve UI stability
    }
  }
}

/// In-memory mock implementation of [LocalePreferences] for isolated tests.
class InMemoryLocalePreferences implements LocalePreferences {
  String? _rawLocale;
  bool _hasChosen;

  InMemoryLocalePreferences({
    String? initialLocale,
    bool initialHasChosen = false,
  })  : _rawLocale = initialLocale,
        _hasChosen = initialHasChosen;

  @override
  Future<Locale> loadLocale() async {
    return AppLocales.parse(_rawLocale);
  }

  @override
  Future<void> saveLocale(Locale locale) async {
    _rawLocale = locale.languageCode;
  }

  @override
  Future<bool> hasChosenLanguage() async {
    return _hasChosen;
  }

  @override
  Future<void> setHasChosenLanguage(bool value) async {
    _hasChosen = value;
  }

  /// Helper for testing corrupted values directly in memory.
  void setRawLocaleForTesting(String? value) {
    _rawLocale = value;
  }
}

