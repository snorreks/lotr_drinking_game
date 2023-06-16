import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../common/base_service.dart';
import '../../constants/boxes.dart';

/// Reads and Writes the application preferences by using [Hive]
///
/// The different preferences are locale, offline, shuffle, repeat, firstLaunched, streaming/downloading Quality

abstract class PreferencesServiceModel {
  bool get initialized;

  bool get soundEnabled;

  set soundEnabled(bool value);

  Future<void> initialize();
}

class PreferencesService extends BaseService
    implements PreferencesServiceModel {
  // Variables
  Box<dynamic>? _box;
  bool _initialized = false;
  @override
  bool get initialized => _initialized;

  static const String _soundEnabledKey = 'sound_enabled';

  // Getters
  @override
  bool get soundEnabled => _box?.get(_soundEnabledKey) as bool? ?? true;

  @override
  set soundEnabled(bool? value) => _box?.put(_soundEnabledKey, value);

  @override
  Future<void> initialize() async {
    try {
      _box = await Hive.openBox<dynamic>(PreferencesBox);
      _initialized = true;
    } catch (e) {
      logError('initialize', e);
    }
  }
}

final Provider<PreferencesServiceModel> preferencesService =
    Provider<PreferencesServiceModel>((_) => PreferencesService());
