import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/base_view_model.dart';
import '../../../constants/characters.dart';
import '../../../constants/game_rules.dart';

class RuleItem {
  RuleItem(this.title, {this.rules, this.subRuleItems})
      : assert(
          rules != null || subRuleItems != null,
          'Either rules or subRuleItems must be provided',
        );

  final String title;
  final List<String>? rules;
  final List<RuleItem>? subRuleItems;

  bool isExpanded = false;
}

class RulesViewModel extends BaseNotifierViewModel {
  final List<RuleItem> rules = <RuleItem>[
    RuleItem('Basics', rules: <String>[GameRules.basicRules]),
    RuleItem('Take a drink when', rules: GameRules.normalRules),
    RuleItem('Down the Hatch', rules: GameRules.dthRules),
    RuleItem(
      'Additional Rules',
      subRuleItems: GameRules.additionalRules
          .map((RuleWithName ruleWithName) => RuleItem(ruleWithName.ruleName,
              rules: <String>[ruleWithName.ruleDescription]))
          .toList(),
    ),
    RuleItem(
      'Character',
      subRuleItems: Character.values
          .map((Character character) =>
              RuleItem(character.displayName, rules: character.rules))
          .toList(),
    )
  ];

  void togglePanel(int index, bool isExpanded, {RuleItem? parent}) {
    if (parent != null && parent.subRuleItems != null) {
      parent.subRuleItems![index].isExpanded = !isExpanded;
    } else {
      rules[index].isExpanded = !isExpanded;
    }

    notifyListeners();
  }
}

final AutoDisposeChangeNotifierProvider<RulesViewModel> rulesViewModel =
    ChangeNotifierProvider.autoDispose(
        (AutoDisposeChangeNotifierProviderRef<RulesViewModel> ref) {
  final RulesViewModel viewModel = RulesViewModel();
  return viewModel;
});
