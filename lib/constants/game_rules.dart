import 'game_rule.dart';

class GameRules {
  static const String basicRules =
      'This drinking game works by there being collective rules, meaning rules effecting everyone and character-based rules, effecting only the specific character a player has chosen. When a "Take a drink" or a character-based rule occurs, take only a singular drink out of your drink and press the plus button. If a "Down the Hatch" rule occurs, you must finish whatever contents there are left in the vessel you pour your drink in. There are also additional rules, which are optional rules which the creator of the room selected. These can have varying effects, like having to take extra drinks, taking fewer drinks or being punished for breaking rules.';

  static const List<GameRule> normalRulesAllMovies = <GameRule>[
    GameRule(
      'There is a close up of the Eye of Sauron.',
      RuleDifficulty.medium,
    ),
    GameRule(
      'A main bad guy dies.',
      RuleDifficulty.easy,
    ),
    GameRule(
      'When victory is achieved in a battle, everyone raises a toast and '
      'takes a sip.',
      RuleDifficulty.easy,
    ),
    GameRule(
      'A character gives an epic speech or monologue.',
      RuleDifficulty.easy,
    ),
    GameRule(
      "A character says 'precious'.",
      RuleDifficulty.medium,
    ),
    GameRule(
      'When someone shares a fun fact or a meme about the movies, they force everyone else to drink one, but have to drink two themselves.',
      RuleDifficulty.easy,
    ),
    GameRule(
      'A scenic shot of New Zealand (Middle Earth) appears.',
      RuleDifficulty.hard,
    ),
  ];

  static const List<GameRule> normalRulesFellowship = <GameRule>[
    GameRule(
      'A character uses a non-English (non-common) language.',
      RuleDifficulty.easy,
    ),
  ];

  static const List<GameRule> normalRulesTwoTowers = <GameRule>[
    GameRule(
      "Someone says 'Saruman'.",
      RuleDifficulty.easy,
    ),
    GameRule(
      'Someone talks about Gondor or Rohan.',
      RuleDifficulty.medium,
    ),
    GameRule(
      'Gollum and Smeagol have a conversation.',
      RuleDifficulty.easy,
    ),
    GameRule(
      "There's a shot of the Uruk-hai marching or preparing for battle.",
      RuleDifficulty.hard,
    ),
  ];

  static const List<GameRule> normalRulesROTK = <GameRule>[
    GameRule(
      "Someone says 'Mordor'.",
      RuleDifficulty.medium,
    ),
    GameRule(
      "Someone says 'King'.",
      RuleDifficulty.easy,
    ),
    GameRule(
      'A hobbit talks about peace or returning home.',
      RuleDifficulty.medium,
    ),
    GameRule(
      "The Ring's inscription is shown or spoken.",
      RuleDifficulty.medium,
    ),
  ];

  /// Down the Hatch rules are big, shared story moments. They are intentionally
  /// easy so that every difficulty still sees them.
  static const List<GameRule> dthRules = <GameRule>[
    GameRule(
      'The fellowship is founded.',
      RuleDifficulty.easy,
    ),
    GameRule(
      'Someone returns... but whiter!',
      RuleDifficulty.easy,
    ),
    GameRule(
      'The wall falls.',
      RuleDifficulty.easy,
    ),
    GameRule(
      'The ring is destroyed (for those who are still alive).',
      RuleDifficulty.easy,
    ),
  ];

  static const List<RuleWithName> additionalRules = <RuleWithName>[
    RuleWithName(
      'The Eye of Sauron',
      'If a viewer (known as the sneaky hobbit) does not drink when clearly '
          'prompted to by the rules, another viewer (Sauron) may call the '
          "sneaky hobbit out. If another viewer agrees with Sauron's "
          'call-out, the sneaky hobbit has to drink two.',
      RuleDifficulty.easy,
    ),
    RuleWithName(
      'The Ringbearer',
      'The person with the most drinks is known as the Ringbearer. '
          'The Ringbearer may at will stop drinking or make others "carry them". '
          'Carrying them means that they will have to drink all the drinks they had to drink themselves',
      RuleDifficulty.easy,
    )
  ];

  static const Map<String, List<GameRule>> rulesFellowship =
      <String, List<GameRule>>{
    'Take a drink': normalRulesAllMovies,
    'Take a drink (Fellowship)': normalRulesFellowship,
    'Down the Hatch': dthRules,
  };

  static const Map<String, List<GameRule>> rulesTwoTowers =
      <String, List<GameRule>>{
    'Take a drink': normalRulesAllMovies,
    'Take a drink (Two Towers)': normalRulesTwoTowers,
    'Down the Hatch': dthRules,
  };

  static const Map<String, List<GameRule>> rulesROTK = <String, List<GameRule>>{
    'Take a drink': normalRulesAllMovies,
    'Take a drink (RotK)': normalRulesROTK,
    'Down the Hatch': dthRules,
  };

  static final List<GameRule> sipRulesFellowship = <GameRule>[
    ...normalRulesFellowship,
    ...normalRulesAllMovies,
  ];

  static final List<GameRule> sipRulesTwoTowers = <GameRule>[
    ...normalRulesTwoTowers,
    ...normalRulesAllMovies,
  ];

  static final List<GameRule> sipRulesROTK = <GameRule>[
    ...normalRulesROTK,
    ...normalRulesAllMovies,
  ];

  static Map<String, List<GameRule>> applicableRules(String currentMovie) {
    switch (currentMovie) {
      case 'Fellowship of the Ring':
        return rulesFellowship;
      case 'The Two Towers':
        return rulesTwoTowers;
      case 'Return of the King':
        return rulesROTK;
      default:
        return <String, List<GameRule>>{};
    }
  }
}

class RuleWithName {
  const RuleWithName(
    this.ruleName,
    this.ruleDescription,
    this.difficulty, {
    this.ruleExamples,
  });

  final String ruleName;
  final String ruleDescription;
  final RuleDifficulty difficulty;
  final List<String>? ruleExamples; //for later usage an formatting
}
