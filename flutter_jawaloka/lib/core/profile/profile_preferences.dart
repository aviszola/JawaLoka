import 'package:shared_preferences/shared_preferences.dart';
import '../../features/profile/presentation/widgets/blangkon_painter.dart';

/// Abstract storage interface for user profile preferences.
///
/// Only persists `equippedBlangkon` and `displayName` as per Phase 4b specifications.
abstract class ProfilePreferences {
  static const String keyEquippedBlangkon = 'profile_equipped_blangkon';
  static const String keyDisplayName = 'profile_display_name';

  /// Loads the currently equipped [BlangkonType], falling back to [BlangkonType.yogyakarta].
  Future<BlangkonType> loadEquippedBlangkon();

  /// Persists the selected [BlangkonType].
  Future<void> saveEquippedBlangkon(BlangkonType type);

  /// Loads the user display name, falling back to 'Dimas'.
  Future<String> loadDisplayName();

  /// Persists the user display name.
  Future<void> saveDisplayName(String name);
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
      final prefs = await _prefsProvider();
      final raw = prefs.getString(ProfilePreferences.keyEquippedBlangkon);
      if (raw != null) {
        return BlangkonType.values.firstWhere(
          (e) => e.name == raw,
          orElse: () => BlangkonType.yogyakarta,
        );
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
      // Fallback silently without throwing to preserve UI stability
    }
  }

  @override
  Future<String> loadDisplayName() async {
    try {
      final prefs = await _prefsProvider();
      final raw = prefs.getString(ProfilePreferences.keyDisplayName);
      // DATA CONTOH: nama bawaan "Dimas" dipakai sampai ada backend
      return (raw != null && raw.trim().isNotEmpty) ? raw : 'Dimas';
    } catch (_) {
      // DATA CONTOH: nama bawaan "Dimas" dipakai sampai ada backend
      return 'Dimas';
    }
  }

  @override
  Future<void> saveDisplayName(String name) async {
    try {
      final prefs = await _prefsProvider();
      await prefs.setString(ProfilePreferences.keyDisplayName, name);
    } catch (_) {
      // Fallback silently without throwing to preserve UI stability
    }
  }
}

/// In-memory mock implementation of [ProfilePreferences] for isolated testing.
class InMemoryProfilePreferences implements ProfilePreferences {
  BlangkonType _equippedBlangkon;
  String _displayName;

  InMemoryProfilePreferences({
    BlangkonType initialBlangkon = BlangkonType.yogyakarta,
    // DATA CONTOH: nama bawaan "Dimas" dipakai sampai ada backend
    String initialDisplayName = 'Dimas',
  })  : _equippedBlangkon = initialBlangkon,
        _displayName = initialDisplayName;

  @override
  Future<BlangkonType> loadEquippedBlangkon() async => _equippedBlangkon;

  @override
  Future<void> saveEquippedBlangkon(BlangkonType type) async {
    _equippedBlangkon = type;
  }

  @override
  Future<String> loadDisplayName() async => _displayName;

  @override
  Future<void> saveDisplayName(String name) async {
    _displayName = name;
  }
}

