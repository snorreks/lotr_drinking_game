import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/base_view_model.dart';
import '../../../constants/characters.dart';
import '../../../models/fellowship.dart';
import '../../../services/api/fellowship_service.dart';
import '../../../services/app/preferences_service.dart';
import '../../../services/app/router_service.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel(this._ref);
  final Ref _ref;

  Character? get character => _ref.read(preferencesService).character;

  bool get showCharacterSelectView => character == null;

  Stream<Fellowship?> get fellowshipStream =>
      _ref.read(fellowshipService).fellowshipStream;

  Future<void> signOut() async {
    await _ref.read(fellowshipService).leaveFellowship();
    _ref.read(routerService).go(Location.login);
  }
}

final AutoDisposeProvider<HomeViewModel> homeViewModel =
    Provider.autoDispose((AutoDisposeProviderRef<HomeViewModel> ref) {
  final HomeViewModel viewModel = HomeViewModel(ref);
  ref.onDispose(viewModel.dispose);
  return viewModel;
});
