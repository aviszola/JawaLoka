import '../../../../core/progression/reward_summary.dart';
import 'quiz_question.dart';

/// Model hasil evaluasi atau sesi kuis yang telah selesai.
class QuizResult {
  final int score;
  final int maxScore;
  final int correctCount;
  final int totalQuestions;
  final int accuracy; // percentage 0–100
  final bool isStreakAchievedToday;
  final int currentStreak;
  final List<QuizQuestion>? questions;
  final String? moduleTitle;
  final RewardSummary? rewardSummary;
  final bool isEvaluation;

  const QuizResult({
    required this.score,
    this.maxScore = 100,
    this.correctCount = 8,
    this.totalQuestions = 10,
    required this.accuracy,
    this.isStreakAchievedToday = true,
    this.currentStreak = 1,
    this.questions,
    this.moduleTitle,
    this.rewardSummary,
    this.isEvaluation = false,
  });

  double get scoreRatio =>
      maxScore > 0 ? (score / maxScore).clamp(0.0, 1.0) : 0.0;

  int get stars => score >= 90
      ? 3
      : score >= 70
      ? 2
      : 1;
}
