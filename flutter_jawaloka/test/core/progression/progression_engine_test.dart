import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/core/progression/progression_engine.dart';
import 'package:flutter_jawaloka/core/progression/reward_summary.dart';

void main() {
  group('ProgressionEngine Level Boundary Tests', () {
    test('Negative and zero XP maps to Level 1', () {
      expect(ProgressionEngine.calculateLevel(-100), equals(1));
      expect(ProgressionEngine.calculateLevel(0), equals(1));
      expect(ProgressionEngine.getBaseXPForLevel(1), equals(0));
    });

    test('XP boundaries Level 1 to 2 (0 - 149 vs 150)', () {
      expect(ProgressionEngine.calculateLevel(149), equals(1));
      expect(ProgressionEngine.calculateLevel(150), equals(2));
      expect(ProgressionEngine.getBaseXPForLevel(2), equals(150));
    });

    test('XP boundaries Level 2 to 3 (150 - 349 vs 350)', () {
      expect(ProgressionEngine.calculateLevel(349), equals(2));
      expect(ProgressionEngine.calculateLevel(350), equals(3));
      expect(ProgressionEngine.getBaseXPForLevel(3), equals(350));
    });

    test('XP boundaries Level 3 to 4 (350 - 649 vs 650)', () {
      expect(ProgressionEngine.calculateLevel(649), equals(3));
      expect(ProgressionEngine.calculateLevel(650), equals(4));
      expect(ProgressionEngine.getBaseXPForLevel(4), equals(650));
    });

    test('XP boundaries Level 4 to 5 (650 - 1049 vs 1050)', () {
      expect(ProgressionEngine.calculateLevel(1049), equals(4));
      expect(ProgressionEngine.calculateLevel(1050), equals(5));
      expect(ProgressionEngine.getBaseXPForLevel(5), equals(1050));
    });

    test('XP boundaries Level 5 to 6 (1050 - 1549 vs 1550)', () {
      expect(ProgressionEngine.calculateLevel(1549), equals(5));
      expect(ProgressionEngine.calculateLevel(1550), equals(6));
      expect(ProgressionEngine.getBaseXPForLevel(6), equals(1550));
    });

    test('XP boundaries Level 6 to 7 (1550 - 2149 vs 2150)', () {
      expect(ProgressionEngine.calculateLevel(2149), equals(6));
      expect(ProgressionEngine.calculateLevel(2150), equals(7));
      expect(ProgressionEngine.getBaseXPForLevel(7), equals(2150));
    });

    test('XP boundaries Level 7 to 8 (2150 - 2849 vs 2850)', () {
      expect(ProgressionEngine.calculateLevel(2849), equals(7));
      expect(ProgressionEngine.calculateLevel(2850), equals(8));
      expect(ProgressionEngine.getBaseXPForLevel(8), equals(2850));
    });

    test('XP boundaries Level 8 to 9 (2850 - 3649 vs 3650)', () {
      expect(ProgressionEngine.calculateLevel(3649), equals(8));
      expect(ProgressionEngine.calculateLevel(3650), equals(9));
      expect(ProgressionEngine.getBaseXPForLevel(9), equals(3650));
    });

    test('XP boundaries Level 9 to 10 (3650 - 4549 vs 4550)', () {
      expect(ProgressionEngine.calculateLevel(4549), equals(9));
      expect(ProgressionEngine.calculateLevel(4550), equals(10));
      expect(ProgressionEngine.getBaseXPForLevel(10), equals(4550));
    });

    test('Level 10 and beyond: +1000 XP per level', () {
      expect(ProgressionEngine.calculateLevel(4550), equals(10));
      expect(ProgressionEngine.calculateLevel(5549), equals(10));
      expect(ProgressionEngine.calculateLevel(5550), equals(11));
      expect(ProgressionEngine.getBaseXPForLevel(11), equals(5550));

      expect(ProgressionEngine.calculateLevel(6550), equals(12));
      expect(ProgressionEngine.getBaseXPForLevel(12), equals(6550));

      expect(ProgressionEngine.calculateLevel(14550), equals(20));
      expect(ProgressionEngine.getBaseXPForLevel(20), equals(14550));
    });
  });

  group('ProgressionEngine Tier Mapping Tests', () {
    test('Levels 1 to 3 map to Pemula', () {
      expect(ProgressionEngine.getTier(1), equals(ProgressionTier.pemula));
      expect(ProgressionEngine.getTier(2), equals(ProgressionTier.pemula));
      expect(ProgressionEngine.getTier(3), equals(ProgressionTier.pemula));
    });

    test('Levels 4 to 6 map to Menengah', () {
      expect(ProgressionEngine.getTier(4), equals(ProgressionTier.menengah));
      expect(ProgressionEngine.getTier(5), equals(ProgressionTier.menengah));
      expect(ProgressionEngine.getTier(6), equals(ProgressionTier.menengah));
    });

    test('Levels 7 and above map to Mahir', () {
      expect(ProgressionEngine.getTier(7), equals(ProgressionTier.mahir));
      expect(ProgressionEngine.getTier(8), equals(ProgressionTier.mahir));
      expect(ProgressionEngine.getTier(15), equals(ProgressionTier.mahir));
    });
  });

  group('ProgressionEngine Level Progress & Next XP Tests', () {
    test('Level progress is bounded between 0.0 and 1.0', () {
      expect(ProgressionEngine.getLevelProgress(0), equals(0.0));
      expect(ProgressionEngine.getLevelProgress(75), closeTo(0.5, 0.001));
      expect(ProgressionEngine.getLevelProgress(150), equals(0.0));
      expect(ProgressionEngine.getLevelProgress(250), closeTo(0.5, 0.001));
      expect(ProgressionEngine.getLevelProgress(650), equals(0.0));
      expect(ProgressionEngine.getLevelProgress(-50), equals(0.0));
    });

    test('getXpToNextLevel calculates remaining XP accurately', () {
      expect(ProgressionEngine.getXpToNextLevel(0), equals(150));
      expect(ProgressionEngine.getXpToNextLevel(100), equals(50));
      expect(ProgressionEngine.getXpToNextLevel(150), equals(200));
      expect(ProgressionEngine.getXpToNextLevel(650), equals(400));
      expect(ProgressionEngine.getXpToNextLevel(4550), equals(1000));
    });
  });

  group('ProgressionEngine Reward Matrix Tests', () {
    test('Quiz reward calculation for First Clear', () {
      expect(
        ProgressionEngine.calculateQuizReward(
          correctAnswers: 8,
          isPerfect: false,
          isFirstClear: true,
        ),
        equals(80),
      );

      // Perfect score bonus (+25)
      expect(
        ProgressionEngine.calculateQuizReward(
          correctAnswers: 10,
          isPerfect: true,
          isFirstClear: true,
        ),
        equals(125), // 100 + 25
      );
    });

    test('Quiz reward calculation for Replay', () {
      expect(
        ProgressionEngine.calculateQuizReward(
          correctAnswers: 8,
          isPerfect: false,
          isFirstClear: false,
        ),
        equals(16), // 8 * 2
      );

      // Replay never awards perfect bonus
      expect(
        ProgressionEngine.calculateQuizReward(
          correctAnswers: 10,
          isPerfect: true,
          isFirstClear: false,
        ),
        equals(20), // 10 * 2 + 0
      );
    });

    test('Drawing reward calculation for all accuracy bands', () {
      // < 70% yields 0 XP
      expect(
        ProgressionEngine.calculateDrawingReward(0.69, isFirstClear: true),
        equals(0),
      );
      expect(
        ProgressionEngine.calculateDrawingReward(0.69, isFirstClear: false),
        equals(0),
      );

      // 70% – 84%: +15 (first clear) / +3 (replay)
      expect(
        ProgressionEngine.calculateDrawingReward(0.70, isFirstClear: true),
        equals(15),
      );
      expect(
        ProgressionEngine.calculateDrawingReward(0.84, isFirstClear: true),
        equals(15),
      );
      expect(
        ProgressionEngine.calculateDrawingReward(0.75, isFirstClear: false),
        equals(3),
      );

      // >= 85%: +30 (first clear) / +5 (replay)
      expect(
        ProgressionEngine.calculateDrawingReward(0.85, isFirstClear: true),
        equals(30),
      );
      expect(
        ProgressionEngine.calculateDrawingReward(0.95, isFirstClear: true),
        equals(30),
      );
      expect(
        ProgressionEngine.calculateDrawingReward(0.90, isFirstClear: false),
        equals(5),
      );
    });

    test('Adventure node, boss, and chest one-time rewards', () {
      expect(
        ProgressionEngine.calculateActivityReward(
          ActivityType.nodeCompletion,
          isFirstClear: true,
        ),
        equals(20),
      );
      expect(
        ProgressionEngine.calculateActivityReward(
          ActivityType.nodeCompletion,
          isFirstClear: false,
        ),
        equals(0),
      );

      expect(
        ProgressionEngine.calculateActivityReward(
          ActivityType.bossBattle,
          isFirstClear: true,
        ),
        equals(150),
      );
      expect(
        ProgressionEngine.calculateActivityReward(
          ActivityType.bossBattle,
          isFirstClear: false,
        ),
        equals(0),
      );

      expect(
        ProgressionEngine.calculateActivityReward(
          ActivityType.treasureChest,
          isFirstClear: true,
        ),
        equals(50),
      );
      expect(
        ProgressionEngine.calculateActivityReward(
          ActivityType.treasureChest,
          isFirstClear: false,
        ),
        equals(0),
      );
    });
  });
}

