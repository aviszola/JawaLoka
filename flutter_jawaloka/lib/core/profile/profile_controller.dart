import 'package:flutter/foundation.dart';
import '../../features/profile/presentation/widgets/blangkon_painter.dart';
import 'profile_preferences.dart';

/// Controller managing user profile state (equipped Blangkon and display name).
///
/// Follows the same pattern as [LocaleController] to ensure single-source of truth
/// without introducing third-party state management dependencies.
class ProfileController extends ChangeNotifier {
  final ProfilePreferences _preferences;

  BlangkonType _equippedBlangkon = BlangkonType.yogyakarta;
  // DATA CONTOH: nama bawaan "Dimas" dipakai sampai ada backend
  String _displayName = 'Dimas';
  bool _isInitialized = false;

  ProfileController({ProfilePreferences? preferences})
      : _preferences = preferences ?? SharedPrefsProfilePreferences();

  BlangkonType get equippedBlangkon => _equippedBlangkon;
  String get displayName => _displayName;
  bool get isInitialized => _isInitialized;

  /// Loads saved profile attributes from preferences.
  Future<void> loadProfile() async {
    _equippedBlangkon = await _preferences.loadEquippedBlangkon();
    _displayName = await _preferences.loadDisplayName();
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
}

