import 'package:flutter/material.dart' show ChangeNotifier;

import 'base_service.dart';

/// This is the base view model that all the view models extends.
///
/// It contains the Logger package to print clear and readable logs.
abstract class BaseViewModel extends BaseService {
  BaseViewModel({
    super.title,
  });
}

/// This is the base view model with ChangeNotifier that all base view models that needs change notifier extends.
///
/// It contains the all the [BaseViewModel] functions + busy
abstract class BaseNotifierViewModel extends BaseViewModel with ChangeNotifier {
  BaseNotifierViewModel({
    bool busy = false,
    super.title,
  })  : _busy = busy;

  bool _busy;
  bool _isDisposed = false;

  bool get busy => _busy;
  bool get isDisposed => _isDisposed;

  set busy(bool busy) {
    logInfo(
      'busy: '
      '$modelTitle is entering '
      '${busy ? 'busy' : 'free'} state',
    );
    _busy = busy;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    if (!isDisposed) {
      super.notifyListeners();
    } else {
      logWarning(
        'notifyListeners: Notify listeners called after '
        '$modelTitle has been disposed',
      );
    }
  }

  @override
  void dispose() {
    logInfo('dispose');
    _isDisposed = true;
    super.dispose();
  }
}
