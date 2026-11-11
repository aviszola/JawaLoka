import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/core/profile/profile_controller.dart';
import 'package:flutter_jawaloka/core/profile/profile_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Butir 2: Streak Progression Unit Tests', () {
    test('1. Belum ada tanggal tersimpan: streak = 1', () async {
      DateTime now = DateTime(2026, 11, 10, 8, 0);
      final prefs = InMemoryProfilePreferences(
        initialStreakDays: 0,
        initialLastQuizDate: '',
        isFreshUser: true,
      );
      final ctrl = ProfileController(preferences: prefs, nowProvider: () => now);
      await ctrl.loadProfile();
      expect(ctrl.streakDays, 0);
      expect(ctrl.lastQuizDate, '');

      await ctrl.awardQuizSessionReward(
        activityId: 'path_node_u1_n01_salam',
        claimId: 'claim_1',
        correctAnswers: 5,
        isPerfect: false,
      );

      expect(ctrl.streakDays, 1);
      expect(ctrl.lastQuizDate, '2026-11-10');
    });

    test('2. Tanggal sama dua kali: streak tidak berubah', () async {
      DateTime now = DateTime(2026, 11, 10, 8, 0);
      final prefs = InMemoryProfilePreferences(
        initialStreakDays: 1,
        initialLastQuizDate: '2026-11-10',
      );
      final ctrl = ProfileController(preferences: prefs, nowProvider: () => now);
      await ctrl.loadProfile();

      await ctrl.awardQuizSessionReward(
        activityId: 'path_node_u1_n02_pamit',
        claimId: 'claim_2',
        correctAnswers: 5,
        isPerfect: false,
      );

      expect(ctrl.streakDays, 1);
      expect(ctrl.lastQuizDate, '2026-11-10');
    });

    test('3. Tepat +1 hari berikutnya: streak bertambah +1', () async {
      DateTime now = DateTime(2026, 11, 11, 9, 30);
      final prefs = InMemoryProfilePreferences(
        initialStreakDays: 1,
        initialLastQuizDate: '2026-11-10',
      );
      final ctrl = ProfileController(preferences: prefs, nowProvider: () => now);
      await ctrl.loadProfile();

      await ctrl.awardQuizSessionReward(
        activityId: 'path_node_u1_n03_tanya_kabar',
        claimId: 'claim_3',
        correctAnswers: 5,
        isPerfect: false,
      );

      expect(ctrl.streakDays, 2);
      expect(ctrl.lastQuizDate, '2026-11-11');
    });

    test('4. Selisih lebih dari 1 hari (lompat 5 hari): reset ke 1', () async {
      DateTime now = DateTime(2026, 11, 16, 10, 0); // 5 hari setelah 11-11
      final prefs = InMemoryProfilePreferences(
        initialStreakDays: 2,
        initialLastQuizDate: '2026-11-11',
      );
      final ctrl = ProfileController(preferences: prefs, nowProvider: () => now);
      await ctrl.loadProfile();

      await ctrl.awardQuizSessionReward(
        activityId: 'path_node_u1_n04_perkenalan',
        claimId: 'claim_4',
        correctAnswers: 5,
        isPerfect: false,
      );

      expect(ctrl.streakDays, 1);
      expect(ctrl.lastQuizDate, '2026-11-16');
    });

    test('5. Jam mundur (tanggal lebih lama dari tersimpan): streak dan tanggal tidak berubah', () async {
      DateTime now = DateTime(2026, 11, 9, 8, 0); // Mundur dari 11-10
      final prefs = InMemoryProfilePreferences(
        initialStreakDays: 3,
        initialLastQuizDate: '2026-11-10',
      );
      final ctrl = ProfileController(preferences: prefs, nowProvider: () => now);
      await ctrl.loadProfile();

      await ctrl.awardQuizSessionReward(
        activityId: 'path_node_u1_n05_sapa_wong',
        claimId: 'claim_5',
        correctAnswers: 5,
        isPerfect: false,
      );

      expect(ctrl.streakDays, 3);
      expect(ctrl.lastQuizDate, '2026-11-10');
    });

    test('6. Quest (Drawing Challenge) tidak menaikkan streak', () async {
      DateTime now = DateTime(2026, 11, 10, 8, 0);
      final prefs = InMemoryProfilePreferences(
        initialStreakDays: 0,
        initialLastQuizDate: '',
        isFreshUser: true,
      );
      final ctrl = ProfileController(preferences: prefs, nowProvider: () => now);
      await ctrl.loadProfile();

      await ctrl.awardDrawingChallengeReward(
        activityId: 'quest_ha',
        claimId: 'claim_quest',
        similarity: 0.95,
      );

      expect(ctrl.streakDays, 0);
      expect(ctrl.lastQuizDate, '');
    });
  });

  group('Butir 3: Batas Level Migrasi Unit Tests', () {
    test('Nilai legacyLevel ekstrem 999999999 dibatasi ke 100', () async {
      SharedPreferences.setMockInitialValues({
        ProfilePreferences.keyUserLevel: 999999999,
      });

      final prefs = SharedPrefsProfilePreferences();
      final totalXP = await prefs.loadTotalXP();
      final level = await prefs.loadUserLevel();

      // Level 100 = 4550 + (100 - 10) * 1000 = 94550 XP
      expect(level, 100);
      expect(totalXP, 94550);
    });
  });
}
