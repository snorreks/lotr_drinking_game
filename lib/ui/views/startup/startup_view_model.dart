import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lotr_drinking_game/services/app/preferences_service.dart';

import '../../../common/base_view_model.dart';
import '../../../firebase_options.dart';
import '../../../models/user.dart';
import '../../../services/api/auth_service.dart';
import '../../../services/app/application_service.dart';
import '../../../services/app/router_service.dart';

class StartupViewModel extends BaseViewModel {
  StartupViewModel(this._ref);

  final Ref _ref;
  // Getters

  Future<void> initialize() async {
    // try {
    // To prevent re initializing after hot reload
    if (_ref.read(applicationService).initialized) {
      return _navigateToView(await _ref.read(authService).getUserStatus());
    }

    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    // Initialize the preferences hive box
    await Hive.initFlutter();

    await _ref.read(preferencesService).initialize();
    await _ref.read(applicationService).initialize();

    // Get the status of the user and store user data if the user is logged in
    await _navigateToView(await _ref.read(authService).getUserStatus());
    // } catch (e) {
    //   logError('initialize', e);
    // }
  }

  Future<void> _navigateToView(UserStatus? userStatus) {
    if (userStatus == null) {
      return _ref.read(routerService).go<void>(Location.login);
    }
    return _ref.read(routerService).replace<void>(Location.home);
  }
}

final AutoDisposeProvider<StartupViewModel> startupViewModel =
    Provider.autoDispose(
  (AutoDisposeProviderRef<StartupViewModel> ref) => StartupViewModel(ref),
);
