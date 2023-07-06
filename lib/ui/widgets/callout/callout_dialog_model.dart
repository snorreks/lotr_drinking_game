import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/base_view_model.dart';
import '../../../constants/characters.dart';
import '../../../constants/game_rules.dart';
import '../../../models/fellowship_member.dart';
import '../../../services/api/fellowship_service.dart';
import '../../../services/app/preferences_service.dart';

class CalloutViewModel extends BaseNotifierViewModel {
  CalloutViewModel(this._ref, this.selectedPlayer, this.currentMovie);

  FellowshipMember? selectedPlayer;
  String? currentMovie;
  String? selectedCategory;
  String? selectedRule;
  final Ref _ref;
  Character? get character => _ref.read(preferencesService).character;

  List<String> get categories =>
      GameRules.applicableRules(currentMovie ?? 'Fellowship of the Ring')
          .keys
          .toList();

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
        }
      case ('The Two Towers'):
        {
          rules = GameRules.rulesFellowship[selectedCategory];
          characterRules = selectedPlayer!.character.rulesTwoTowers;
        }
      case ('Return of the King'):
        {
          rules = GameRules.rulesFellowship[selectedCategory];
          characterRules = selectedPlayer!.character.rulesROTK;
        }
    }

    if (rules == null || selectedPlayer == null || characterRules == null) {
      return rules?.toSet().toList();
    }

    return <String>{...rules, ...characterRules}.toSet().toList();
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

final AutoDisposeChangeNotifierProviderFamily<CalloutViewModel, CalloutParams>
    calloutViewModel =
    ChangeNotifierProvider.family.autoDispose<CalloutViewModel, CalloutParams>(
  (AutoDisposeChangeNotifierProviderRef<Object?> ref, CalloutParams params) {
    final CalloutViewModel viewModel =
        CalloutViewModel(ref, params.selectedPlayer, params.currentMovie);
    return viewModel;
  },
);

class CalloutParams {
  CalloutParams({required this.selectedPlayer, required this.currentMovie});

  final FellowshipMember? selectedPlayer;
  final String? currentMovie;
}
