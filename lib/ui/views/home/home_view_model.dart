import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/base_view_model.dart';
import '../../../services/api/auth_service.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel(this._ref);
  final Ref _ref;

  Future<void> signOut() async {
    _ref.read(authService).signOut();
  }
}

final AutoDisposeProvider<HomeViewModel> homeViewModel =
    Provider.autoDispose((AutoDisposeProviderRef<HomeViewModel> ref) {
  final HomeViewModel viewModel = HomeViewModel(ref);
  ref.onDispose(viewModel.dispose);
  return viewModel;
});
