import 'package:flutter/material.dart'
    show ChangeNotifier, HeroController, ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/base_service.dart';
import 'preferences_service.dart';

export 'package:flutter/material.dart' show ThemeMode;

/// ApplicationService contains the state of the application.
///
/// The states that are stored in the provider are the locale, theme, deviceType, firstLaunched and initialized.
abstract class ApplicationServiceModel implements ChangeNotifier {
  bool get initialized;

  ThemeMode get themeMode;
  HeroController get heroController;

  void changeTheme(ThemeMode themeMode);

  Future<void> initialize();

  void refresh();
}

class ApplicationService extends BaseService
    with ChangeNotifier
    implements ApplicationServiceModel {
  ApplicationService(this._ref);

  final Ref _ref;

  @override
  final HeroController heroController = HeroController();

  @override
  bool get initialized => _initialized;

  bool _initialized = false;

  @override
  ThemeMode get themeMode {
    switch (_ref.read(preferencesService).isDarkMode) {
      case true:
        return ThemeMode.dark;
      case false:
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  bool? _getIsDarkMode(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.dark:
        return true;
      case ThemeMode.light:
        return false;
      case ThemeMode.system:
        return null;
    }
  }

  @override
  void changeTheme(ThemeMode themeMode) {
    _ref.read(preferencesService).isDarkMode = _getIsDarkMode(themeMode);
    notifyListeners();
  }

  @override
  void refresh() {
    notifyListeners();
  }

  @override
  Future<void> initialize() async {
    _initialized = true;
    if (themeMode != ThemeMode.system) {
      notifyListeners();
    }
  }
}

final ChangeNotifierProvider<ApplicationServiceModel> applicationService =
    ChangeNotifierProvider<ApplicationServiceModel>(
  (ChangeNotifierProviderRef<ApplicationServiceModel> ref) =>
      ApplicationService(ref),
);
