import 'dart:math';
import 'package:flutter/foundation.dart';
import '../../features/profile/presentation/widgets/blangkon_painter.dart';
import '../progression/progression_engine.dart';
import '../progression/reward_summary.dart';
import 'profile_preferences.dart';

/// Controller managing user profile state and the centralized Progression Engine
/// (total XP, user level, learning tiers, cleared activities, and rewards).
///
/// Follows the same pattern as [LocaleController] to ensure a single source of
/// truth without introducing third-party state management dependencies.
class ProfileController extends ChangeNotifier {
  final ProfilePreferences _preferences;

  BlangkonType _equippedBlangkon = BlangkonType.yogyakarta;
  // DATA CONTOH: nama bawaan "Dimas" dipakai sampai ada backend
  String _displayName = 'Dimas';
  int _totalXP = 0;
  Set<String> _clearedActivities = {};
  Set<String> _claimedSessionIds = {};
  String _dailyPracticeDate = '';
  int _dailyPracticeXP = 0;
  bool _isInitialized = false;

  // Serialized persistence task queue to eliminate race conditions
  Future<void> _persistenceQueue = Future.value();
  Object? _lastPersistenceError;
  final DateTime Function() _nowProvider;
  final void Function(Object error, StackTrace stackTrace)? onPersistenceError;

  ProfileController({
    ProfilePreferences? preferences,
    DateTime Function()? nowProvider,
    this.onPersistenceError,
  }) : _preferences = preferences ?? SharedPrefsProfilePreferences(),
       _nowProvider = nowProvider ?? DateTime.now;

  BlangkonType get equippedBlangkon => _equippedBlangkon;
  String get displayName => _displayName;
  int get totalXP => _totalXP;
  int get userLevel => ProgressionEngine.calculateLevel(_totalXP);
  double get levelProgress => ProgressionEngine.getLevelProgress(_totalXP);
  int get xpToNextLevel => ProgressionEngine.getXpToNextLevel(_totalXP);
  ProgressionTier get tier => ProgressionEngine.getTier(userLevel);
  bool get isInitialized => _isInitialized;
  Set<String> get clearedActivities => Set.unmodifiable(_clearedActivities);

  /// Exposes the current persistence queue Future for testing and synchronization.
  @visibleForTesting
  Future<void> get persistenceDone => _persistenceQueue;

  /// Exposes the last persistence error, if any, for testing and observability.
  @visibleForTesting
  Object? get lastPersistenceError => _lastPersistenceError;

  /// Loads saved profile attributes and progression data from preferences.
  Future<void> loadProfile() async {
    _equippedBlangkon = await _preferences.loadEquippedBlangkon();
    _displayName = await _preferences.loadDisplayName();
    _totalXP = await _preferences.loadTotalXP();
    _clearedActivities = await _preferences.loadClearedActivities();
    _claimedSessionIds = await _preferences.loadClaimedSessionIds();

    final practiceRecord = await _preferences.loadDailyPracticeRecord();
    _dailyPracticeDate = practiceRecord.date;
    _dailyPracticeXP = practiceRecord.xp;

    _isInitialized = true;
    notifyListeners();
  }

  /// Updates the equipped blangkon, persists choice, and notifies listeners.
  Future<void> setEquippedBlangkon(BlangkonType type) async {
    if (_equippedBlangkon == type) return;

    _equippedBlangkon = type;
    notifyListeners();
    await _preferences.saveEquippedBlangkon(type);
  }

  /// Updates the user display name, persists, and notifies listeners.
  Future<void> setDisplayName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty || _displayName == trimmed) return;

    _displayName = trimmed;
    notifyListeners();
    await _preferences.saveDisplayName(trimmed);
  }

  /// Sets the user proficiency level by aligning total XP with the level's base threshold.
  ///
  /// Retained for backward-compatibility with testing infrastructure.
  Future<void> setUserLevel(int level) async {
    if (level < 1) return;
    final targetXP = ProgressionEngine.getBaseXPForLevel(level);
    if (_totalXP == targetXP) return;

    _totalXP = targetXP;
    notifyListeners();
    _enqueuePersistence();
  }

  /// Checks whether an activity has already been cleared at least once.
  bool isActivityCleared(String activityId) {
    return _clearedActivities.contains(activityId);
  }

  /// Returns today's date formatted as `YYYY-MM-DD`.
  String _getTodayDateString() {
    return _nowProvider().toIso8601String().substring(0, 10);
  }

  /// Centralized reward execution.
  ///
  /// Enforces:
  /// 1. Idempotency via [claimId].
  /// 2. First-clear vs Replay classification via [activityId].
  /// 3. Daily practice replay cap (max 60 XP/day) with automatic date rollover.
  /// 4. Synchronous state update + notifyListeners.
  /// 5. Serialized disk persistence queue.
  Future<RewardSummary> awardReward({
    required String activityId,
    required String claimId,
    required int rawXP,
    String? message,
  }) async {
    final prevXP = _totalXP;
    final prevLevel = userLevel;

    // 1. Idempotency check
    if (_claimedSessionIds.contains(claimId)) {
      return RewardSummary.alreadyClaimed(
        totalXP: prevXP,
        level: prevLevel,
        activityId: activityId,
        claimId: claimId,
      );
    }

    // 2. First-clear vs Replay check
    final isFirstClear = !_clearedActivities.contains(activityId);
    int effectiveXP = max(0, rawXP);

    if (!isFirstClear) {
      // Replay attempt: apply daily practice cap
      final today = _getTodayDateString();
      if (_dailyPracticeDate != today) {
        _dailyPracticeDate = today;
        _dailyPracticeXP = 0;
      }

      final remainingQuota = max(
        0,
        ProgressionEngine.maxDailyPracticeXP - _dailyPracticeXP,
      );

      if (remainingQuota <= 0) {
        _claimedSessionIds.add(claimId);
        _enqueuePersistence();
        return RewardSummary.dailyCapReached(
          totalXP: prevXP,
          level: prevLevel,
          activityId: activityId,
          claimId: claimId,
        );
      }

      effectiveXP = min(effectiveXP, remainingQuota);
      _dailyPracticeXP += effectiveXP;
    } else {
      // First clear: register activity
      if (effectiveXP > 0) {
        _clearedActivities.add(activityId);
      }
    }

    // 3. Apply XP and claim session
    _claimedSessionIds.add(claimId);
    _totalXP += effectiveXP;

    final newLevel = userLevel;
    final leveledUp = newLevel > prevLevel;

    // 4. Notify UI listeners immediately
    notifyListeners();

    // 5. Enqueue serialized persistence
    _enqueuePersistence();

    return RewardSummary(
      xpEarned: effectiveXP,
      previousTotalXP: prevXP,
      newTotalXP: _totalXP,
      previousLevel: prevLevel,
      newLevel: newLevel,
      leveledUp: leveledUp,
      isFirstClear: isFirstClear,
      activityId: activityId,
      claimId: claimId,
      message: message,
    );
  }

  /// Awards reward for completing a Quiz session.
  Future<RewardSummary> awardQuizSessionReward({
    required String activityId,
    required String claimId,
    required int correctAnswers,
    required bool isPerfect,
  }) {
    final isFirstClear = !isActivityCleared(activityId);
    final rawXP = ProgressionEngine.calculateQuizReward(
      correctAnswers: correctAnswers,
      isPerfect: isPerfect,
      isFirstClear: isFirstClear,
    );

    return awardReward(
      activityId: activityId,
      claimId: claimId,
      rawXP: rawXP,
      message: isFirstClear ? 'Quiz First Clear' : 'Quiz Practice Replay',
    );
  }

  /// Awards reward for completing a Drawing Challenge.
  Future<RewardSummary> awardDrawingChallengeReward({
    required String activityId,
    required String claimId,
    required double similarity,
  }) {
    final isFirstClear = !isActivityCleared(activityId);
    final rawXP = ProgressionEngine.calculateDrawingReward(
      similarity,
      isFirstClear: isFirstClear,
    );

    return awardReward(
      activityId: activityId,
      claimId: claimId,
      rawXP: rawXP,
      message: isFirstClear
          ? 'Drawing Mission First Clear'
          : 'Drawing Mission Practice Replay',
    );
  }

  /// Awards reward for one-time milestone activities (nodes, bosses, chests).
  Future<RewardSummary> awardOneTimeActivityReward({
    required String activityId,
    required String claimId,
    required ActivityType type,
  }) {
    final isFirstClear = !isActivityCleared(activityId);
    final rawXP = ProgressionEngine.calculateActivityReward(
      type,
      isFirstClear: isFirstClear,
    );

    return awardReward(
      activityId: activityId,
      claimId: claimId,
      rawXP: rawXP,
      message: '${type.name} milestone',
    );
  }

  /// Enqueues state persistence sequentially with error recovery.
  void _enqueuePersistence() {
    _persistenceQueue = _persistenceQueue
        .then((_) => _performSave())
        .catchError((Object error, StackTrace stackTrace) {
          _lastPersistenceError = error;
          debugPrint('Profile persistence queue error: $error');
          onPersistenceError?.call(error, stackTrace);
        });
  }

  Future<void> _performSave() async {
    try {
      await _preferences.saveTotalXP(_totalXP);
      await _preferences.saveClearedActivities(_clearedActivities);
      await _preferences.saveClaimedSessionIds(_claimedSessionIds);
      await _preferences.saveDailyPracticeRecord(
        _dailyPracticeDate,
        _dailyPracticeXP,
      );
      _lastPersistenceError = null;
    } catch (error, stackTrace) {
      _lastPersistenceError = error;
      debugPrint('Profile persistence save error: $error');
      onPersistenceError?.call(error, stackTrace);
      rethrow;
    }
  }
}
