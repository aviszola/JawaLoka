import 'dart:math';
import 'reward_summary.dart';

/// Pure domain engine managing JawaLoka experience points (XP),
/// level thresholds, learning tiers, and activity rewards.
///
/// Ensures deterministic progression where total XP is the single
/// source of truth for user level.
class ProgressionEngine {
  ProgressionEngine._();

  /// Maximum daily practice XP allowed from replay sessions per calendar day.
  static const int maxDailyPracticeXP = 60;

  /// Base cumulative XP thresholds for Levels 1 through 10.
  static const List<int> _levelThresholds = [
    0, // Level 1
    150, // Level 2
    350, // Level 3
    650, // Level 4
    1050, // Level 5
    1550, // Level 6
    2150, // Level 7
    2850, // Level 8
    3650, // Level 9
    4550, // Level 10
  ];

  /// Calculates the user level based on [xp].
  ///
  /// Normalized to minimum Level 1. For Level 10 and above, each level requires
  /// an additional 1000 XP beyond 4550 (e.g., L11 = 5550 XP, L12 = 6550 XP).
  static int calculateLevel(int xp) {
    if (xp <= 0) return 1;

    // Check thresholds for levels 1 to 10
    for (int i = _levelThresholds.length - 1; i >= 0; i--) {
      if (xp >= _levelThresholds[i]) {
        final baseLevel = i + 1;
        if (baseLevel == 10) {
          // Level 10 and beyond: 1000 XP per level above 4550
          final extraXp = xp - _levelThresholds.last;
          return 10 + (extraXp ~/ 1000);
        }
        return baseLevel;
      }
    }

    return 1;
  }

  /// Returns the base cumulative XP required to reach the start of [level].
  ///
  /// Clamped to minimum Level 1.
  static int getBaseXPForLevel(int level) {
    if (level <= 1) return 0;
    if (level <= _levelThresholds.length) {
      return _levelThresholds[level - 1];
    }
    // Level 11+: 4550 + (level - 10) * 1000
    return _levelThresholds.last + (level - 10) * 1000;
  }

  /// Calculates progress within the current level as a fraction in `[0.0, 1.0]`.
  static double getLevelProgress(int xp) {
    final safeXp = max(0, xp);
    final currentLevel = calculateLevel(safeXp);
    final currentBase = getBaseXPForLevel(currentLevel);
    final nextBase = getBaseXPForLevel(currentLevel + 1);

    final range = nextBase - currentBase;
    if (range <= 0) return 1.0;

    final progress = (safeXp - currentBase) / range;
    return progress.clamp(0.0, 1.0);
  }

  /// Returns remaining XP required to advance to the next level.
  static int getXpToNextLevel(int xp) {
    final safeXp = max(0, xp);
    final currentLevel = calculateLevel(safeXp);
    final nextBase = getBaseXPForLevel(currentLevel + 1);
    return max(0, nextBase - safeXp);
  }

  /// Determines the learner's tier based on [level].
  ///
  /// - Level 1–3: Pemula
  /// - Level 4–6: Menengah
  /// - Level 7+: Mahir
  static ProgressionTier getTier(int level) {
    if (level <= 3) return ProgressionTier.pemula;
    if (level <= 6) return ProgressionTier.menengah;
    return ProgressionTier.mahir;
  }

  /// Calculates the XP reward for a given [ActivityType].
  static int calculateActivityReward(
    ActivityType type, {
    required bool isFirstClear,
  }) {
    switch (type) {
      case ActivityType.quizQuestionCorrect:
        return isFirstClear ? 10 : 2;
      case ActivityType.quizPerfectBonus:
        return isFirstClear ? 25 : 0;
      case ActivityType.drawingFair:
        return isFirstClear ? 15 : 3;
      case ActivityType.drawingExcellent:
        return isFirstClear ? 30 : 5;
      case ActivityType.nodeCompletion:
        return isFirstClear ? 20 : 0;
      case ActivityType.bossBattle:
        return isFirstClear ? 150 : 0;
      case ActivityType.treasureChest:
        return isFirstClear ? 50 : 0;
    }
  }

  /// Calculates XP for a quiz attempt based on correct answers and perfect score.
  ///
  /// - Each correct answer: +10 XP (first clear) or +2 XP (replay).
  /// - Perfect quiz bonus: +25 XP (first clear only).
  /// - Replay never awards the perfect bonus.
  static int calculateQuizReward({
    required int correctAnswers,
    required bool isPerfect,
    required bool isFirstClear,
  }) {
    if (correctAnswers <= 0) return 0;

    final baseXP = correctAnswers * (isFirstClear ? 10 : 2);
    final bonusXP = (isPerfect && isFirstClear) ? 25 : 0;
    return baseXP + bonusXP;
  }

  /// Calculates XP for a drawing challenge based on similarity ratio (0.0 – 1.0).
  ///
  /// - Similarity < 0.70: 0 XP (no reward).
  /// - Similarity 0.70 – 0.84: +15 XP (first clear) / +3 XP (replay).
  /// - Similarity >= 0.85: +30 XP (first clear) / +5 XP (replay).
  static int calculateDrawingReward(
    double similarity, {
    required bool isFirstClear,
  }) {
    if (similarity >= 0.85) {
      return isFirstClear ? 30 : 5;
    } else if (similarity >= 0.70) {
      return isFirstClear ? 15 : 3;
    }
    return 0;
  }
}
