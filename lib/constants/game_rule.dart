import 'package:flutter/material.dart';

/// The difficulty of a single game rule.
///
/// [easy] rules are always available. Selecting a higher difficulty also
/// includes all rules from the lower difficulties.
enum RuleDifficulty {
  easy,
  medium,
  hard,
}

extension RuleDifficultyExtension on RuleDifficulty {
  String get value => name;

  int get level {
    switch (this) {
      case RuleDifficulty.easy:
        return 0;
      case RuleDifficulty.medium:
        return 1;
      case RuleDifficulty.hard:
        return 2;
    }
  }

  String get displayName {
    switch (this) {
      case RuleDifficulty.easy:
        return 'Easy';
      case RuleDifficulty.medium:
        return 'Medium';
      case RuleDifficulty.hard:
        return 'Hard';
    }
  }

  String get description {
    switch (this) {
      case RuleDifficulty.easy:
        return 'The core rules everyone plays with. These are always available.';
      case RuleDifficulty.medium:
        return 'Everything from Easy, plus more frequent and challenging rules.';
      case RuleDifficulty.hard:
        return 'Every rule, including the fastest, most complex and most '
            'punishing ones.';
    }
  }

  Color get color {
    switch (this) {
      case RuleDifficulty.easy:
        return Colors.green;
      case RuleDifficulty.medium:
        return Colors.orange;
      case RuleDifficulty.hard:
        return Colors.red;
    }
  }

  IconData get icon {
    switch (this) {
      case RuleDifficulty.easy:
        return Icons.sports_bar;
      case RuleDifficulty.medium:
        return Icons.local_bar;
      case RuleDifficulty.hard:
        return Icons.wine_bar;
    }
  }

  /// Whether rules of [other] difficulty are included when this difficulty is
  /// selected.
  bool includes(RuleDifficulty other) => other.level <= level;

  static RuleDifficulty fromValue(String? value) {
    switch (value) {
      case 'medium':
        return RuleDifficulty.medium;
      case 'hard':
        return RuleDifficulty.hard;
      case 'easy':
      default:
        return RuleDifficulty.easy;
    }
  }
}

/// A game rule together with the difficulty it belongs to.
class GameRule {
  const GameRule(this.text, this.difficulty);

  final String text;
  final RuleDifficulty difficulty;
}

/// Returns the rules that are active for [difficulty].
List<GameRule> activeRules(
  Iterable<GameRule> rules,
  RuleDifficulty difficulty,
) {
  return rules
      .where((GameRule rule) => difficulty.includes(rule.difficulty))
      .toList();
}

/// Returns the text of the rules that are active for [difficulty].
List<String> activeRuleTexts(
  Iterable<GameRule> rules,
  RuleDifficulty difficulty,
) {
  return activeRules(rules, difficulty)
      .map((GameRule rule) => rule.text)
      .toList();
}
