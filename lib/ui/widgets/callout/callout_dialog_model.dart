import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../common/base_view_model.dart';
import '../../../constants/characters.dart';
import '../../../constants/game_rule.dart';
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
    final FellowshipMember? player = selectedPlayer;
    if (selectedCategory == null || player == null) {
      return null;
    }

    List<GameRule>? rules;
    List<GameRule>? characterRules;
    switch (currentMovie) {
      case ('Fellowship of the Ring'):
        {
          rules = GameRules.rulesFellowship[selectedCategory];
          characterRules = player.character.rulesFellowship;
          break;
        }
      case ('The Two Towers'):
        {
          rules = GameRules.rulesTwoTowers[selectedCategory];
          characterRules = player.character.rulesTwoTowers;
          break;
        }
      case ('Return of the King'):
        {
          rules = GameRules.rulesROTK[selectedCategory];
          characterRules = player.character.rulesROTK;
          break;
        }
    }

    if (rules == null) {
      return null;
    }

    return <String>{
      ...activeRuleTexts(rules, player.difficulty),
      ...activeRuleTexts(
        characterRules ?? <GameRule>[],
        player.difficulty,
      ),
    }.toList();
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

final ChangeNotifierProviderFamily<CalloutViewModel, FellowshipMember?>
    calloutViewModel = ChangeNotifierProvider.family
        .autoDispose((Ref ref, FellowshipMember? selectedPlayer) {
  final CalloutViewModel viewModel = CalloutViewModel(ref, selectedPlayer);
  return viewModel;
});
