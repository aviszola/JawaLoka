import 'dart:math';
import 'package:flutter/foundation.dart';
import '../../features/profile/presentation/widgets/blangkon_painter.dart';
import '../../features/quiz/domain/quiz_path_data.dart';
import '../../features/quiz/domain/quiz_path_models.dart';
import '../progression/progression_engine.dart';
import '../progression/reward_summary.dart';
import 'blangkon_rewards.dart';
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
  UserGender _gender = UserGender.male;
  int _age = 17;
  int _totalXP = 0;
  Set<String> _clearedActivities = {};
  Set<String> _claimedSessionIds = {};
  String _dailyPracticeDate = '';
  int _dailyPracticeXP = 0;
  int _streakDays = 0;
  String _lastQuizDate = '';
  List<int> _completedQuizDaysOfWeek = [];
  int _quizzesThisWeek = 0;
  Set<BlangkonType> _unlockedBlangkons = {BlangkonType.yogyakarta};
  int _lastCelebratedLevel = 1;
  bool _isSetupCompleted = false;
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
  UserGender get gender => _gender;
  int get age => _age;
  int get totalXP => _totalXP;
  int get userLevel => ProgressionEngine.calculateLevel(_totalXP);
  double get levelProgress => ProgressionEngine.getLevelProgress(_totalXP);
  int get xpToNextLevel => ProgressionEngine.getXpToNextLevel(_totalXP);
  ProgressionTier get tier => ProgressionEngine.getTier(userLevel);
  bool get isSetupCompleted => _isSetupCompleted;
  bool get isInitialized => _isInitialized;
  Set<String> get clearedActivities => Set.unmodifiable(_clearedActivities);
  int get streakDays => _streakDays;
  String get lastQuizDate => _lastQuizDate;
  List<int> get completedQuizDaysOfWeek =>
      List.unmodifiable(_completedQuizDaysOfWeek);
  int get quizzesThisWeek => _quizzesThisWeek;
  Set<BlangkonType> get unlockedBlangkons =>
      Set.unmodifiable(_unlockedBlangkons);
  int get lastCelebratedLevel => _lastCelebratedLevel;

  /// Memeriksa apakah suatu tipe blangkon sudah terbuka untuk pengguna.
  bool isBlangkonUnlocked(BlangkonType type) {
    return _unlockedBlangkons.contains(type) ||
        BlangkonRewards.isUnlocked(
          type,
          userLevel: userLevel,
          hasMasteredAksara: hasMasteredAksara,
        );
  }

  /// Memeriksa apakah suatu level berhak memicu layar perayaan Level Naik.
  bool shouldCelebrateLevel(int level) => level > _lastCelebratedLevel;

  /// Menandai level yang sudah dirayakan agar perayaan tidak muncul berulang.
  Future<void> markLevelCelebrated(int level) async {
    if (level > _lastCelebratedLevel) {
      _lastCelebratedLevel = level;
      notifyListeners();
      await _preferences.saveLastCelebratedLevel(_lastCelebratedLevel);
    }
  }

  bool get hasMasteredAksara =>
      isEvaluationPassed('path_node_u2_n20_evaluasi_unit2');
  int get completedQuizzesCount =>
      QuizPathData.resolveCurriculum(
            clearedActivities: _clearedActivities,
            isEvaluationPassed: isEvaluationPassed,
          )
          .expand((u) => u.nodes)
          .where((n) => n.status == NodeStatus.completed)
          .length;

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

    _streakDays = await _preferences.loadStreakDays();
    _lastQuizDate = await _preferences.loadLastQuizDate();
    _completedQuizDaysOfWeek = await _preferences.loadCompletedQuizDaysOfWeek();
    _quizzesThisWeek = await _preferences.loadQuizzesThisWeek();

    _unlockedBlangkons = await _preferences.loadUnlockedBlangkons();
    _lastCelebratedLevel = await _preferences.loadLastCelebratedLevel();
    _gender = await _preferences.loadGender();
    _age = await _preferences.loadAge();
    _isSetupCompleted = await _preferences.loadSetupCompleted();

    // Pastikan Yogyakarta selalu terbuka
    _unlockedBlangkons.add(BlangkonType.yogyakarta);

    // Migrasi data lama: bila user sudah berlevel tinggi, buka seluruh blangkon yang berhak
    final currentLevel = userLevel;
    final eligibleBlangkons = BlangkonRewards.getUnlockedBlangkons(
      userLevel: currentLevel,
      hasMasteredAksara: hasMasteredAksara,
    );
    _unlockedBlangkons.addAll(eligibleBlangkons);

    // JANGAN timpa blangkon yang sedang dipakai pengguna (tetap pasang blangkon pilihannya)
    if (BlangkonRewards.hasRealPainter(_equippedBlangkon)) {
      _unlockedBlangkons.add(_equippedBlangkon);
    } else {
      _equippedBlangkon = BlangkonType.yogyakarta;
      _unlockedBlangkons.add(BlangkonType.yogyakarta);
      await _preferences.saveEquippedBlangkon(BlangkonType.yogyakarta);
    }

    // Tandai level lama agar tidak memicu layar perayaan Level Naik berulang
    if (currentLevel > _lastCelebratedLevel) {
      _lastCelebratedLevel = currentLevel;
      await _preferences.saveLastCelebratedLevel(_lastCelebratedLevel);
    }

    await _preferences.saveUnlockedBlangkons(_unlockedBlangkons);

    _isInitialized = true;
    notifyListeners();
  }

  /// Menandai bahwa pengguna telah menyelesaikan onboarding setup profil.
  Future<void> markSetupCompleted() async {
    if (_isSetupCompleted) return;
    _isSetupCompleted = true;
    notifyListeners();
    await _preferences.saveSetupCompleted(true);
  }

  /// Mereset flag setup selesai (mis. saat pengguna memilih Keluar ke onboarding).
  Future<void> resetSetupCompleted() async {
    if (!_isSetupCompleted) return;
    _isSetupCompleted = false;
    notifyListeners();
    await _preferences.saveSetupCompleted(false);
  }

  /// Updates the equipped blangkon, persists choice, and notifies listeners.
  Future<void> setEquippedBlangkon(BlangkonType type) async {
    if (_equippedBlangkon == type) return;

    _equippedBlangkon = type;
    _unlockedBlangkons.add(type);
    notifyListeners();
    await _preferences.saveEquippedBlangkon(type);
    await _preferences.saveUnlockedBlangkons(_unlockedBlangkons);
  }

  /// Updates the user display name, persists, and notifies listeners.
  Future<void> setDisplayName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty || _displayName == trimmed) return;

    _displayName = trimmed;
    notifyListeners();
    await _preferences.saveDisplayName(trimmed);
  }

  /// Updates the user gender (Putra/Putri), persists, and notifies listeners.
  Future<void> setGender(UserGender gender) async {
    if (_gender == gender) return;
    _gender = gender;
    notifyListeners();
    await _preferences.saveGender(gender);
  }

  /// Updates the user age, persists, and notifies listeners.
  Future<void> setAge(int age) async {
    final safe = age.clamp(1, 120);
    if (_age == safe) return;
    _age = safe;
    notifyListeners();
    await _preferences.saveAge(safe);
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

  /// Peta alias aktivitas lawas untuk backward compatibility data penyimpanan progres.
  static const Map<String, String> legacyActivityAliases =
      QuizPathData.legacyActivityAliases;

  /// Checks whether an activity has achieved canonical mastery:
  /// - Canonical ID is directly present in [_clearedActivities], OR
  /// - A SAFE legacy alias mapped to this canonical ID is in [_clearedActivities].
  ///
  /// CONDITIONAL and UNSAFE aliases do NOT grant canonical mastery automatically.
  bool isCanonicalMastered(String activityId) {
    return QuizPathData.hasCanonicalMastery(activityId, _clearedActivities);
  }

  /// Checks whether an activity has any historical or canonical completion.
  /// Used for reward deduplication and progression continuity.
  bool hasHistoricalCompletion(String activityId) {
    return QuizPathData.hasHistoricalCompletion(activityId, _clearedActivities);
  }

  /// Checks whether an activity has already been cleared at least once.
  ///
  /// - If querying a historical legacy ID, preserves the exact historical record.
  /// - If querying a canonical ID, returns true if canonical mastery has been achieved.
  bool isActivityCleared(String activityId) {
    if (_clearedActivities.contains(activityId)) return true;
    return isCanonicalMastered(activityId);
  }

  /// Returns whether an evaluation milestone has been passed with score >= 70%.
  /// Returns whether an evaluation milestone has been passed with score >= 70%.
  ///
  /// Enforces evaluation domain isolation:
  /// - Final-exam qualification ('path_node_u5_n50_evaluasi_akhir') can ONLY come from
  ///   a genuine canonical final-exam pass or score >= 70%.
  /// - Historical Unit 5 evaluation ('path_node_u5_n49_evaluasi_unit5') pass markers
  ///   never qualify the comprehensive final exam.
  bool isEvaluationPassed(String activityId) {
    // 1. Direct pass check on the queried activity ID
    if (_clearedActivities.contains('eval_passed:$activityId')) {
      // Historical unit evaluation pass cannot qualify the final exam
      if (activityId != 'path_node_u5_n50_evaluasi_akhir' &&
          QuizPathData.resolveCanonicalActivityId(activityId) ==
              'path_node_u5_n50_evaluasi_akhir') {
        return false;
      }
      return true;
    }

    final canonicalId = QuizPathData.resolveCanonicalActivityId(activityId);

    // 2. Final exam qualification cannot be granted by unit evaluations or aliases
    if (canonicalId == 'path_node_u5_n50_evaluasi_akhir') {
      final score = getEvaluationScore('path_node_u5_n50_evaluasi_akhir');
      if (score != null) return score >= 70;
      return false;
    }

    // 3. For canonical evaluations (Unit 1-4), check if canonical pass marker is recorded
    if (canonicalId != activityId &&
        _clearedActivities.contains('eval_passed:$canonicalId')) {
      return true;
    }

    // 4. Score-based pass check on queried identity
    final score = getEvaluationScore(activityId);
    if (score != null) return score >= 70;

    return false;
  }

  /// Returns the recorded evaluation score for an activity, or null if unrecorded.
  ///
  /// Enforces evaluation domain isolation:
  /// - Scores for 'path_node_u5_n50_evaluasi_akhir' only read canonical final-exam scores.
  /// - Historical Unit 5 scores ('path_node_u5_n49_evaluasi_unit5') remain isolated to their
  ///   historical evaluation identity.
  int? getEvaluationScore(String activityId) {
    // 1. Direct score lookup on queried identity
    final prefix = 'eval_score:$activityId:';
    for (final item in _clearedActivities) {
      if (item.startsWith(prefix)) {
        return int.tryParse(item.substring(prefix.length));
      }
    }

    // 2. Final exam never aliases scores from unit evaluations
    if (activityId == 'path_node_u5_n50_evaluasi_akhir') {
      return null;
    }

    // 3. Canonical evaluation score lookup if different and not the final exam
    final canonicalId = QuizPathData.resolveCanonicalActivityId(activityId);
    if (canonicalId != activityId &&
        canonicalId != 'path_node_u5_n50_evaluasi_akhir') {
      final canonicalPrefix = 'eval_score:$canonicalId:';
      for (final item in _clearedActivities) {
        if (item.startsWith(canonicalPrefix)) {
          return int.tryParse(item.substring(canonicalPrefix.length));
        }
      }
    }

    return null;
  }

  /// Explicitly records an evaluation score for [activityId].
  /// If [score] >= 70, registers the activity as passed.
  Future<void> recordEvaluationScore({
    required String activityId,
    required int score,
  }) async {
    final canonicalId = QuizPathData.resolveCanonicalActivityId(activityId);
    _clearedActivities.removeWhere(
      (item) => item.startsWith('eval_score:$canonicalId:'),
    );
    _clearedActivities.add('eval_score:$canonicalId:$score');
    if (score >= 70) {
      _clearedActivities.add('eval_passed:$canonicalId');
      _clearedActivities.add(canonicalId);
    } else {
      _clearedActivities.remove('eval_passed:$canonicalId');
      _clearedActivities.remove(canonicalId);
    }
    notifyListeners();
    _enqueuePersistence();
  }

  /// Returns today's date formatted as `YYYY-MM-DD`.
  String _getTodayDateString() {
    return _nowProvider().toIso8601String().substring(0, 10);
  }

  /// Centralized reward execution.
  ///
  /// Enforces:
  /// 1. Idempotency via [claimId].
  /// 2. First-clear vs Replay classification via [isActivityCleared] across legacy and canonical IDs.
  /// 3. Daily practice replay cap (max 60 XP/day) with automatic date rollover.
  /// 4. Synchronous state update + notifyListeners.
  /// 5. Serialized disk persistence queue.
  Future<RewardSummary> awardReward({
    required String activityId,
    required String claimId,
    required int rawXP,
    String? message,
    bool isQuiz = false,
  }) async {
    final canonicalId = QuizPathData.resolveCanonicalActivityId(activityId);
    final prevXP = _totalXP;
    final prevLevel = userLevel;

    // 1. Idempotency check
    if (_claimedSessionIds.contains(claimId)) {
      return RewardSummary.alreadyClaimed(
        totalXP: prevXP,
        level: prevLevel,
        activityId: canonicalId,
        claimId: claimId,
      );
    }

    // 2. First-clear vs Replay check using hasHistoricalCompletion (handles legacy and canonical)
    final isFirstClear = !hasHistoricalCompletion(canonicalId);
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
        _clearedActivities.add(canonicalId);
        _enqueuePersistence();
        return RewardSummary.dailyCapReached(
          totalXP: prevXP,
          level: prevLevel,
          activityId: canonicalId,
          claimId: claimId,
        );
      }

      effectiveXP = min(effectiveXP, remainingQuota);
      _dailyPracticeXP += effectiveXP;
      _clearedActivities.add(canonicalId);
    } else {
      // First clear: register canonical activity ID
      if (effectiveXP > 0) {
        _clearedActivities.add(canonicalId);
      }
    }

    // 3. Apply XP and claim session
    _claimedSessionIds.add(claimId);
    _totalXP += effectiveXP;

    // DEMO: jam perangkat, bukan waktu server
    if (isQuiz) {
      final now = _nowProvider();
      final todayWeekday = now.weekday;
      if (!_completedQuizDaysOfWeek.contains(todayWeekday)) {
        _completedQuizDaysOfWeek = [..._completedQuizDaysOfWeek, todayWeekday];
      }
      _quizzesThisWeek += 1;

      final todayStr = _getTodayDateString();
      if (_lastQuizDate.isEmpty) {
        _streakDays = 1;
        _lastQuizDate = todayStr;
      } else {
        final lastDate = DateTime.tryParse(_lastQuizDate);
        final todayDate = DateTime.tryParse(todayStr);
        if (lastDate != null && todayDate != null) {
          final diffDays = todayDate.difference(lastDate).inDays;
          if (diffDays == 0) {
            // tanggal sama: streak tidak berubah
          } else if (diffDays == 1) {
            // tepat +1 hari: streak + 1
            _streakDays += 1;
            _lastQuizDate = todayStr;
          } else if (diffDays > 1) {
            // selisih lebih dari 1 hari: reset ke 1
            _streakDays = 1;
            _lastQuizDate = todayStr;
          } else {
            // tanggal hari ini lebih lama dari tersimpan (jam mundur): tidak berubah
          }
        } else {
          _streakDays = 1;
          _lastQuizDate = todayStr;
        }
      }
    }

    final newLevel = userLevel;
    final leveledUp = newLevel > prevLevel;
    List<BlangkonType> newRewards = const [];

    if (leveledUp) {
      newRewards = BlangkonRewards.getNewRewards(prevLevel, newLevel);
      if (newRewards.isNotEmpty) {
        _unlockedBlangkons.addAll(newRewards);
        _preferences.saveUnlockedBlangkons(_unlockedBlangkons);
      }
    }

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
      activityId: canonicalId,
      claimId: claimId,
      unlockedBlangkons: newRewards,
      message: message,
    );
  }

  /// Awards reward for completing a Quiz session.
  ///
  /// If [isEvaluation] is true:
  /// - Enforces a minimum score of 70% to pass the evaluation gate.
  /// - Scores below 70% fail the gate, do not clear the activity, and award 0 XP.
  /// - Scores of 70% and above mark the evaluation as passed, clear the gate,
  ///   and award first-clear XP once (or replay practice XP on subsequent attempts).
  Future<RewardSummary> awardQuizSessionReward({
    required String activityId,
    required String claimId,
    required int correctAnswers,
    required bool isPerfect,
    int? scorePercentage,
    bool isEvaluation = false,
  }) {
    final canonicalId = QuizPathData.resolveCanonicalActivityId(activityId);

    if (isEvaluation) {
      final score = scorePercentage ?? (correctAnswers * 10);
      final isPassing = score >= 70;

      // Update evaluation score record on canonical ID
      _clearedActivities.removeWhere(
        (item) => item.startsWith('eval_score:$canonicalId:'),
      );
      _clearedActivities.add('eval_score:$canonicalId:$score');

      if (!isPassing) {
        // If not already passed in a previous session, ensure it is not cleared
        final wasAlreadyPassed = isEvaluationPassed(canonicalId);
        if (!wasAlreadyPassed) {
          _clearedActivities.remove('eval_passed:$canonicalId');
          _clearedActivities.remove(canonicalId);
        }
        notifyListeners();
        _enqueuePersistence();
        return Future.value(
          RewardSummary(
            xpEarned: 0,
            previousTotalXP: _totalXP,
            newTotalXP: _totalXP,
            previousLevel: userLevel,
            newLevel: userLevel,
            leveledUp: false,
            isFirstClear: false,
            activityId: canonicalId,
            claimId: claimId,
            message: 'Evaluation score below 70%. Try again!',
          ),
        );
      }

      // Passed the evaluation gate: record passed marker on canonical ID
      _clearedActivities.add('eval_passed:$canonicalId');
    }

    final isFirstClear = !hasHistoricalCompletion(canonicalId);
    final rawXP = ProgressionEngine.calculateQuizReward(
      correctAnswers: correctAnswers,
      isPerfect: isPerfect,
      isFirstClear: isFirstClear,
    );

    return awardReward(
      activityId: canonicalId,
      claimId: claimId,
      rawXP: rawXP,
      isQuiz: true,
      message: isFirstClear ? 'Quiz First Clear' : 'Quiz Practice Replay',
    );
  }

  /// Awards reward for completing a Drawing Challenge.
  Future<RewardSummary> awardDrawingChallengeReward({
    required String activityId,
    required String claimId,
    required double similarity,
  }) {
    final canonicalId = QuizPathData.resolveCanonicalActivityId(activityId);
    final isFirstClear = !hasHistoricalCompletion(canonicalId);
    final rawXP = ProgressionEngine.calculateDrawingReward(
      similarity,
      isFirstClear: isFirstClear,
    );

    return awardReward(
      activityId: canonicalId,
      claimId: claimId,
      rawXP: rawXP,
      isQuiz: false,
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
    final canonicalId = QuizPathData.resolveCanonicalActivityId(activityId);
    final isFirstClear = !hasHistoricalCompletion(canonicalId);
    final rawXP = ProgressionEngine.calculateActivityReward(
      type,
      isFirstClear: isFirstClear,
    );

    return awardReward(
      activityId: canonicalId,
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
      await _preferences.saveStreakDays(_streakDays);
      await _preferences.saveLastQuizDate(_lastQuizDate);
      await _preferences.saveCompletedQuizDaysOfWeek(_completedQuizDaysOfWeek);
      await _preferences.saveQuizzesThisWeek(_quizzesThisWeek);
      await _preferences.saveUnlockedBlangkons(_unlockedBlangkons);
      await _preferences.saveLastCelebratedLevel(_lastCelebratedLevel);
      _lastPersistenceError = null;
    } catch (error, stackTrace) {
      _lastPersistenceError = error;
      debugPrint('Profile persistence save error: $error');
      onPersistenceError?.call(error, stackTrace);
      rethrow;
    }
  }
}
