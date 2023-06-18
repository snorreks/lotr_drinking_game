class GameRules {
  static final List<String> normalRules = [
    //singular drink rules
    'There is a close up of the Eye of Sauron.',
    'A main bad guy dies',
    'When victory is achieved in a battle, everyone raises a toast and takes a sip.',
    'A character gives an epic speech or monologue.',
    'Memes like "One does not simply walk into Morodor", "You Shall Not Pass" or "...and my axe!"',
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
    RuleWithName('The Eye of Sauron', ''),
    RuleWithName("Sam's Sacrifice", 'Bruhnis'),
    RuleWithName('s', 'bruh'),
    RuleWithName('s', 'ruleDescription'),
    RuleWithName('s', 'ruleDescription'),
  ];
  static final List<RuleWithName> optionalRules = [
    RuleWithName('', 'ruleDescription'),
  ];
}

class RuleWithName {
  RuleWithName(this.ruleName, this.ruleDescription);
  String ruleName;
  String ruleDescription;
}
