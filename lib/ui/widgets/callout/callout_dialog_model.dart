import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/base_view_model.dart';
import '../../../constants/characters.dart';
import '../../../constants/game_rules.dart';
import '../../../models/fellowship_member.dart';
import '../../../services/api/fellowship_service.dart';
import '../../../services/app/preferences_service.dart';

class CalloutViewModel extends BaseNotifierViewModel {
  CalloutViewModel(this._ref, this.selectedPlayer);

  FellowshipMember? selectedPlayer;
  String? selectedCategory;
  String? selectedRule;
  final Ref _ref;
  Character? get character => _ref.read(preferencesService).character;

  List<String> get categories => GameRules.rules.keys.toList();

  List<String>? get rules {
    if (selectedCategory == null) {
      return null;
    }
    final List<String>? rules = GameRules.rules[selectedCategory];
    if (rules == null || selectedPlayer == null) {
      return rules?.toSet().toList();
    }

    return <String>{...rules, ...selectedPlayer!.character.rules}
        .toSet()
        .toList();
  }

  List<FellowshipMember> get players =>
      (_ref.read(fellowshipService).fellowship?.membersList ??
              <FellowshipMember>[])
          .where((FellowshipMember element) =>
              element.character != _ref.read(preferencesService).character)
          .toList();

  bool get canSubmit => selectedRule != null && selectedPlayer != null;

  Future<void> sendCallout() async {
    if (selectedPlayer == null || selectedRule == null) {
      return;
    }

    busy = true;
    await _ref
        .read(fellowshipService)
        .sendCallout(selectedPlayer!, selectedRule!);
    busy = false;
  }

  void selectPlayer(FellowshipMember? player) {
    selectedPlayer = player;
    notifyListeners();
  }

  void selectCategory(String? category) {
    selectedCategory = category;
    notifyListeners();
  }

  void selectRule(String? rule) {
    selectedRule = rule;
    notifyListeners();
  }
}

final AutoDisposeChangeNotifierProviderFamily<CalloutViewModel,
        FellowshipMember?> calloutViewModel =
    ChangeNotifierProvider.family.autoDispose(
        (AutoDisposeChangeNotifierProviderRef<Object?> ref,
            FellowshipMember? selectedPlayer) {
  final CalloutViewModel viewModel = CalloutViewModel(ref, selectedPlayer);
  return viewModel;
});
