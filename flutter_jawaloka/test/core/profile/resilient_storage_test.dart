import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_jawaloka/core/l10n/app_locales.dart';
import 'package:flutter_jawaloka/core/l10n/locale_preferences.dart';
import 'package:flutter_jawaloka/core/profile/profile_preferences.dart';
import 'package:flutter_jawaloka/features/profile/presentation/widgets/blangkon_painter.dart';

void main() {
  group('Resilient Storage - SharedPrefsProfilePreferences', () {
    test('handles corrupted and type-mismatched keys without throwing', () async {
      SharedPreferences.setMockInitialValues({
        ProfilePreferences.keyTotalXP: 'not_an_int',
        ProfilePreferences.keyUserLevel: -99,
        ProfilePreferences.keyDisplayName: 'Invalid123Name',
        ProfilePreferences.keyEquippedBlangkon: 'alien_blangkon',
        ProfilePreferences.keyDailyPracticeDate: '2026-02-31', // Invalid calendar date
        ProfilePreferences.keyDailyPracticeXP: true,
        ProfilePreferences.keyStreakDays: 'corrupted',
        ProfilePreferences.keyCompletedQuizDays: 'not_a_list',
        ProfilePreferences.keyQuizzesThisWeek: <String>['wrong'],
        ProfilePreferences.keyUnlockedBlangkons: 42,
        ProfilePreferences.keyLastCelebratedLevel: 999,
      });

      final prefs = SharedPrefsProfilePreferences();

      // Total XP should safely fall back to 0
      final totalXP = await prefs.loadTotalXP();
      expect(totalXP, 0);

      // User level should be computed from totalXP (0 XP => Level 1)
      final userLevel = await prefs.loadUserLevel();
      expect(userLevel, 1);

      // Display name should reject invalid chars and fall back to Dimas
      final name = await prefs.loadDisplayName();
      expect(name, 'Dimas');

      // Equipped blangkon should fall back to yogyakarta
      final equipped = await prefs.loadEquippedBlangkon();
      expect(equipped, BlangkonType.yogyakarta);

      // Daily practice record should reject invalid date
      final record = await prefs.loadDailyPracticeRecord();
      expect(record.date, '');
      expect(record.xp, 0);

      // Unlocked blangkons must always include yogyakarta
      final unlocked = await prefs.loadUnlockedBlangkons();
      expect(unlocked.contains(BlangkonType.yogyakarta), isTrue);

      // Last celebrated level should be clamped to current user level (1)
      final lastCelebrated = await prefs.loadLastCelebratedLevel();
      expect(lastCelebrated, 1);
    });

    test('fallback to yogyakarta when equipped blangkon is not in unlocked set', () async {
      // User is Level 1, but storage claims equipped blangkon is pusaka or cirebon
      SharedPreferences.setMockInitialValues({
        ProfilePreferences.keyTotalXP: 0,
        ProfilePreferences.keyEquippedBlangkon: 'cirebon',
      });

      final prefs = SharedPrefsProfilePreferences();
      final equipped = await prefs.loadEquippedBlangkon();
      expect(equipped, BlangkonType.yogyakarta);
    });

    test('always includes level-earned blangkons in loadUnlockedBlangkons', () async {
      // User has 1050 XP (Level 5 => surakarta should be unlocked)
      SharedPreferences.setMockInitialValues({
        ProfilePreferences.keyTotalXP: 1050,
        ProfilePreferences.keyUnlockedBlangkons: <String>['yogyakarta'],
      });

      final prefs = SharedPrefsProfilePreferences();
      final unlocked = await prefs.loadUnlockedBlangkons();
      expect(unlocked.contains(BlangkonType.yogyakarta), isTrue);
      expect(unlocked.contains(BlangkonType.surakarta), isTrue);
    });
  });

  group('Resilient Storage - SharedPrefsLocalePreferences', () {
    test('handles corrupted locale and flag types gracefully', () async {
      SharedPreferences.setMockInitialValues({
        LocalePreferences.keyLocale: 12345, // Not a string
        LocalePreferences.keyHasChosenLanguage: 'invalid_boolean',
      });

      final prefs = SharedPrefsLocalePreferences();

      final locale = await prefs.loadLocale();
      expect(locale, AppLocales.defaultLocale);

      final hasChosen = await prefs.hasChosenLanguage();
      expect(hasChosen, isFalse);
    });

    test('loads valid locale and boolean string correctly', () async {
      SharedPreferences.setMockInitialValues({
        LocalePreferences.keyLocale: 'jv',
        LocalePreferences.keyHasChosenLanguage: 'true',
      });

      final prefs = SharedPrefsLocalePreferences();

      final locale = await prefs.loadLocale();
      expect(locale, const Locale('jv'));

      final hasChosen = await prefs.hasChosenLanguage();
      expect(hasChosen, isTrue);
    });
  });
}
