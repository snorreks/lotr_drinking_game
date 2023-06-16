import 'package:flutter/material.dart' show ChangeNotifier, ThemeData;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/base_service.dart';
import '../../ui/theme/light_theme.dart';

/// ApplicationService contains the state of the application.
///
/// The states that are stored in the provider are the locale, theme, deviceType, firstLaunched and initialized.
abstract class ApplicationServiceModel implements ChangeNotifier {
  bool get initialized;

  ThemeData get themeData;

  Future<void> initialize();
}

class ApplicationService extends BaseService
    with ChangeNotifier
    implements ApplicationServiceModel {
  ApplicationService(this._read);

  final Ref _read;

  @override
  bool get initialized => _initialized;

  bool _initialized = false;

  @override
  ThemeData get themeData => lightTheme;

  @override
  Future<void> initialize() async {
    _initialized = true;
    notifyListeners();
    return Future<void>.value();
  }
}

final ChangeNotifierProvider<ApplicationServiceModel> applicationService =
    ChangeNotifierProvider<ApplicationServiceModel>(
  (ChangeNotifierProviderRef<ApplicationServiceModel> ref) =>
      ApplicationService(ref),
);
