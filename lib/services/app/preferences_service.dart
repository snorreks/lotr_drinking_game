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
  set fellowshipId(String? value);

  /// If isDarkMode is true, the theme is dark
  /// If isDarkMode is false, the theme is light
  /// If isDarkMode is null, the theme is system
  bool? get isDarkMode;
  set isDarkMode(bool? value);

  Character? get character;
  set character(Character? value);

  Future<void> initialize();
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

  @override
  String? get fellowshipId => _box?.get(_fellowshipIdKey) as String?;

  @override
  set fellowshipId(String? value) => _box?.put(_fellowshipIdKey, value);

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
  Future<void> initialize() async {
    try {
      _box = await Hive.openBox<dynamic>('preferences');
      _initialized = true;
    } catch (e) {
      logError('initialize', e);
    }
  }
}

final Provider<PreferencesServiceModel> preferencesService =
    Provider<PreferencesServiceModel>((_) => PreferencesService());
