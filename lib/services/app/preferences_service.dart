import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../common/base_service.dart';
import '../../constants/characters.dart';

/// Reads and Writes the application preferences by using [Hive]
///
/// The different preferences are locale, offline, shuffle, repeat, firstLaunched, streaming/downloading Quality

abstract class PreferencesServiceModel {
  bool get initialized;

  String? get fellowshipId;
  String? get fellowshipPin;
  set fellowshipId(String? value);
  set fellowshipPin(String? value);

  /// If isDarkMode is true, the theme is dark
  /// If isDarkMode is false, the theme is light
  /// If isDarkMode is null, the theme is system
  bool? get isDarkMode;
  set isDarkMode(bool? value);

  Character? get character;
  set character(Character? value);

  void setBox(Box<dynamic> box);
}

class PreferencesService extends BaseService
    implements PreferencesServiceModel {
  // Variables
  Box<dynamic>? _box;
  bool _initialized = false;
  @override
  bool get initialized => _initialized;

  static const String _fellowshipIdKey = 'fellowship_id';
  static const String _isDarkModeKey = 'is_dark_mode';
  static const String _characterKey = 'character';
  static const String _fellowshipPin = 'fellowship_pin';

  @override
  String? get fellowshipId => _box?.get(_fellowshipIdKey) as String?;
  @override
  set fellowshipId(String? value) => _box?.put(_fellowshipIdKey, value);

  @override
  String? get fellowshipPin => _box?.get(_fellowshipPin) as String?;
  @override
  set fellowshipPin(String? value) => _box?.put(_fellowshipPin, value);

  @override
  bool? get isDarkMode => _box?.get(_isDarkModeKey) as bool?;
  @override
  set isDarkMode(bool? value) => _box?.put(_isDarkModeKey, value);

  @override
  Character? get character {
    final String? stringValue = _box?.get(_characterKey) as String?;
    return stringValue != null
        ? CharacterExtension.fromValue(stringValue)
        : null;
  }

  @override
  set character(Character? value) => _box?.put(_characterKey, value?.value);

  @override
  Future<void> setBox(Box<dynamic> box) async {
    if (_box != null) {
      return;
    }

    _box = box;
    _initialized = true;
  }
}

final Provider<PreferencesServiceModel> preferencesService =
    Provider<PreferencesServiceModel>((_) => PreferencesService());
