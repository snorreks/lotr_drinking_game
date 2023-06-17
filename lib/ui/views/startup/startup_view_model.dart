import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../common/base_view_model.dart';
import '../../../firebase_options.dart';
import '../../../services/api/fellowship_service.dart';
import '../../../services/app/application_service.dart';
import '../../../services/app/preferences_service.dart';
import '../../../services/app/router_service.dart';

class StartupViewModel extends BaseViewModel {
  StartupViewModel(this._ref);

  final Ref _ref;

  Future<void> initialize() async {
    // try {
    // To prevent re initializing after hot reload
    if (_ref.read(applicationService).initialized) {
      return _redirect();
    }

    // WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    // Initialize the preferences hive box
    await Hive.initFlutter();

    await _ref.read(preferencesService).initialize();
    await _ref.read(applicationService).initialize();

    // Get the status of the user and store user data if the user is logged in
    await _redirect();
    // } catch (e) {
    //   logError('initialize', e);
    // }
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
