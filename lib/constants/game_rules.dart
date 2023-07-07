class GameRules {
  static const String basicRules =
      'This drinking game works by there being collective rules, meaning rules effecting everyone and character-based rules, effecting only the specific character a player has chosen. When a "Take a drink" or a character-based rule occurs, take only a singular drink out of your drink and press the plus button. If a "Down the Hatch" rule occurs, you must finish whatever contents there are left in the vessel you pour your drink in. There are also additional rules, which are optional rules which the creator of the room selected. These can have varying effects, like having to take extra drinks, taking fewer drinks or being punished for breaking rules.';

  static final List<String> normalRulesAllMovies = <String>[
    'There is a close up of the Eye of Sauron.',
    'A main bad guy dies',
    'When victory is achieved in a battle, everyone raises a toast and takes a sip.',
    'A character gives an epic speech or monologue.',
    'Memes like "One does not simply walk into Mordor", "You Shall Not Pass" or "...and my axe!"',
  ];

  static final List<String> normalRulesFellowship = <String>[
    //singular drink rules
    "A character says 'precious'.",
    'A character uses a non-English (non-common) language.',
    'A scenic shot of New Zealand (Middle Earth) appears.'
  ];

  static final List<String> normalRulesTwoTowers = <String>[
    "Someone says 'Saruman' or 'Orthanc'.",
    'Someone talks about Gondor.',
    'Gollum and Smeagol have a conversation.',
    "Someone talks about the 'old world' passing.",
    "There's a shot of the Uruk-hai marching or preparing for battle."
  ];

  static final List<String> normalRulesROTK = <String>[
    "Someone says 'Mordor'.",
    "The phrase 'Return of the King' is spoken.",
    'A hobbit talks about peace or returning home.',
    "The Ring's inscription is shown or spoken.",
  ];

  static final List<String> dthRules = <String>[
    //down the hatch rules
    'The fellowship is founded.',
    'Gandalf the White debuts.',
    'The wall falls.',
    'The ring is destroyed (for those who are still alive)',
  ];
  static final List<RuleWithName> additionalRules = <RuleWithName>[
    //Rules like The Aid of Gondor and the Eye of Sauron
    RuleWithName('The Eye of Sauron',
        "If a viewer (known as the sneaky hobbit) does not drink when clearly prompted to by the rules, another viewer (Sauron) may call the sneaky hobbit out. If the other viewers agree with Sauron's call-out, the sneaky hobbit has to drink two."),
    RuleWithName("Sam's Sacrifice",
        'If a viewer is starting to struggle handling their mead, they may request the aid of the rest of the group. Only one viewer may accept the burden of the additional drinks, known as “the Saviour”. The Saviour will temporarily take over the drinks of the viewer who struggled, now known as the Milkdrinker, for an agreed upon amount. \nThe Saviour should maintain count over the amount of drinks they have saved. Per 5 swigs of the bottle the Saviour has decided to take upon, they are rewarded with 1 (one) rescue dice. \nIf the Saviour has saved someone three or more times, they may invoke “the Aid of Gondor” from the particular Milkdrinker.'),
    RuleWithName('The Aid of Gondor',
        'If a Saviour has granted their aid to someone more than three times, they may invoke the Aid of Gondor. The Aid of Gondor is a non-conditional save, granted due to the particular heroics performed by this Saviour. The Saviour may conditionally ask the specific Milkdrinker that has called upon their aid before to save maximally half the amount of drinks they have taken for the Milkdrinker. '),
    RuleWithName("Boromir's Betrayal",
        "If a player fails to uphold their duties in the game, breaks a rule, or simply cannot keep up with the drinking pace, they have committed a 'Boromir's Betrayal'. This rule serves to encourage good-natured competition and camaraderie, much like the Fellowship itself."),
    RuleWithName(
      'Rescue Dice',
      "Rescue dice are for when you are close to your limit. Each movie, you are granted two or three (depending on movie length) six-sided die (hitherto referred to as a 'd6'). These d6's can be rolled upon desire to skip the following amount of drinks that the dice show.\nThe dice also have the 'rollover' property, meaning that any dice which were unused during a movie, may be brought over to the next.",
    ),

    RuleWithName('Rescue Dice poker',
        'Upon the start of each movie, a viewer may call for a round of merry Rescue Dice Poker (RDP). RDP works as five card draw poker does, except what you may bet is the rescue die which will be used for the following film. This includes rollover dice. \nBefore the start of the movie, you count up your total of rescue dice. This value will be converted into a set of poker chips, where each rescue dice is a red chip. These may be broken down into blue, green and white chips. A regular game of poker will commence. The game has to last a minimum of two rounds around the table before pulling out, unless someone has lost all their rescue dice.\nParticipation is voluntary.'),
  ];

  static final Map<String, List<String>> rulesFellowship =
      <String, List<String>>{
    'Take a drink': normalRulesAllMovies,
    'Take a drink (Fellowship)': normalRulesFellowship,
    'Down the Hatch': dthRules,
  };
  static final Map<String, List<String>> rulesTwoTowers =
      <String, List<String>>{
    'Take a drink': normalRulesAllMovies,
    'Take a drink (Two Towers)': normalRulesFellowship,
    'Down the Hatch': dthRules,
  };
  static final Map<String, List<String>> rulesROTK = <String, List<String>>{
    'Take a drink': normalRulesAllMovies,
    'Take a drink (RotK)': normalRulesFellowship,
    'Down the Hatch': dthRules,
  };

  static final List<String> sipRulesFellowship =
      List.from(normalRulesFellowship)..addAll(normalRulesAllMovies);
  static final List<String> sipRulesTwoTowers = List.from(normalRulesTwoTowers)
    ..addAll(normalRulesAllMovies);
  static final List<String> sipRulesROTK = List.from(normalRulesROTK)
    ..addAll(normalRulesAllMovies);

  static Map<String, List<String>> applicableRules(String currentMovie) {
    switch (currentMovie) {
      case 'Fellowship of the Ring':
        return rulesFellowship;
      case 'The Two Towers':
        return rulesTwoTowers;
      case 'Return of the King':
        return rulesROTK;
      default:
        return <String,
            List<
                String>>{}; // Return an empty map as default (or you may choose to handle this differently)
    }
  }
}

class RuleWithName {
  RuleWithName(this.ruleName, this.ruleDescription);
  String ruleName;
  String ruleDescription;
  List<String>? ruleExamples; //for later usage an formatting
}
