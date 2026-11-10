import 'package:flutter_test/flutter_test.dart';
import 'package:lotr_drinking_game/constants/characters.dart';
import 'package:lotr_drinking_game/constants/game_rule.dart';
import 'package:lotr_drinking_game/constants/game_rules.dart';

void main() {
  group('RuleDifficulty', () {
    test('easy only includes easy rules', () {
      expect(
        RuleDifficulty.easy.includes(RuleDifficulty.easy),
        isTrue,
      );
      expect(
        RuleDifficulty.easy.includes(RuleDifficulty.medium),
        isFalse,
      );
      expect(
        RuleDifficulty.easy.includes(RuleDifficulty.hard),
        isFalse,
      );
    });

    test('medium includes easy and medium rules', () {
      expect(RuleDifficulty.medium.includes(RuleDifficulty.easy), isTrue);
      expect(RuleDifficulty.medium.includes(RuleDifficulty.medium), isTrue);
      expect(RuleDifficulty.medium.includes(RuleDifficulty.hard), isFalse);
    });

    test('hard includes every rule', () {
      for (final RuleDifficulty difficulty in RuleDifficulty.values) {
        expect(RuleDifficulty.hard.includes(difficulty), isTrue);
      }
    });

    test('fromValue falls back to easy for unknown values', () {
      expect(
        RuleDifficultyExtension.fromValue('medium'),
        RuleDifficulty.medium,
      );
      expect(
        RuleDifficultyExtension.fromValue('unknown'),
        RuleDifficulty.easy,
      );
      expect(RuleDifficultyExtension.fromValue(null), RuleDifficulty.easy);
    });
  });

  group('activeRules', () {
    const List<GameRule> rules = <GameRule>[
      GameRule('easy rule', RuleDifficulty.easy),
      GameRule('medium rule', RuleDifficulty.medium),
      GameRule('hard rule', RuleDifficulty.hard),
    ];

    test('filters rules by selected difficulty', () {
      expect(
          activeRuleTexts(rules, RuleDifficulty.easy), <String>['easy rule']);
      expect(
        activeRuleTexts(rules, RuleDifficulty.medium),
        <String>['easy rule', 'medium rule'],
      );
      expect(
        activeRuleTexts(rules, RuleDifficulty.hard),
        <String>['easy rule', 'medium rule', 'hard rule'],
      );
    });
  });

  group('rule sets', () {
    test('every character has easy rules for every movie', () {
      for (final Character character in Character.values) {
        for (final List<GameRule> rules in <List<GameRule>>[
          character.rulesFellowship,
          character.rulesTwoTowers,
          character.rulesROTK,
        ]) {
          expect(
            rules.any(
              (GameRule rule) => rule.difficulty == RuleDifficulty.easy,
            ),
            isTrue,
            reason: '${character.displayName} needs at least one easy rule.',
          );
        }
      }
    });

    test('every movie rule set has easy rules', () {
      for (final Map<String, List<GameRule>> movieRules
          in <Map<String, List<GameRule>>>[
        GameRules.rulesFellowship,
        GameRules.rulesTwoTowers,
        GameRules.rulesROTK,
      ]) {
        for (final List<GameRule> rules in movieRules.values) {
          expect(
            rules.any(
              (GameRule rule) => rule.difficulty == RuleDifficulty.easy,
            ),
            isTrue,
          );
        }
      }
    });

    test('down the hatch rules stay available on every difficulty', () {
      for (final RuleDifficulty difficulty in RuleDifficulty.values) {
        expect(
          activeRuleTexts(GameRules.dthRules, difficulty).length,
          GameRules.dthRules.length,
        );
      }
    });
  });
}
