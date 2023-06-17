import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/base_view_model.dart';
import '../../../constants/characters.dart';
import '../../../services/api/fellowship_service.dart';
import '../../../services/app/application_service.dart';

class CharacterViewModel extends BaseViewModel {
  CharacterViewModel(this._ref);
  final Ref _ref;

  List<Character> get characters => Character.values;

  Future<void> selectCharacter(Character character) async {
    const String username = 'Test';

    final bool responseOk = await _ref
        .read(fellowshipService)
        .selectCharacter(username: username, character: character);

    if (responseOk) {
      _ref.read(applicationService).refresh();
    }
  }

  bool isTaken(Character character) {
    return false;
  }
}

final AutoDisposeProvider<CharacterViewModel> homeViewModel =
    Provider.autoDispose((AutoDisposeProviderRef<CharacterViewModel> ref) {
  final CharacterViewModel viewModel = CharacterViewModel(ref);
  ref.onDispose(viewModel.dispose);
  return viewModel;
});
