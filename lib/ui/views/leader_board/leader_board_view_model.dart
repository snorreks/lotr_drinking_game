import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/base_view_model.dart';
import '../../../constants/characters.dart';
import '../../../models/fellowship.dart';
import '../../../models/fellowship_member.dart';
import '../../../services/api/fellowship_service.dart';
import '../../../services/app/dialog_service.dart';

class LeaderBoardViewModel extends BaseViewModel {
  LeaderBoardViewModel(this._ref);
  final Ref _ref;

  Character? get currentCharacter => _ref.read(fellowshipService).character;

  Stream<Fellowship?> get fellowshipStream =>
      _ref.read(fellowshipService).fellowshipStream;

  void showCalloutDialog(FellowshipMember player) {
    _ref.read(dialogService).showCalloutDialog(player);
  }
}

final AutoDisposeProvider<LeaderBoardViewModel> leaderBoardViewModel =
    Provider.autoDispose((AutoDisposeProviderRef<LeaderBoardViewModel> ref) {
  final LeaderBoardViewModel viewModel = LeaderBoardViewModel(ref);
  ref.onDispose(viewModel.dispose);
  return viewModel;
});
