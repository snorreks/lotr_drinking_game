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

  /// If darkModeEnabled is true, the theme is dark
  /// If darkModeEnabled is false, the theme is light
  /// If darkModeEnabled is null, the theme is system
  bool? get darkModeEnabled;
  set darkModeEnabled(bool? value);

  bool get zenModeEnabled;
  set zenModeEnabled(bool value);

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
  static const String _darkModeEnabledKey = 'dark_mode_enabled';
  static const String _zenModeEnabledKey = 'zen_mode_enabled';

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
  bool? get darkModeEnabled => _box?.get(_darkModeEnabledKey) as bool?;
  @override
  set darkModeEnabled(bool? value) => _box?.put(_darkModeEnabledKey, value);

  @override
  bool get zenModeEnabled =>
      _box?.get(_zenModeEnabledKey, defaultValue: false) as bool;
  @override
  set zenModeEnabled(bool value) => _box?.put(_zenModeEnabledKey, value);

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
