import 'dart:math';
import '../../../core/progression/reward_summary.dart';
import '../presentation/screens/quiz_question_screen.dart';
import '../presentation/screens/quiz_result_screen.dart';

/// Manages the state, progression, and lifecycle of an active quiz session.
///
/// Ensures deterministic progression, scoring, and complete session reset
/// so no stale answers, index, or score carry over between attempts.
class QuizSession {
  final List<QuizQuestion> questions;
  final String moduleTitle;
  final String activityId;
  late String _sessionId;

  int _currentIndex = 0;
  int _selectedOption = -1;
  bool _answered = false;
  bool _isCorrect = false;
  int _correctCount = 0;

  QuizSession({
    required this.questions,
    this.moduleTitle = 'Aksara Dhasar',
    String? activityId,
  }) : activityId =
           activityId ??
           'quiz_${moduleTitle.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_')}' {
    _sessionId = _generateSessionId();
  }

  String _generateSessionId() =>
      '${activityId}_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}';

  String get sessionId => _sessionId;
  int get currentIndex => _currentIndex;
  int get selectedOption => _selectedOption;
  bool get answered => _answered;
  bool get isCorrect => _isCorrect;
  int get correctCount => _correctCount;
  int get totalQuestions => questions.length;
  bool get isCompleted => _currentIndex >= questions.length;

  QuizQuestion? get currentQuestion =>
      _currentIndex < questions.length ? questions[_currentIndex] : null;

  double get progress => totalQuestions > 0
      ? (_currentIndex + (_answered ? 1 : 0)) / totalQuestions
      : 0.0;

  int get scorePercentage =>
      totalQuestions > 0 ? ((_correctCount / totalQuestions) * 100).round() : 0;

  /// Records the user's selected answer choice for the current question.
  void answer(int optionIndex) {
    if (_answered || isCompleted) return;
    _selectedOption = optionIndex;
    _answered = true;
    _isCorrect = optionIndex == currentQuestion?.correctIndex;
    if (_isCorrect) {
      _correctCount++;
    }
  }

  /// Advances to the next question.
  ///
  /// Returns `true` if moved to the next question, or `false` if the quiz has completed.
  bool nextQuestion() {
    if (!_answered && !isCompleted) return false;
    if (_currentIndex < questions.length - 1) {
      _currentIndex++;
      _selectedOption = -1;
      _answered = false;
      _isCorrect = false;
      return true;
    } else {
      _currentIndex = questions.length;
      return false;
    }
  }

  /// Skips the current question without scoring.
  void skip() {
    if (_answered || isCompleted) return;
    if (_currentIndex < questions.length - 1) {
      _currentIndex++;
      _selectedOption = -1;
      _answered = false;
      _isCorrect = false;
    } else {
      _currentIndex = questions.length;
    }
  }

  /// Completely resets the session state to the beginning (Question 1, score 0)
  /// and establishes a new unique attempt ID.
  void reset() {
    _currentIndex = 0;
    _selectedOption = -1;
    _answered = false;
    _isCorrect = false;
    _correctCount = 0;
    _sessionId = _generateSessionId();
  }

  /// Builds the final [QuizResult] upon completion.
  QuizResult toResult({
    bool isStreakAchievedToday = true,
    RewardSummary? rewardSummary,
  }) {
    return QuizResult(
      score: scorePercentage,
      maxScore: 100,
      correctCount: _correctCount,
      totalQuestions: totalQuestions,
      accuracy: scorePercentage,
      isStreakAchievedToday: isStreakAchievedToday,
      questions: questions,
      moduleTitle: moduleTitle,
      rewardSummary: rewardSummary,
    );
  }
}
