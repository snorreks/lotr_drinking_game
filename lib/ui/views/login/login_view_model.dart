import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lotr_drinking_game/services/app/router_service.dart';
import 'package:rxdart/rxdart.dart';

import '../../../common/base_view_model.dart';
import '../../../services/api/auth_service.dart';

class LoginViewModel extends BaseViewModel {
  LoginViewModel(this._ref);
  final Ref _ref;

  // Variables
  final BehaviorSubject<bool?> _loadingSubject = BehaviorSubject<bool?>();
  final BehaviorSubject<String?> _errorSubject = BehaviorSubject<String?>();

  // Streams
  Stream<bool?> get loadingStream => _loadingSubject.stream;

  bool get _isLoading => _loadingSubject.hasValue && _loadingSubject.value!;

  // Functions
  Future<void> submit() async {
    _errorSubject.add(null);
    if (_isLoading) {
      return;
    }
    _loadingSubject.add(true);
    try {
      const email = '';
      const password = '';

      await _ref.read(authService).signIn(email: email, password: password);

      await _ref.read(routerService).go('/');
    } catch (e) {
      logError('submit', e);
    }
    _loadingSubject.add(false);
  }

  @override
  void dispose() {
    _loadingSubject.close();
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
