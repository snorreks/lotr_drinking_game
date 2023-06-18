class GameRules {
  static final List<String> normalRules = [
    //singular drink rules
    'There is a close up of the Eye of Sauron.',
    'A main bad guy dies',
    'When victory is achieved in a battle, everyone raises a toast and takes a sip.',
    'A character gives an epic speech or monologue.',
    'Memes like "One does not simply walk into Mordor", "You Shall Not Pass" or "...and my axe!"',
  ];
  static final List<String> dthRules = [
    //down the hatch rules
    'The fellowship is founded.',
    'Gandalf the White debuts.',
    'The wall falls.',
    'The ring is destroyed (for those who are still alive)',
  ];
  static final List<RuleWithName> additionalRules = [
    //Rules like The Aid of Gondor and the Eye of Sauron
    RuleWithName('The Eye of Sauron',
        "If a viewer (known as the sneaky hobbit) does not drink when clearly prompted to by the rules, another viewer (Sauron) may call the sneaky hobbit out. If the other viewers agree with Sauron's call-out, the sneaky hobbit has to drink two."),
    RuleWithName("Sam's Sacrifice",
        'If a viewer is starting to struggle handling their mead, they may request the aid of the rest of the group. Only one viewer may accept the burden of the additional drinks, known as “the Saviour”. The Saviour will temporarily take over the drinks of the viewer who struggled, now known as the Milkdrinker, for an agreed upon amount. \nThe Saviour should maintain count over the amount of drinks they have saved. Per 5 swigs of the bottle the Saviour has decided to take upon, they are rewarded with 1 (one) rescue dice. \nIf the Saviour has saved someone three or more times, they may invoke “the Aid of Gondor” from the particular Milkdrinker.'),
    RuleWithName('The Aid of Gondor',
        'If a Saviour has granted their aid to someone more than three times, they may invoke the Aid of Gondor. The Aid of Gondor is a non-conditional save, granted due to the particular heroics performed by this Saviour. The Saviour may conditionally ask the specific Milkdrinker that has called upon their aid before to save maximally half the amount of drinks they have taken for the Milkdrinker. '),
    RuleWithName("Boromir's Betrayal",
        "If a player fails to uphold their duties in the game, breaks a rule, or simply cannot keep up with the drinking pace, they have committed a 'Boromir's Betrayal'. This rule serves to encourage good-natured competition and camaraderie, much like the Fellowship itself."),
    RuleWithName('Rescue Dice', 'ruleDescription'),
    RuleWithName('Rescue Dice poker', 'ruleDescription'),
  ];
  static final List<RuleWithName> optionalRules = [
    RuleWithName('', 'ruleDescription'),
  ];
}

class RuleWithName {
  RuleWithName(this.ruleName, this.ruleDescription);
  String ruleName;
  String ruleDescription;
  String? ruleExamples;
}
