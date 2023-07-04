import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/base_service.dart';

/// RemoteConfigService listens for RemoteConfig through FirebaseMessaging
abstract class RemoteConfigServiceModel {
  /// Initialize FirebaseMessaging to listen for RemoteConfigs.
  ///
  /// If the device is on iOS it request permissions for notification.
  Future<void> initialize();
  bool get featureEnabled;
}

class RemoteConfigService extends BaseService
    implements RemoteConfigServiceModel {
  RemoteConfigService(this._remoteConfig);
  final FirebaseRemoteConfig _remoteConfig;

  static const String featureEnabledKey = 'feature_enabled';

  @override
  bool get featureEnabled => _remoteConfig.getBool(featureEnabledKey);

  @override
  Future<void> initialize() async {
    try {
      await _remoteConfig.ensureInitialized();
      await _remoteConfig.setDefaults(<String, dynamic>{
        featureEnabledKey: false,
      });
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ));

      await _remoteConfig.fetchAndActivate();
    } catch (error) {
      logError('initialize', error);
    }
  }
}

final Provider<RemoteConfigServiceModel> remoteConfigService =
    Provider<RemoteConfigServiceModel>((
  ProviderRef<RemoteConfigServiceModel> ref,
) {
  final RemoteConfigService service =
      RemoteConfigService(FirebaseRemoteConfig.instance);
  return service;
});
