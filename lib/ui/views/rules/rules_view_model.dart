import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/base_view_model.dart';
import '../../../constants/characters.dart';
import '../../../models/fellowship.dart';
import '../../../services/api/fellowship_service.dart';
import '../../../services/app/preferences_service.dart';
import '../../../services/app/router_service.dart';

class RulesViewModel extends BaseViewModel {
  RulesViewModel(this._ref);
  final Ref _ref;

  Character? get character => _ref.read(preferencesService).character;

  Stream<bool> get showCharacterSelectStream => _ref
      .read(fellowshipService)
      .characterStream
      .map((Character? character) => character == null);

  Stream<Fellowship?> get fellowshipStream =>
      _ref.read(fellowshipService).fellowshipStream;

  Future<void> signOut() async {
    await _ref.read(fellowshipService).leaveFellowship();
    _ref.read(routerService).go(Location.login);
  }

  Future<void> incrementDrink() {
    return _ref.read(fellowshipService).incrementDrink();
  }
}

final AutoDisposeProvider<RulesViewModel> rulesViewModel =
    Provider.autoDispose((AutoDisposeProviderRef<RulesViewModel> ref) {
  final RulesViewModel viewModel = RulesViewModel(ref);
  ref.onDispose(viewModel.dispose);
  return viewModel;
});
