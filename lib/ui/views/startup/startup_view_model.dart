import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../common/base_view_model.dart';
import '../../../firebase_options.dart';
import '../../../services/api/fellowship_service.dart';
import '../../../services/api/remote_config_service.dart';
import '../../../services/app/application_service.dart';
import '../../../services/app/preferences_service.dart';
import '../../../services/app/router_service.dart';

class StartupViewModel extends BaseViewModel {
  StartupViewModel(this._ref);

  final Ref _ref;

  Future<void> initialize() async {
    // To prevent re initializing after hot reload
    if (_ref.read(applicationService).initialized) {
      return _redirect();
    }

    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    if (!kIsWeb) {
      if (kDebugMode) {
        // Force disable Crashlytics collection while doing every day development.
        // Temporarily toggle this to true if you want to test crash reporting in your app.
        await FirebaseCrashlytics.instance
            .setCrashlyticsCollectionEnabled(false);
      } else {
        FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      }
    }
    await Hive.initFlutter();

    await _ref.read(remoteConfigService).initialize();
    await _ref.read(remoteConfigService).checkAppVersion();
    await _ref.read(preferencesService).initialize();
    await _ref.read(applicationService).initialize();

    await _redirect();
  }

  Future<void> _redirect() {
    return _ref.read(fellowshipService).hasJoinedFellowship
        ? _ref.read(routerService).go<void>(Location.home)
        : _ref.read(routerService).go<void>(Location.login);
  }
}

final AutoDisposeProvider<StartupViewModel> startupViewModel =
    Provider.autoDispose(
  (AutoDisposeProviderRef<StartupViewModel> ref) => StartupViewModel(ref),
);
