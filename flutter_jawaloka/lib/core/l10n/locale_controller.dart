import 'package:flutter/material.dart';
import 'app_locales.dart';
import 'locale_preferences.dart';

/// Controller managing application locale state.
///
/// Uses [ChangeNotifier] to trigger UI updates via [ListenableBuilder] without
/// depending on external third-party state management libraries.
class LocaleController extends ChangeNotifier {
  final LocalePreferences _preferences;

  Locale _locale = AppLocales.defaultLocale;
  bool _hasChosenLanguage = false;
  bool _isInitialized = false;

  LocaleController({LocalePreferences? preferences})
      : _preferences = preferences ?? SharedPrefsLocalePreferences();

  Locale get locale => _locale;
  bool get hasChosenLanguage => _hasChosenLanguage;
  bool get isInitialized => _isInitialized;

  /// Loads saved locale and choice status from storage.
  Future<void> loadSavedLocale() async {
    final savedLocale = await _preferences.loadLocale();
    final chosen = await _preferences.hasChosenLanguage();

    _locale = savedLocale;
    _hasChosenLanguage = chosen;
    _isInitialized = true;
    notifyListeners();
  }

  /// Updates current locale, persists choice, and notifies listeners.
  Future<void> setLocale(Locale newLocale) async {
    final parsed = AppLocales.parse(newLocale.languageCode);
    if (_locale == parsed) return;

    _locale = parsed;
    notifyListeners();
    await _preferences.saveLocale(parsed);
  }

  /// Marks that the user has completed language selection.
  Future<void> markLanguageChosen() async {
    if (_hasChosenLanguage) return;

    _hasChosenLanguage = true;
    notifyListeners();
    await _preferences.setHasChosenLanguage(true);
  }
}

