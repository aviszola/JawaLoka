/// Classification of learner mastery tier according to JawaLoka progression curve.
enum ProgressionTier {
  /// Level 1–3: Basic Hanacaraka characters and sound recognition.
  pemula,

  /// Level 4–6: Sandangan, sound shifts, and intermediate vocabulary.
  menengah,

  /// Level 7+: Unggah-ungguh, complex contexts, and advanced mastery.
  mahir,
}

/// Supported activity types that can award XP in JawaLoka.
enum ActivityType {
  quizQuestionCorrect,
  quizPerfectBonus,
  drawingFair,
  drawingExcellent,
  nodeCompletion,
  bossBattle,
  treasureChest,
}

/// Detailed outcome summary after awarding XP.
class RewardSummary {
  final int xpEarned;
  final int previousTotalXP;
  final int newTotalXP;
  final int previousLevel;
  final int newLevel;
  final bool leveledUp;
  final bool isFirstClear;
  final String activityId;
  final String claimId;
  final String? message;

  const RewardSummary({
    required this.xpEarned,
    required this.previousTotalXP,
    required this.newTotalXP,
    required this.previousLevel,
    required this.newLevel,
    required this.leveledUp,
    required this.isFirstClear,
    required this.activityId,
    required this.claimId,
    this.message,
  });

  /// Factory for a rejected or already-claimed reward attempt (0 XP awarded).
  factory RewardSummary.alreadyClaimed({
    required int totalXP,
    required int level,
    required String activityId,
    required String claimId,
  }) {
    return RewardSummary(
      xpEarned: 0,
      previousTotalXP: totalXP,
      newTotalXP: totalXP,
      previousLevel: level,
      newLevel: level,
      leveledUp: false,
      isFirstClear: false,
      activityId: activityId,
      claimId: claimId,
      message: 'Claim ID already processed.',
    );
  }

  /// Factory for when daily practice cap has been reached (0 XP awarded).
  factory RewardSummary.dailyCapReached({
    required int totalXP,
    required int level,
    required String activityId,
    required String claimId,
  }) {
    return RewardSummary(
      xpEarned: 0,
      previousTotalXP: totalXP,
      newTotalXP: totalXP,
      previousLevel: level,
      newLevel: level,
      leveledUp: false,
      isFirstClear: false,
      activityId: activityId,
      claimId: claimId,
      message: 'Daily practice replay cap reached.',
    );
  }

  @override
  String toString() =>
      'RewardSummary(xpEarned: $xpEarned, totalXP: $newTotalXP, level: $newLevel, leveledUp: $leveledUp, firstClear: $isFirstClear)';
}

