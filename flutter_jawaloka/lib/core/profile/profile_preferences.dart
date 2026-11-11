import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/profile/presentation/widgets/blangkon_painter.dart';
import '../progression/progression_engine.dart';
import '../validation/validators.dart';
import 'blangkon_rewards.dart';

/// Container for daily practice XP tracking.
class DailyPracticeRecord {
  final String date;
  final int xp;

  const DailyPracticeRecord({required this.date, required this.xp});
}

/// Representasi jenis kelamin karakter pengguna (Putra / Putri).
enum UserGender {
  male,
  female;

  String get label => this == UserGender.male ? 'Putra' : 'Putri';
  String get subtitle => this == UserGender.male
      ? 'Laki-laki (Surjan & Blangkon)'
      : 'Perempuan (Kebaya & Sanggul)';
}

/// Abstract storage interface for user profile preferences and progression state.
abstract class ProfilePreferences {
  static const String keyEquippedBlangkon = 'profile_equipped_blangkon';
  static const String keyDisplayName = 'profile_display_name';
  static const String keyUserLevel = 'profile_user_level';
  static const String keyTotalXP = 'profile_total_xp';
  static const String keyClearedActivities = 'profile_cleared_activities';
  static const String keyClaimedSessionIds = 'profile_claimed_session_ids';
  static const String keyDailyPracticeDate = 'profile_daily_practice_date';
  static const String keyDailyPracticeXP = 'profile_daily_practice_xp';
  static const String keyStreakDays = 'profile_streak_days';
  static const String keyCompletedQuizDays =
      'profile_completed_quiz_days_of_week';
  static const String keyQuizzesThisWeek = 'profile_quizzes_this_week';
  static const String keyUnlockedBlangkons = 'profile_unlocked_blangkons';
  static const String keyLastCelebratedLevel = 'profile_last_celebrated_level';
  static const String keyStorageSchemaVersion = 'storage_schema_version';
  static const int currentSchemaVersion = 1;
  static const String keyLastQuizDate = 'profile_last_quiz_date';
  static const String keyGender = 'profile_user_gender';
  static const String keyAge = 'profile_user_age';

  /// Loads the currently equipped [BlangkonType], falling back to [BlangkonType.yogyakarta].
  Future<BlangkonType> loadEquippedBlangkon();

  /// Persists the selected [BlangkonType].
  Future<void> saveEquippedBlangkon(BlangkonType type);

  /// Loads the user display name, falling back to 'Dimas'.
  Future<String> loadDisplayName();

  /// Persists the user display name.
  Future<void> saveDisplayName(String name);

  /// Loads total XP, executing backward-compatible migration if legacy level is found.
  Future<int> loadTotalXP();

  /// Persists total XP.
  Future<void> saveTotalXP(int xp);

  /// Loads legacy user level for migration / compatibility.
  Future<int> loadUserLevel();

  /// Persists user level.
  Future<void> saveUserLevel(int level);

  /// Loads set of cleared activity IDs (first-clear tracking).
  Future<Set<String>> loadClearedActivities();

  /// Persists cleared activity IDs.
  Future<void> saveClearedActivities(Set<String> activities);

  /// Loads set of processed claim/session IDs (idempotency tracking).
  Future<Set<String>> loadClaimedSessionIds();

  /// Persists processed claim/session IDs.
  Future<void> saveClaimedSessionIds(Set<String> sessionIds);

  /// Loads the daily practice replay tracking record.
  Future<DailyPracticeRecord> loadDailyPracticeRecord();

  /// Persists the daily practice replay tracking record.
  Future<void> saveDailyPracticeRecord(String date, int xp);

  /// Loads streak days count.
  Future<int> loadStreakDays();

  /// Persists streak days count.
  Future<void> saveStreakDays(int days);

  /// Loads the last calendar date when a quiz was completed (YYYY-MM-DD), default ''.
  Future<String> loadLastQuizDate();

  /// Persists the last calendar date when a quiz was completed.
  Future<void> saveLastQuizDate(String date);
  /// Loads the days of the week when quizzes were completed (1 = Mon .. 7 = Sun).
  Future<List<int>> loadCompletedQuizDaysOfWeek();

  /// Persists the days of the week when quizzes were completed.
  Future<void> saveCompletedQuizDaysOfWeek(List<int> days);

  /// Loads number of quizzes completed this week.
  Future<int> loadQuizzesThisWeek();

  /// Persists number of quizzes completed this week.
  Future<void> saveQuizzesThisWeek(int count);

  /// Loads set of unlocked [BlangkonType]s.
  Future<Set<BlangkonType>> loadUnlockedBlangkons();

  /// Persists set of unlocked [BlangkonType]s.
  Future<void> saveUnlockedBlangkons(Set<BlangkonType> blangkons);

  /// Loads last level that was celebrated via LevelUpScreen.
  Future<int> loadLastCelebratedLevel();

  /// Persists last celebrated level.
  Future<void> saveLastCelebratedLevel(int level);

  /// Memuat jenis kelamin pengguna, bawaan [UserGender.male].
  Future<UserGender> loadGender();

  /// Menyimpan jenis kelamin pengguna.
  Future<void> saveGender(UserGender gender);

  /// Memuat umur pengguna, bawaan 17.
  Future<int> loadAge();

  /// Menyimpan umur pengguna.
  Future<void> saveAge(int age);
}

/// SharedPreferences implementation of [ProfilePreferences].
class SharedPrefsProfilePreferences implements ProfilePreferences {
  final Future<SharedPreferences> Function() _prefsProvider;

  SharedPrefsProfilePreferences({
    Future<SharedPreferences> Function()? prefsProvider,
  }) : _prefsProvider = prefsProvider ?? SharedPreferences.getInstance;

  @override
  Future<BlangkonType> loadEquippedBlangkon() async {
    try {
      final unlocked = await loadUnlockedBlangkons();
      final prefs = await _prefsProvider();
      final raw = prefs.get(ProfilePreferences.keyEquippedBlangkon);
      final rawName = Validators.sanitizeStoredString(raw);
      if (rawName.isNotEmpty) {
        for (final type in unlocked) {
          if (type.name == rawName) {
            return type;
          }
        }
      }
      return BlangkonType.yogyakarta;
    } catch (_) {
      return BlangkonType.yogyakarta;
    }
  }

  @override
  Future<void> saveEquippedBlangkon(BlangkonType type) async {
    try {
      final prefs = await _prefsProvider();
      await prefs.setString(ProfilePreferences.keyEquippedBlangkon, type.name);
    } catch (_) {
      // Fallback silently to preserve UI stability
    }
  }

  @override
  Future<String> loadDisplayName() async {
    try {
      final prefs = await _prefsProvider();
      final raw = prefs.get(ProfilePreferences.keyDisplayName);
      if (raw is String) {
        final val = Validators.validateDisplayName(raw);
        if (val.isValid) {
          return val.valueOrNull!;
        }
      }
      return 'Dimas';
    } catch (_) {
      return 'Dimas';
    }
  }

  @override
  Future<void> saveDisplayName(String name) async {
    try {
      final prefs = await _prefsProvider();
      final val = Validators.validateDisplayName(name);
      final safeName = val.valueOrNull ?? 'Dimas';
      await prefs.setString(ProfilePreferences.keyDisplayName, safeName);
    } catch (_) {
      // Fallback silently to preserve UI stability
    }
  }

  @override
  Future<int> loadTotalXP() async {
    try {
      final prefs = await _prefsProvider();

      // 1. Direct load if already migrated/saved
      if (prefs.containsKey(ProfilePreferences.keyTotalXP)) {
        final raw = prefs.get(ProfilePreferences.keyTotalXP);
        return Validators.sanitizeStoredInt(raw, min: 0, fallback: 0);
      }

      // 2. Migration for existing users with saved legacy level
      if (prefs.containsKey(ProfilePreferences.keyUserLevel)) {
        final rawLevel = prefs.get(ProfilePreferences.keyUserLevel);
        final legacyLevel = Validators.sanitizeStoredInt(
          rawLevel,
          min: 1,
          max: 100,
          fallback: 1,
        );
        final migratedXP = ProgressionEngine.getBaseXPForLevel(legacyLevel);
        await prefs.setInt(ProfilePreferences.keyTotalXP, migratedXP);
        return migratedXP;
      }

      // 3. New user starting fresh: 0 XP and Level 1
      await prefs.setInt(ProfilePreferences.keyTotalXP, 0);
      await prefs.setInt(ProfilePreferences.keyUserLevel, 1);
      return 0;
    } catch (_) {
      return 0;
    }
  }

  @override
  Future<void> saveTotalXP(int xp) async {
    try {
      final prefs = await _prefsProvider();
      final safeXp = Validators.sanitizeStoredInt(xp, min: 0, fallback: 0);
      await prefs.setInt(ProfilePreferences.keyTotalXP, safeXp);
      await prefs.setInt(
        ProfilePreferences.keyUserLevel,
        ProgressionEngine.calculateLevel(safeXp),
      );
    } catch (_) {
      // Fallback silently to preserve UI stability
    }
  }

  @override
  Future<int> loadUserLevel() async {
    try {
      final totalXP = await loadTotalXP();
      return ProgressionEngine.calculateLevel(totalXP);
    } catch (_) {
      return 1;
    }
  }

  @override
  Future<void> saveUserLevel(int level) async {
    try {
      final safeLevel = Validators.sanitizeStoredInt(
        level,
        min: 1,
        fallback: 1,
      );
      final xp = ProgressionEngine.getBaseXPForLevel(safeLevel);
      await saveTotalXP(xp);
    } catch (_) {
      // Fallback silently to preserve UI stability
    }
  }

  @override
  Future<Set<String>> loadClearedActivities() async {
    try {
      final prefs = await _prefsProvider();
      final raw = prefs.get(ProfilePreferences.keyClearedActivities);
      if (raw is List) {
        final set = <String>{};
        for (final item in raw) {
          final s = Validators.sanitizeStoredString(item);
          if (s.isNotEmpty) set.add(s);
        }
        return set;
      }
      return <String>{};
    } catch (_) {
      return <String>{};
    }
  }

  @override
  Future<void> saveClearedActivities(Set<String> activities) async {
    try {
      final prefs = await _prefsProvider();
      await prefs.setStringList(
        ProfilePreferences.keyClearedActivities,
        activities.toList(),
      );
    } catch (_) {
      // Fallback silently
    }
  }

  @override
  Future<Set<String>> loadClaimedSessionIds() async {
    try {
      final prefs = await _prefsProvider();
      final raw = prefs.get(ProfilePreferences.keyClaimedSessionIds);
      if (raw is List) {
        final set = <String>{};
        for (final item in raw) {
          final s = Validators.sanitizeStoredString(item);
          if (s.isNotEmpty) set.add(s);
        }
        return set;
      }
      return <String>{};
    } catch (_) {
      return <String>{};
    }
  }

  @override
  Future<void> saveClaimedSessionIds(Set<String> sessionIds) async {
    try {
      final prefs = await _prefsProvider();
      // Keep at most recent 500 session IDs to prevent unbounded storage growth
      final safeList = sessionIds.length > 500
          ? sessionIds.skip(sessionIds.length - 500).toList()
          : sessionIds.toList();
      await prefs.setStringList(
        ProfilePreferences.keyClaimedSessionIds,
        safeList,
      );
    } catch (_) {
      // Fallback silently
    }
  }

  @override
  Future<DailyPracticeRecord> loadDailyPracticeRecord() async {
    try {
      final prefs = await _prefsProvider();
      final rawDate = prefs.get(ProfilePreferences.keyDailyPracticeDate);
      final date = Validators.sanitizeStoredDate(rawDate);
      final rawXP = prefs.get(ProfilePreferences.keyDailyPracticeXP);
      final xp = Validators.sanitizeStoredInt(rawXP, min: 0, fallback: 0);
      return DailyPracticeRecord(date: date, xp: xp);
    } catch (_) {
      return const DailyPracticeRecord(date: '', xp: 0);
    }
  }

  @override
  Future<void> saveDailyPracticeRecord(String date, int xp) async {
    try {
      final prefs = await _prefsProvider();
      final cleanDate = Validators.sanitizeStoredDate(date);
      final cleanXP = Validators.sanitizeStoredInt(xp, min: 0, fallback: 0);
      await prefs.setString(ProfilePreferences.keyDailyPracticeDate, cleanDate);
      await prefs.setInt(ProfilePreferences.keyDailyPracticeXP, cleanXP);
    } catch (_) {
      // Fallback silently
    }
  }

  @override
  Future<int> loadStreakDays() async {
    try {
      final prefs = await _prefsProvider();
      if (prefs.containsKey(ProfilePreferences.keyStreakDays)) {
        final raw = prefs.get(ProfilePreferences.keyStreakDays);
        return Validators.sanitizeStoredInt(raw, min: 0, fallback: 0);
      }
      final xp = await loadTotalXP();
      final level = ProgressionEngine.calculateLevel(xp);
      return (xp > 0 || level > 1) ? 5 : 0;
    } catch (_) {
      return 0;
    }
  }

  @override
  Future<void> saveStreakDays(int days) async {
    try {
      final prefs = await _prefsProvider();
      final safe = Validators.sanitizeStoredInt(days, min: 0, fallback: 0);
      await prefs.setInt(ProfilePreferences.keyStreakDays, safe);
    } catch (_) {}
  }

  @override
  Future<String> loadLastQuizDate() async {
    try {
      final prefs = await _prefsProvider();
      final raw = prefs.get(ProfilePreferences.keyLastQuizDate);
      return Validators.sanitizeStoredDate(raw);
    } catch (_) {
      return '';
    }
  }

  @override
  Future<void> saveLastQuizDate(String date) async {
    try {
      final prefs = await _prefsProvider();
      final safe = Validators.sanitizeStoredDate(date);
      await prefs.setString(ProfilePreferences.keyLastQuizDate, safe);
    } catch (_) {}
  }

  @override
  Future<List<int>> loadCompletedQuizDaysOfWeek() async {
    try {
      final prefs = await _prefsProvider();
      if (prefs.containsKey(ProfilePreferences.keyCompletedQuizDays)) {
        final raw = prefs.get(ProfilePreferences.keyCompletedQuizDays);
        if (raw is List) {
          final days = <int>[];
          for (final item in raw) {
            final d = Validators.sanitizeStoredInt(
              item,
              min: 1,
              max: 7,
              fallback: -1,
            );
            if (d >= 1 && d <= 7 && !days.contains(d)) {
              days.add(d);
            }
          }
          return days;
        }
      }
      final xp = await loadTotalXP();
      final level = ProgressionEngine.calculateLevel(xp);
      return (xp > 0 || level > 1) ? [1, 2, 3, 4, 5] : [];
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> saveCompletedQuizDaysOfWeek(List<int> days) async {
    try {
      final prefs = await _prefsProvider();
      await prefs.setStringList(
        ProfilePreferences.keyCompletedQuizDays,
        days.map((e) => e.toString()).toList(),
      );
    } catch (_) {}
  }

  @override
  Future<int> loadQuizzesThisWeek() async {
    try {
      final prefs = await _prefsProvider();
      if (prefs.containsKey(ProfilePreferences.keyQuizzesThisWeek)) {
        final raw = prefs.get(ProfilePreferences.keyQuizzesThisWeek);
        return Validators.sanitizeStoredInt(raw, min: 0, fallback: 0);
      }
      final xp = await loadTotalXP();
      final level = ProgressionEngine.calculateLevel(xp);
      return (xp > 0 || level > 1) ? 8 : 0;
    } catch (_) {
      return 0;
    }
  }

  @override
  Future<void> saveQuizzesThisWeek(int count) async {
    try {
      final prefs = await _prefsProvider();
      final safe = Validators.sanitizeStoredInt(count, min: 0, fallback: 0);
      await prefs.setInt(ProfilePreferences.keyQuizzesThisWeek, safe);
    } catch (_) {}
  }

  @override
  Future<Set<BlangkonType>> loadUnlockedBlangkons() async {
    try {
      final userLevel = await loadUserLevel();
      final earned = BlangkonRewards.getUnlockedBlangkons(userLevel: userLevel);
      final result = <BlangkonType>{BlangkonType.yogyakarta, ...earned};

      final prefs = await _prefsProvider();
      final raw = prefs.get(ProfilePreferences.keyUnlockedBlangkons);
      if (raw is List) {
        for (final item in raw) {
          final name = Validators.sanitizeStoredString(item);
          for (final type in BlangkonType.values) {
            if (type.name == name && BlangkonRewards.hasRealPainter(type)) {
              result.add(type);
              break;
            }
          }
        }
      }
      return result;
    } catch (_) {
      return {BlangkonType.yogyakarta};
    }
  }

  @override
  Future<void> saveUnlockedBlangkons(Set<BlangkonType> blangkons) async {
    try {
      final prefs = await _prefsProvider();
      final set = Set<BlangkonType>.from(blangkons)
        ..add(BlangkonType.yogyakarta);
      final list = set.map((e) => e.name).toList();
      await prefs.setStringList(ProfilePreferences.keyUnlockedBlangkons, list);
    } catch (_) {}
  }

  @override
  Future<int> loadLastCelebratedLevel() async {
    try {
      final userLevel = await loadUserLevel();
      final prefs = await _prefsProvider();
      final raw = prefs.get(ProfilePreferences.keyLastCelebratedLevel);
      final level = Validators.sanitizeStoredInt(
        raw,
        min: 1,
        max: userLevel,
        fallback: 1,
      );
      return level.clamp(1, userLevel);
    } catch (_) {
      return 1;
    }
  }

  @override
  Future<void> saveLastCelebratedLevel(int level) async {
    try {
      final prefs = await _prefsProvider();
      final safe = Validators.sanitizeStoredInt(level, min: 1, fallback: 1);
      await prefs.setInt(ProfilePreferences.keyLastCelebratedLevel, safe);
    } catch (_) {}
  }

  @override
  Future<UserGender> loadGender() async {
    try {
      final prefs = await _prefsProvider();
      final raw = prefs.getString(ProfilePreferences.keyGender);
      if (raw == 'female') return UserGender.female;
      return UserGender.male;
    } catch (_) {
      return UserGender.male;
    }
  }

  @override
  Future<void> saveGender(UserGender gender) async {
    try {
      final prefs = await _prefsProvider();
      await prefs.setString(ProfilePreferences.keyGender, gender.name);
    } catch (_) {}
  }

  @override
  Future<int> loadAge() async {
    try {
      final prefs = await _prefsProvider();
      final raw = prefs.getInt(ProfilePreferences.keyAge);
      if (raw != null && raw >= 1 && raw <= 120) return raw;
      return 17;
    } catch (_) {
      return 17;
    }
  }

  @override
  Future<void> saveAge(int age) async {
    try {
      final prefs = await _prefsProvider();
      final safe = age.clamp(1, 120);
      await prefs.setInt(ProfilePreferences.keyAge, safe);
    } catch (_) {}
  }
}

/// In-memory mock implementation of [ProfilePreferences] for isolated unit testing.
class InMemoryProfilePreferences implements ProfilePreferences {
  BlangkonType _equippedBlangkon;
  String _displayName;
  int? _totalXP;
  int? _legacyUserLevel;
  Set<String> _clearedActivities;
  Set<String> _claimedSessionIds;
  String _dailyPracticeDate;
  int _dailyPracticeXP;
  int _streakDays;
  String _lastQuizDate;
  List<int> _completedQuizDaysOfWeek;
  int _quizzesThisWeek;
  Set<BlangkonType> _unlockedBlangkons;
  int _lastCelebratedLevel;

  UserGender _gender;
  int _age;
  InMemoryProfilePreferences({
    BlangkonType initialBlangkon = BlangkonType.yogyakarta,
    String initialDisplayName = 'Dimas',
    int? initialTotalXP,
    int? initialLegacyUserLevel,
    int? initialUserLevel = 4,
    bool isFreshUser = false,
    Set<String>? initialClearedActivities,
    Set<String>? initialClaimedSessionIds,
    String initialDailyPracticeDate = '',
    int initialDailyPracticeXP = 0,
    int? initialStreakDays,
    String initialLastQuizDate = '',
    List<int>? initialCompletedQuizDaysOfWeek,
    int? initialQuizzesThisWeek,
    Set<BlangkonType>? initialUnlockedBlangkons,
    int? initialLastCelebratedLevel,
    UserGender initialGender = UserGender.male,
    int initialAge = 17,
  }) : _equippedBlangkon = initialBlangkon,
       _displayName = initialDisplayName,
       _totalXP = initialTotalXP,
       _legacyUserLevel = isFreshUser
           ? null
           : (initialTotalXP != null
                 ? null
                 : (initialLegacyUserLevel ?? initialUserLevel)),
       _clearedActivities = initialClearedActivities != null
           ? Set.from(initialClearedActivities)
           : <String>{},
       _claimedSessionIds = initialClaimedSessionIds != null
           ? Set.from(initialClaimedSessionIds)
           : <String>{},
       _dailyPracticeDate = initialDailyPracticeDate,
       _dailyPracticeXP = initialDailyPracticeXP,
       _streakDays =
           initialStreakDays ??
           (isFreshUser || (initialTotalXP != null && initialTotalXP == 0)
               ? 0
               : 5),
       _lastQuizDate = initialLastQuizDate,
       _completedQuizDaysOfWeek = initialCompletedQuizDaysOfWeek != null
           ? List.from(initialCompletedQuizDaysOfWeek)
           : (isFreshUser || (initialTotalXP != null && initialTotalXP == 0)
                 ? <int>[]
                 : <int>[1, 2, 3, 4, 5]),
       _quizzesThisWeek =
           initialQuizzesThisWeek ??
           (isFreshUser || (initialTotalXP != null && initialTotalXP == 0)
               ? 0
               : 8),
       _unlockedBlangkons = initialUnlockedBlangkons != null
           ? Set.from(initialUnlockedBlangkons)
           : {BlangkonType.yogyakarta, initialBlangkon},
       _lastCelebratedLevel =
           initialLastCelebratedLevel ??
           (isFreshUser ? 1 : (initialUserLevel ?? 1)),
       _gender = initialGender,
       _age = initialAge;
  @override
  Future<BlangkonType> loadEquippedBlangkon() async {
    final unlocked = await loadUnlockedBlangkons();
    return unlocked.contains(_equippedBlangkon)
        ? _equippedBlangkon
        : BlangkonType.yogyakarta;
  }

  @override
  Future<void> saveEquippedBlangkon(BlangkonType type) async {
    _equippedBlangkon = type;
  }

  @override
  Future<String> loadDisplayName() async {
    final val = Validators.validateDisplayName(_displayName);
    return val.valueOrNull ?? 'Dimas';
  }

  @override
  Future<void> saveDisplayName(String name) async {
    _displayName = name;
  }

  @override
  Future<int> loadTotalXP() async {
    if (_totalXP != null) {
      return max(0, _totalXP!);
    }

    // Migration logic
    if (_legacyUserLevel != null && _legacyUserLevel! >= 1) {
      final migratedXP = ProgressionEngine.getBaseXPForLevel(_legacyUserLevel!);
      _totalXP = migratedXP;
      return migratedXP;
    }

    // New user default
    _totalXP = 0;
    _legacyUserLevel = 1;
    return 0;
  }

  @override
  Future<void> saveTotalXP(int xp) async {
    _totalXP = max(0, xp);
    _legacyUserLevel = ProgressionEngine.calculateLevel(_totalXP!);
  }

  @override
  Future<int> loadUserLevel() async {
    final xp = await loadTotalXP();
    return ProgressionEngine.calculateLevel(xp);
  }

  @override
  Future<void> saveUserLevel(int level) async {
    final safeLevel = max(1, level);
    _legacyUserLevel = safeLevel;
    _totalXP = ProgressionEngine.getBaseXPForLevel(safeLevel);
  }

  @override
  Future<Set<String>> loadClearedActivities() async =>
      Set.from(_clearedActivities);

  @override
  Future<void> saveClearedActivities(Set<String> activities) async {
    _clearedActivities = Set.from(activities);
  }

  @override
  Future<Set<String>> loadClaimedSessionIds() async =>
      Set.from(_claimedSessionIds);

  @override
  Future<void> saveClaimedSessionIds(Set<String> sessionIds) async {
    _claimedSessionIds = Set.from(sessionIds);
  }

  @override
  Future<DailyPracticeRecord> loadDailyPracticeRecord() async =>
      DailyPracticeRecord(date: _dailyPracticeDate, xp: _dailyPracticeXP);

  @override
  Future<void> saveDailyPracticeRecord(String date, int xp) async {
    _dailyPracticeDate = date;
    _dailyPracticeXP = max(0, xp);
  }

  @override
  Future<int> loadStreakDays() async => _streakDays;

  @override
  Future<void> saveStreakDays(int days) async {
    _streakDays = max(0, days);
  }

  @override
  Future<String> loadLastQuizDate() async => _lastQuizDate;

  @override
  Future<void> saveLastQuizDate(String date) async {
    _lastQuizDate = Validators.sanitizeStoredDate(date);
  }

  @override
  Future<List<int>> loadCompletedQuizDaysOfWeek() async =>
      List.from(_completedQuizDaysOfWeek);

  @override
  Future<void> saveCompletedQuizDaysOfWeek(List<int> days) async {
    _completedQuizDaysOfWeek = List.from(days);
  }

  @override
  Future<int> loadQuizzesThisWeek() async => _quizzesThisWeek;

  @override
  Future<void> saveQuizzesThisWeek(int count) async {
    _quizzesThisWeek = max(0, count);
  }

  @override
  Future<Set<BlangkonType>> loadUnlockedBlangkons() async {
    final userLevel = await loadUserLevel();
    final earned = BlangkonRewards.getUnlockedBlangkons(userLevel: userLevel);
    final set = Set<BlangkonType>.from(_unlockedBlangkons);
    set.add(BlangkonType.yogyakarta);
    set.addAll(earned);
    return set;
  }

  @override
  Future<void> saveUnlockedBlangkons(Set<BlangkonType> blangkons) async {
    _unlockedBlangkons = Set.from(blangkons);
    _unlockedBlangkons.add(BlangkonType.yogyakarta);
  }

  @override
  Future<int> loadLastCelebratedLevel() async {
    final userLevel = await loadUserLevel();
    return _lastCelebratedLevel.clamp(1, userLevel);
  }

  @override
  Future<void> saveLastCelebratedLevel(int level) async {
    _lastCelebratedLevel = max(1, level);
  }

  @override
  Future<UserGender> loadGender() async => _gender;

  @override
  Future<void> saveGender(UserGender gender) async {
    _gender = gender;
  }

  @override
  Future<int> loadAge() async => _age;

  @override
  Future<void> saveAge(int age) async {
    _age = age.clamp(1, 120);
  }
}
