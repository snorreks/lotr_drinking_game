import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/characters.dart';
import '../../../constants/game_rules.dart';
import '../../../models/fellowship_member.dart';
import '../../../services/api/fellowship_service.dart';
import '../../../services/app/preferences_service.dart';

class CalloutViewModel extends StateNotifier<CalloutParams> {
  CalloutViewModel(
    this._preferencesService,
    this._fellowshipService,
    CalloutParams params,
  ) : super(params);

  final PreferencesServiceModel _preferencesService;
  final FellowshipServiceModel _fellowshipService;

  FellowshipMember? get selectedPlayer => state.selectedPlayer;
  String? get currentMovie => state.currentMovie;
  String? get selectedCategory => state.selectedCategory;
  String? get selectedRule => state.selectedRule;

  Character? get character => _preferencesService.character;

  List<FellowshipMember> get players =>
      (_fellowshipService.fellowship?.membersList ?? <FellowshipMember>[])
          .where((FellowshipMember element) =>
              element.character != _preferencesService.character)
          .toList();

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
    print(state.selectedPlayer);
    state = state.copyWith(selectedPlayer: player);
    print(state.selectedPlayer);
  }

  void selectRule(String? rule) {
    print(state.selectedRule);
    state = state.copyWith(selectedRule: rule);
    print(state.selectedRule);
  }

  void selectCategory(String? category) {
    print(state.selectedCategory);
    state = state.copyWith(selectedCategory: category);
    print(state.selectedCategory);
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

final AutoDisposeStateNotifierProviderFamily<CalloutViewModel, CalloutParams,
        CalloutParams> calloutViewModel =
    StateNotifierProvider.family
        .autoDispose<CalloutViewModel, CalloutParams, CalloutParams>(
  (AutoDisposeStateNotifierProviderRef<CalloutViewModel, CalloutParams> ref,
      CalloutParams params) {
    final PreferencesServiceModel prefs = ref.watch(preferencesService);
    final FellowshipServiceModel fellowship = ref.watch(fellowshipService);
    return CalloutViewModel(prefs, fellowship, params);
  },
);

class CalloutParams {
  CalloutParams({
    this.selectedPlayer,
    this.currentMovie,
    this.selectedCategory,
    this.selectedRule,
  });

  final FellowshipMember? selectedPlayer;
  final String? currentMovie;
  final String? selectedCategory;
  final String? selectedRule;

  CalloutParams copyWith({
    FellowshipMember? selectedPlayer,
    String? currentMovie,
    String? selectedCategory,
    String? selectedRule,
  }) {
    return CalloutParams(
      selectedPlayer: selectedPlayer ?? this.selectedPlayer,
      currentMovie: currentMovie ?? this.currentMovie,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedRule: selectedRule ?? this.selectedRule,
    );
  }
}
