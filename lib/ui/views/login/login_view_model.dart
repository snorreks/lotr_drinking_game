import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lotr_drinking_game/services/app/router_service.dart';
import 'package:rxdart/rxdart.dart';

import '../../../common/base_view_model.dart';
import '../../../services/api/auth_service.dart';
import '../../../utils/validators.dart';

class LoginViewModel extends BaseViewModel {
  LoginViewModel(this._ref);
  final Ref _ref;

  // Variables
  final BehaviorSubject<bool?> _loadingSubject = BehaviorSubject<bool?>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _emailSubject = BehaviorSubject<String>();
  final _passwordSubject = BehaviorSubject<String>();

  // Stream getters
  Stream<String> get email => _emailSubject.stream.transform(validateEmail);
  Stream<String> get password =>
      _passwordSubject.stream.transform(validatePassword);

  Stream<bool> get isValid =>
      CombineLatestStream.combine2(email, password, (_, __) => true);

  // Change data
  Function(String) get changeEmail => _emailSubject.sink.add;
  Function(String) get changePassword => _passwordSubject.sink.add;

  // Streams
  Stream<bool?> get loadingStream => _loadingSubject.stream;

  bool get _isLoading => _loadingSubject.hasValue && _loadingSubject.value!;

  // Functions
  Future<void> submit() async {
    if (_isLoading) {
      return;
    }
    _loadingSubject.add(true);
    try {
      const email = '';
      const password = '';

      await _ref.read(authService).signIn(email: email, password: password);

      await _ref.read(routerService).go(Location.home);
    } catch (e) {
      logError('submit', e);
    }
    _loadingSubject.add(false);
  }

  @override
  void dispose() {
    _loadingSubject.close();
    _emailSubject.close();
    _passwordSubject.close();
    super.dispose();
  }
}

final AutoDisposeProvider<LoginViewModel> loginViewModel = Provider.autoDispose(
  (AutoDisposeProviderRef<LoginViewModel> ref) {
    final LoginViewModel viewModel = LoginViewModel(ref);
    ref.onDispose(viewModel.dispose);
    return viewModel;
  },
);
