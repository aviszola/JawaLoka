import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/core/profile/profile_controller.dart';
import 'package:flutter_jawaloka/core/profile/profile_preferences.dart';
import 'package:flutter_jawaloka/core/profile/blangkon_rewards.dart';
import 'package:flutter_jawaloka/core/progression/progression_engine.dart';
import 'package:flutter_jawaloka/core/progression/reward_summary.dart';
import 'package:flutter_jawaloka/features/profile/presentation/widgets/blangkon_painter.dart';

void main() {
  group('XP, Streak, and Level Comprehensive Verification', () {
    test('1. XP Progression & Level Calculation Boundaries', () {
      // Level 1: 0 - 149
      expect(ProgressionEngine.calculateLevel(0), equals(1));
      expect(ProgressionEngine.calculateLevel(149), equals(1));
      expect(ProgressionEngine.getTier(1), equals(ProgressionTier.pemula));
      expect(ProgressionEngine.getXpToNextLevel(0), equals(150));
      expect(ProgressionEngine.getXpToNextLevel(100), equals(50));
      expect(ProgressionEngine.getLevelProgress(75), closeTo(0.5, 0.001));

      // Level 2: 150 - 349
      expect(ProgressionEngine.calculateLevel(150), equals(2));
      expect(ProgressionEngine.calculateLevel(349), equals(2));
      expect(ProgressionEngine.getTier(2), equals(ProgressionTier.pemula));
      expect(ProgressionEngine.getXpToNextLevel(150), equals(200));

      // Level 3: 350 - 649
      expect(ProgressionEngine.calculateLevel(350), equals(3));
      expect(ProgressionEngine.calculateLevel(649), equals(3));
      expect(ProgressionEngine.getTier(3), equals(ProgressionTier.pemula));

      // Level 4: 650 - 1049 (Menengah Tier)
      expect(ProgressionEngine.calculateLevel(650), equals(4));
      expect(ProgressionEngine.calculateLevel(1049), equals(4));
      expect(ProgressionEngine.getTier(4), equals(ProgressionTier.menengah));

      // Level 5: 1050 - 1549 (Surakarta unlock)
      expect(ProgressionEngine.calculateLevel(1050), equals(5));
      expect(ProgressionEngine.getTier(5), equals(ProgressionTier.menengah));

      // Level 6: 1550 - 2149 (Sunda unlock)
      expect(ProgressionEngine.calculateLevel(1550), equals(6));
      expect(ProgressionEngine.getTier(6), equals(ProgressionTier.menengah));

      // Level 7: 2150 - 2849 (Madura unlock & Mahir Tier)
      expect(ProgressionEngine.calculateLevel(2150), equals(7));
      expect(ProgressionEngine.getTier(7), equals(ProgressionTier.mahir));

      // Level 10: 4550 - 5549
      expect(ProgressionEngine.calculateLevel(4550), equals(10));
      expect(ProgressionEngine.calculateLevel(5549), equals(10));

      // Level 11+: +1000 XP/level
      expect(ProgressionEngine.calculateLevel(5550), equals(11));
      expect(ProgressionEngine.calculateLevel(6550), equals(12));
    });

    test('2. XP Reward Matrix (Quiz, Drawing Challenge, Milestones, Daily Practice Cap)', () {
      // Quiz First Clear
      expect(
        ProgressionEngine.calculateQuizReward(
          correctAnswers: 10,
          isPerfect: true,
          isFirstClear: true,
        ),
        equals(125), // 10*10 + 25 bonus
      );

      // Quiz Replay (no perfect bonus, +2 per correct)
      expect(
        ProgressionEngine.calculateQuizReward(
          correctAnswers: 10,
          isPerfect: true,
          isFirstClear: false,
        ),
        equals(20), // 10*2
      );

      // Drawing Challenge
      expect(ProgressionEngine.calculateDrawingReward(0.65, isFirstClear: true), equals(0));
      expect(ProgressionEngine.calculateDrawingReward(0.70, isFirstClear: true), equals(15));
      expect(ProgressionEngine.calculateDrawingReward(0.84, isFirstClear: true), equals(15));
      expect(ProgressionEngine.calculateDrawingReward(0.85, isFirstClear: true), equals(30));
      expect(ProgressionEngine.calculateDrawingReward(0.95, isFirstClear: false), equals(5));

      // Milestones
      expect(
        ProgressionEngine.calculateActivityReward(ActivityType.nodeCompletion, isFirstClear: true),
        equals(20),
      );
      expect(
        ProgressionEngine.calculateActivityReward(ActivityType.treasureChest, isFirstClear: true),
        equals(50),
      );
      expect(
        ProgressionEngine.calculateActivityReward(ActivityType.bossBattle, isFirstClear: true),
        equals(150),
      );
    });

    test('3. Streak Tracking, Daily Rollover, and Idempotency', () async {
      DateTime simulatedNow = DateTime(2026, 11, 10, 9, 0);
      final prefs = InMemoryProfilePreferences(isFreshUser: true);
      final ctrl = ProfileController(preferences: prefs, nowProvider: () => simulatedNow);
      await ctrl.loadProfile();

      expect(ctrl.streakDays, equals(0));
      expect(ctrl.quizzesThisWeek, equals(0));

      // Sesi 1 Hari 1: streak menjadi 1
      await ctrl.awardQuizSessionReward(
        activityId: 'node_1',
        claimId: 'claim_1',
        correctAnswers: 10,
        isPerfect: true,
      );
      expect(ctrl.streakDays, equals(1));
      expect(ctrl.quizzesThisWeek, equals(1));

      // Sesi 2 Hari 1 (hari yang sama): streak tetap 1, kuis bertambah
      await ctrl.awardQuizSessionReward(
        activityId: 'node_2',
        claimId: 'claim_2',
        correctAnswers: 8,
        isPerfect: false,
      );
      expect(ctrl.streakDays, equals(1));
      expect(ctrl.quizzesThisWeek, equals(2));

      // Sesi Hari 2 (+1 hari): streak bertambah menjadi 2
      simulatedNow = DateTime(2026, 11, 11, 10, 0);
      await ctrl.awardQuizSessionReward(
        activityId: 'node_3',
        claimId: 'claim_3',
        correctAnswers: 9,
        isPerfect: false,
      );
      expect(ctrl.streakDays, equals(2));
      expect(ctrl.quizzesThisWeek, equals(3));

      // Sesi Hari 4 (terlewat 2 hari): streak reset ke 1
      simulatedNow = DateTime(2026, 11, 13, 10, 0);
      await ctrl.awardQuizSessionReward(
        activityId: 'node_4',
        claimId: 'claim_4',
        correctAnswers: 10,
        isPerfect: true,
      );
      expect(ctrl.streakDays, equals(1));
      expect(ctrl.quizzesThisWeek, equals(4));

      // Jam mundur (perangkat diubah ke masa lalu): streak tidak berubah
      simulatedNow = DateTime(2026, 11, 12, 10, 0);
      await ctrl.awardQuizSessionReward(
        activityId: 'node_5',
        claimId: 'claim_5',
        correctAnswers: 7,
        isPerfect: false,
      );
      expect(ctrl.streakDays, equals(1));
      expect(ctrl.lastQuizDate, equals('2026-11-13'));
    });

    test('4. Anti-Farming Daily Practice Replay Cap (Max 60 XP/Day)', () async {
      DateTime simulatedNow = DateTime(2026, 11, 19, 10, 0);
      final prefs = InMemoryProfilePreferences(isFreshUser: true);
      final ctrl = ProfileController(preferences: prefs, nowProvider: () => simulatedNow);
      await ctrl.loadProfile();

      // Clear pertama node: 125 XP (first clear tidak kena daily cap)
      final r1 = await ctrl.awardQuizSessionReward(
        activityId: 'node_first',
        claimId: 'c1',
        correctAnswers: 10,
        isPerfect: true,
      );
      expect(r1.xpEarned, equals(125));
      expect(ctrl.totalXP, equals(125));

      // Replay 1: 10 correct = 20 XP (akumulasi 20/60)
      final r2 = await ctrl.awardQuizSessionReward(
        activityId: 'node_first',
        claimId: 'c2',
        correctAnswers: 10,
        isPerfect: true,
      );
      expect(r2.xpEarned, equals(20));
      expect(ctrl.totalXP, equals(145));

      // Replay 2: 10 correct = 20 XP (akumulasi 40/60)
      final r3 = await ctrl.awardQuizSessionReward(
        activityId: 'node_first',
        claimId: 'c3',
        correctAnswers: 10,
        isPerfect: true,
      );
      expect(r3.xpEarned, equals(20));
      expect(ctrl.totalXP, equals(165));

      // Replay 3: 10 correct = 20 XP (akumulasi 60/60 - batas tercapai)
      final r4 = await ctrl.awardQuizSessionReward(
        activityId: 'node_first',
        claimId: 'c4',
        correctAnswers: 10,
        isPerfect: true,
      );
      expect(r4.xpEarned, equals(20));
      expect(ctrl.totalXP, equals(185));

      // Replay 4 di hari yang sama: kena cap, 0 XP
      final r5 = await ctrl.awardQuizSessionReward(
        activityId: 'node_first',
        claimId: 'c5',
        correctAnswers: 10,
        isPerfect: true,
      );
      expect(r5.xpEarned, equals(0));
      expect(ctrl.totalXP, equals(185));

      // Hari berikutnya (+1 hari): cap harian ter-reset otomatis
      simulatedNow = DateTime(2026, 11, 20, 8, 0);
      final r6 = await ctrl.awardQuizSessionReward(
        activityId: 'node_first',
        claimId: 'c6',
        correctAnswers: 10,
        isPerfect: true,
      );
      expect(r6.xpEarned, equals(20));
      expect(ctrl.totalXP, equals(205));
    });

    test('5. Level-Up & Blangkon Progression Synchronization', () async {
      final prefs = InMemoryProfilePreferences(isFreshUser: true);
      final ctrl = ProfileController(preferences: prefs);
      await ctrl.loadProfile();

      expect(ctrl.userLevel, equals(1));
      expect(ctrl.equippedBlangkon, equals(BlangkonType.yogyakarta));
      expect(ctrl.unlockedBlangkons.contains(BlangkonType.yogyakarta), isTrue);
      expect(ctrl.unlockedBlangkons.contains(BlangkonType.surakarta), isFalse);

      // Tingkatkan XP melewati threshold Level 5 (1050 XP)
      await ctrl.setUserLevel(5);
      expect(ctrl.userLevel, equals(5));

      // Simulasi award yang menaikkan level dari 4 ke 5
      final rewards = BlangkonRewards.getNewRewards(4, 5);
      expect(rewards, contains(BlangkonType.surakarta));

      // Pastikan Level 5 membuka Surakarta
      expect(BlangkonRewards.isUnlocked(BlangkonType.surakarta, userLevel: 5), isTrue);
      expect(BlangkonRewards.isUnlocked(BlangkonType.banyumas, userLevel: 5), isFalse);

      // Level 6 membuka Banyumas
      expect(BlangkonRewards.isUnlocked(BlangkonType.banyumas, userLevel: 6), isTrue);

      // Level 8 membuka Kedu
      expect(BlangkonRewards.isUnlocked(BlangkonType.kedu, userLevel: 8), isTrue);

      // Level 10 membuka Cirebon
      expect(BlangkonRewards.isUnlocked(BlangkonType.cirebon, userLevel: 10), isTrue);
    });
  });
}
