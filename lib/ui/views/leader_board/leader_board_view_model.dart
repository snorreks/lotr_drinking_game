import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/base_view_model.dart';
import '../../../constants/characters.dart';
import '../../../models/fellowship.dart';
import '../../../services/api/fellowship_service.dart';
import '../../../services/app/preferences_service.dart';

class LeaderBoardViewModel extends BaseViewModel {
  LeaderBoardViewModel(this._ref);
  final Ref _ref;

  Character? get character => _ref.read(preferencesService).character;

  bool get showCharacterSelectView => character == null;

  Stream<Fellowship?> get fellowshipStream =>
      _ref.read(fellowshipService).fellowshipStream;
}

final AutoDisposeProvider<LeaderBoardViewModel> leaderBoardViewModel =
    Provider.autoDispose((AutoDisposeProviderRef<LeaderBoardViewModel> ref) {
  final LeaderBoardViewModel viewModel = LeaderBoardViewModel(ref);
  ref.onDispose(viewModel.dispose);
  return viewModel;
});