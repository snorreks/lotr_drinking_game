import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/base_view_model.dart';
import '../../../constants/characters.dart';
import '../../../models/fellowship.dart';
import '../../../models/fellowship_member.dart';
import '../../../services/api/fellowship_service.dart';
import '../../../services/app/preferences_service.dart';

class HomeViewModel extends BaseNotifierViewModel {
  HomeViewModel(this._ref);

  final Ref _ref;
  Character? get character => _ref.read(preferencesService).character;

  Stream<bool> get showCharacterSelectStream => _ref
      .read(fellowshipService)
      .characterStream
      .map((Character? character) => character == null);

  Stream<Fellowship?> get fellowshipStream =>
      _ref.read(fellowshipService).fellowshipStream;

  Future<void> incrementDrink() async {
    await _ref.read(fellowshipService).incrementDrink();
  }

  Future<void> incrementDownTheHatch(int downTheHatchSips) async {
    for (int i = 0; i < downTheHatchSips; i++) {
      await _ref.read(fellowshipService).incrementDrink();
    }
  }

  Future<void> incrementSaves() async {
    await _ref.read(fellowshipService).incrementSaves();
  }

  Future<void> sendCallout(FellowshipMember player, String rule) async {
    await _ref.read(fellowshipService).sendCallout(player, rule);
  }

  Future<void> resolveCallout(bool hasAccepted) async {
    await _ref.read(fellowshipService).resolveCallout(hasAccepted);
  }
}

final AutoDisposeProvider<HomeViewModel> homeViewModel =
    Provider.autoDispose((AutoDisposeProviderRef<HomeViewModel> ref) {
  final HomeViewModel viewModel = HomeViewModel(ref);
  ref.onDispose(viewModel.dispose);
  return viewModel;
});
