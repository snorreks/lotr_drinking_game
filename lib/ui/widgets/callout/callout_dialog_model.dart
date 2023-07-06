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

  String get currentMovie =>
      _ref.read(fellowshipService).fellowship!.currentMovie;

  List<FellowshipMember> get players =>
      (_ref.read(fellowshipService).fellowship?.membersList ??
              <FellowshipMember>[])
          .where((FellowshipMember element) =>
              element.character != _ref.read(preferencesService).character)
          .toList();

  List<String> get categories =>
      GameRules.applicableRules(currentMovie).keys.toList();

  List<String>? get rules {
    if (selectedCategory == null) {
      return null;
    }

    List<String>? rules;
    List<String>? characterRules;
    switch (currentMovie) {
      case ('Fellowship of the Ring'):
        {
          rules = GameRules.rulesFellowship[selectedCategory];
          characterRules = selectedPlayer!.character.rulesFellowship;
          break;
        }
      case ('The Two Towers'):
        {
          rules = GameRules.rulesTwoTowers[selectedCategory];
          characterRules = selectedPlayer!.character.rulesTwoTowers;
          break;
        }
      case ('Return of the King'):
        {
          rules = GameRules.rulesROTK[selectedCategory];
          characterRules = selectedPlayer!.character.rulesROTK;
          break;
        }
    }

    if (rules == null || selectedPlayer == null || characterRules == null) {
      return rules?.toSet().toList();
    }

    return <String>{...rules, ...characterRules}.toSet().toList();
  }

  bool get canSubmit => selectedRule != null && selectedPlayer != null;

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

  Future<void> sendCallout(WidgetRef ref) async {
    if (selectedPlayer == null || selectedRule == null) {
      return;
    }
    await ref
        .read(fellowshipService)
        .sendCallout(selectedPlayer!, selectedRule!);
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
