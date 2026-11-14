import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

import '../../../common/base_view_model.dart';
import '../../../services/api/fellowship_service.dart';
import '../../../services/app/dialog_service.dart';
import '../../../services/app/router_service.dart';
import '../../../utils/validators.dart';

class LoginViewModel extends BaseViewModel {
  LoginViewModel(this._ref);
  final Ref _ref;

  // Variables
  final BehaviorSubject<bool?> _loadingSubject = BehaviorSubject<bool?>();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController sessionNameController = TextEditingController();

  final BehaviorSubject<String> _pinCodeSubject = BehaviorSubject<String>();
  final BehaviorSubject<String> _sessionNameSubject = BehaviorSubject<String>();

  // Stream getters
  Stream<String> get pinCode =>
      _pinCodeSubject.stream.transform(validatePinCode);
  Stream<String> get sessionName =>
      _sessionNameSubject.stream.transform(validateSessionName);
  Stream<bool?> get loadingStream => _loadingSubject.stream;

  // Stream transformers

  // Methods
  void changePinCode(String pinCode) => _pinCodeSubject.add(pinCode);
  void changeSessionName(String sessionName) =>
      _sessionNameSubject.add(sessionName);

  Future<void> submitJoin() async {
    _loadingSubject.add(true);
    try {
      final bool responseOk = await _ref
          .read(fellowshipService)
          .joinFellowship(pinCodeController.text);

      // Always stop loading and tell the player what went wrong, so a
      // failed join can never leave the screen stuck on the spinner.
      if (!responseOk) {
        _ref.read(dialogService).showNotification(const NotificationRequest(
              message:
                  'Fellowship not found. Double-check the PIN and try again.',
              type: NotificationType.error,
            ));
        _loadingSubject.add(false);
        return;
      }

      await _ref.read(routerService).go(Location.home);
    } catch (e) {
      logError('submitJoin', e);
      _ref.read(dialogService).showNotification(const NotificationRequest(
            message: 'Could not join the fellowship. Please try again.',
            type: NotificationType.error,
          ));
      _loadingSubject.add(false);
    }
  }

  Future<void> submitCreate() async {
    _loadingSubject.add(true);
    try {
      await _ref
          .read(fellowshipService)
          .createFellowship(sessionNameController.text);
      _ref.read(routerService).go(Location.home);
    } catch (e) {
      logError('submitCreate', e);
      _ref.read(dialogService).showNotification(const NotificationRequest(
            message: 'Could not create the fellowship. Please try again.',
            type: NotificationType.error,
          ));
      _loadingSubject.add(false);
    }
  }
}

final Provider<LoginViewModel> loginViewModel = Provider.autoDispose(
  (Ref ref) {
    final LoginViewModel viewModel = LoginViewModel(ref);
    ref.onDispose(viewModel.dispose);
    return viewModel;
  },
);
