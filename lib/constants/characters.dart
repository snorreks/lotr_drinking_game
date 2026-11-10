import 'package:flutter/material.dart';

import 'game_rule.dart';

enum Character {
  frodo,
  sam,
  merrypippin,
  gandalf,
  aragorn,
  legolas,
  gimli,
}

extension CharacterExtension on Character {
  String get value {
    switch (this) {
      case Character.frodo:
        return 'frodo';
      case Character.sam:
        return 'sam';
      case Character.merrypippin:
        return 'merrypippin';
      case Character.gandalf:
        return 'gandalf';
      case Character.aragorn:
        return 'aragorn';
      case Character.legolas:
        return 'legolas';
      case Character.gimli:
        return 'gimli';
    }
  }

  static Character fromValue(String value) {
    switch (value) {
      case 'frodo':
        return Character.frodo;
      case 'sam':
        return Character.sam;
      case 'merrypippin':
        return Character.merrypippin;
      case 'gandalf':
        return Character.gandalf;
      case 'aragorn':
        return Character.aragorn;
      case 'legolas':
        return Character.legolas;
      case 'gimli':
        return Character.gimli;
      default:
        throw Exception('Invalid character');
    }
  }

  String get displayName {
    switch (this) {
      case Character.frodo:
        return 'Frodo';
      case Character.sam:
        return 'Sam';
      case Character.merrypippin:
        return 'Merry & Pippin';
      case Character.gandalf:
        return 'Gandalf';
      case Character.aragorn:
        return 'Aragorn';
      case Character.legolas:
        return 'Legolas';
      case Character.gimli:
        return 'Gimli';
    }
  }

  List<GameRule> get rulesFellowship {
    switch (this) {
      case Character.frodo:
        return <GameRule>[
          const GameRule(
            'The ring affects his behavior.',
            RuleDifficulty.medium,
          ),
          const GameRule(
            'He mentions Bilbo.',
            RuleDifficulty.easy,
          ),
          const GameRule(
            'He offers the Ring to someone else.',
            RuleDifficulty.easy,
          ),
          const GameRule(
            'He trips over his own feet.',
            RuleDifficulty.hard,
          ),
        ];
      case Character.sam:
        return <GameRule>[
          const GameRule(
            'He says, “Mr Frodo”.',
            RuleDifficulty.medium,
          ),
          const GameRule(
            'He is clumsy or displays his lack of familiarity with adventuring.',
            RuleDifficulty.easy,
          ),
          const GameRule(
            "He's startled or scared.",
            RuleDifficulty.easy,
          ),
          const GameRule(
            'His dirty chewed-up nails or feet are in the shot.',
            RuleDifficulty.easy,
          ),
        ];
      case Character.merrypippin:
        return <GameRule>[
          const GameRule(
            'They cause trouble or create mischief.',
            RuleDifficulty.easy,
          ),
          const GameRule(
            'They talk about food.',
            RuleDifficulty.easy,
          ),
          const GameRule(
            'They are drinking or eating.',
            RuleDifficulty.easy,
          ),
          const GameRule(
            'They manage to make a seemingly hopeless situation '
            'light-hearted.',
            RuleDifficulty.medium,
          ),
          const GameRule(
            'They dump exposition to the audience.',
            RuleDifficulty.medium,
          ),
        ];
      case Character.gandalf:
        return <GameRule>[
          const GameRule(
            'He lights up his pipe (Give one to another person if he is '
            'smoking with someone).',
            RuleDifficulty.medium,
          ),
          const GameRule(
            'Drink when he refers to someone by their full name.',
            RuleDifficulty.easy,
          ),
          const GameRule(
            'Drink when he actually uses magic.',
            RuleDifficulty.easy,
          ),
          const GameRule(
            'Drink whenever he mysteriously disappears or appears without '
            'clear explanation.',
            RuleDifficulty.medium,
          ),
          const GameRule(
            'Drink whenever he calls on the name of a higher power like '
            '"Elbereth", "Mithrandir", or "Udun".',
            RuleDifficulty.easy,
          ),
        ];
      case Character.aragorn:
        return <GameRule>[
          const GameRule(
            'He lights up his pipe.',
            RuleDifficulty.easy,
          ),
          const GameRule(
            'He refers to someone as "Mr.", like "Mr. Underhill".',
            RuleDifficulty.easy,
          ),
          const GameRule(
            'He unsheathes his sword.',
            RuleDifficulty.easy,
          ),
          const GameRule(
            'He appreciates something elvish.',
            RuleDifficulty.easy,
          ),
        ];
      case Character.legolas:
        return <GameRule>[
          const GameRule(
            "He uses his bow (extra sip if it's a major action scene).",
            RuleDifficulty.hard,
          ),
          const GameRule(
            'His hair blows dramatically in the wind.',
            RuleDifficulty.easy,
          ),
          const GameRule(
            'He is staring in the distance, double if he identifies or warns '
            'of an approaching danger before anyone else.',
            RuleDifficulty.medium,
          ),
        ];
      case Character.gimli:
        return <GameRule>[
          const GameRule(
            'He says “dwarf” or “elf”.',
            RuleDifficulty.hard,
          ),
          const GameRule(
            "He's used as a comic relief (Beware of the Director's Cut).",
            RuleDifficulty.easy,
          ),
          const GameRule(
            'He grumbles or complains.',
            RuleDifficulty.easy,
          ),
          const GameRule(
            'He mentions his father, ancestors or the skill of dwarves.',
            RuleDifficulty.medium,
          ),
          const GameRule(
            'He spills food or drink on himself or his beard.',
            RuleDifficulty.medium,
          ),
        ];
    }
  }

  List<GameRule> get rulesTwoTowers {
    switch (this) {
      case Character.frodo:
        return <GameRule>[
          const GameRule(
            'He clutches his chest (where the Ring is).',
            RuleDifficulty.hard,
          ),
          const GameRule(
            'He talks about the heaviness or burden of the Ring.',
            RuleDifficulty.medium,
          ),
          const GameRule(
            'He trips over his own feet.',
            RuleDifficulty.easy,
          ),
        ];
      case Character.sam:
        return <GameRule>[
          const GameRule(
            'He says, “Mr Frodo”.',
            RuleDifficulty.medium,
          ),
          const GameRule(
            "He's mean to Gollum.",
            RuleDifficulty.medium,
          ),
          const GameRule(
            'He talks about food (taters, rabbit stew, lembas bread, etc.).',
            RuleDifficulty.easy,
          ),
          const GameRule(
            'He pulls out his small sword.',
            RuleDifficulty.easy,
          ),
        ];
      case Character.merrypippin:
        return <GameRule>[
          const GameRule(
            'They cause trouble or create mischief.',
            RuleDifficulty.easy,
          ),
          const GameRule(
            'They talk about food.',
            RuleDifficulty.easy,
          ),
          const GameRule(
            "They discuss hobbit and other species' culture, or the Shire.",
            RuleDifficulty.medium,
          ),
          const GameRule(
            'They actually do something intelligent.',
            RuleDifficulty.easy,
          ),
        ];
      case Character.gandalf:
        return <GameRule>[
          const GameRule(
            'He gives sage advice or shares a piece of ancient wisdom.',
            RuleDifficulty.easy,
          ),
          const GameRule(
            'Drink when he actually uses magic.',
            RuleDifficulty.easy,
          ),
          const GameRule(
            'Drink whenever he mysteriously disappears or appears without '
            'clear explanation.',
            RuleDifficulty.medium,
          ),
          const GameRule(
            'Drink whenever he calls on the name of a higher power like '
            '"Elbereth", "Mithrandir", or "Udun".',
            RuleDifficulty.hard,
          ),
          const GameRule(
            'Drink when he refers to someone by their full name.',
            RuleDifficulty.medium,
          ),
        ];
      case Character.aragorn:
        return <GameRule>[
          const GameRule(
            'He kills something.',
            RuleDifficulty.easy,
          ),
          const GameRule(
            'He scouts ahead or examines the landscape.',
            RuleDifficulty.easy,
          ),
          const GameRule(
            'He smiles like an idiot.',
            RuleDifficulty.easy,
          ),
          const GameRule(
            'He shows qualities of being a King.',
            RuleDifficulty.medium,
          ),
          const GameRule(
            "He's doubtful of his ability to be the rightful king of Gondor.",
            RuleDifficulty.medium,
          ),
        ];
      case Character.legolas:
        return <GameRule>[
          const GameRule(
            "He uses his bow (extra sip if it's a major action scene, drink 3 "
            'per shot during the Shield Surf).',
            RuleDifficulty.easy,
          ),
          const GameRule(
            'He interacts with Gimli.',
            RuleDifficulty.easy,
          ),
          const GameRule(
            'He says something vague or obvious.',
            RuleDifficulty.easy,
          ),
          const GameRule(
            'He is staring in the distance, double if he identifies or warns '
            'of an approaching danger before anyone else.',
            RuleDifficulty.medium,
          ),
        ];
      case Character.gimli:
        return <GameRule>[
          const GameRule(
            'He says “dwarf” or “elf”.',
            RuleDifficulty.medium,
          ),
          const GameRule(
            "He's used as a comic relief (Beware of the Director's Cut).",
            RuleDifficulty.easy,
          ),
          const GameRule(
            'He laughs heartily.',
            RuleDifficulty.easy,
          ),
          const GameRule(
            'He is seen panting or struggling to keep up.',
            RuleDifficulty.easy,
          ),
          const GameRule(
            'He grumbles or complains.',
            RuleDifficulty.easy,
          ),
          const GameRule(
            'He kills something.',
            RuleDifficulty.hard,
          ),
        ];
    }
  }

  List<GameRule> get rulesROTK {
    switch (this) {
      case Character.frodo:
        return <GameRule>[
          const GameRule(
            'The ring affects his behavior.',
            RuleDifficulty.medium,
          ),
          const GameRule(
            'He says, “Oh Sam”.',
            RuleDifficulty.medium,
          ),
          const GameRule(
            'He trips over his own feet.',
            RuleDifficulty.easy,
          ),
          const GameRule(
            'Down the hatch when carried.',
            RuleDifficulty.easy,
          ),
        ];
      case Character.sam:
        return <GameRule>[
          const GameRule(
            'He says, “Mr Frodo”.',
            RuleDifficulty.hard,
          ),
          const GameRule(
            "He's mean to Gollum.",
            RuleDifficulty.easy,
          ),
          const GameRule(
            'He supports a Frodo who has once again fucked up or has brainlag.',
            RuleDifficulty.medium,
          ),
          const GameRule(
            'Down the hatch when he carries Frodo.',
            RuleDifficulty.easy,
          ),
        ];
      case Character.merrypippin:
        return <GameRule>[
          const GameRule(
            'They cause trouble or create mischief.',
            RuleDifficulty.easy,
          ),
          const GameRule(
            'They show bravery despite their fear.',
            RuleDifficulty.medium,
          ),
          const GameRule(
            'They manage to make a seemingly hopeless situation '
            'light-hearted.',
            RuleDifficulty.medium,
          ),
          const GameRule(
            'They actually do something intelligent.',
            RuleDifficulty.easy,
          ),
        ];
      case Character.gandalf:
        return <GameRule>[
          const GameRule(
            'He gives sage advice or shares a piece of ancient wisdom.',
            RuleDifficulty.easy,
          ),
          const GameRule(
            'Drink when he actually uses magic.',
            RuleDifficulty.easy,
          ),
          const GameRule(
            'Drink whenever he mysteriously disappears or appears without '
            'clear explanation.',
            RuleDifficulty.medium,
          ),
          const GameRule(
            'Drink whenever he calls on the name of a higher power like '
            '"Elbereth", "Mithrandir", or "Udun".',
            RuleDifficulty.easy,
          ),
          const GameRule(
            'He is seen dual-wielding a sword and his staff.',
            RuleDifficulty.easy,
          ),
        ];
      case Character.aragorn:
        return <GameRule>[
          const GameRule(
            'He kills something.',
            RuleDifficulty.hard,
          ),
          const GameRule(
            "He's doubtful of his ability to be the rightful king of Gondor.",
            RuleDifficulty.easy,
          ),
          const GameRule(
            'He comforts or reassures another character.',
            RuleDifficulty.easy,
          ),
          const GameRule(
            'Down the hatch when he says "For Frodo" and charges towards the '
            'Gates of Mordor.',
            RuleDifficulty.easy,
          ),
        ];
      case Character.legolas:
        return <GameRule>[
          const GameRule(
            'He uses his bow.',
            RuleDifficulty.hard,
          ),
          const GameRule(
            'Drink double if he kills something without his bow.',
            RuleDifficulty.medium,
          ),
          const GameRule(
            'He is staring in the distance, double if he identifies or warns '
            'of an approaching danger before anyone else.',
            RuleDifficulty.easy,
          ),
          const GameRule(
            'He interacts with Gimli, displaying their unique friendship.',
            RuleDifficulty.easy,
          ),
          const GameRule(
            'Down the hatch when he kills the oliphant.',
            RuleDifficulty.medium,
          ),
        ];
      case Character.gimli:
        return <GameRule>[
          const GameRule(
            'He says “dwarf” or “elf”.',
            RuleDifficulty.easy,
          ),
          const GameRule(
            "He's used as a comic relief (Beware of the Director's Cut).",
            RuleDifficulty.medium,
          ),
          const GameRule(
            'He mentions the skill or strength of dwarves.',
            RuleDifficulty.easy,
          ),
          const GameRule(
            'He spills something on himself or is clumsy.',
            RuleDifficulty.easy,
          ),
          const GameRule(
            'He kills something.',
            RuleDifficulty.hard,
          ),
        ];
    }
  }

  Color get color {
    switch (this) {
      case Character.frodo:
        return Colors.brown;
      case Character.sam:
        return Colors.green;
      case Character.merrypippin:
        return Colors.orange;
      case Character.gandalf:
        return Colors.grey;
      case Character.aragorn:
        return Colors.blue;
      case Character.legolas:
        return Colors.lightGreen;
      case Character.gimli:
        return Colors.red;
    }
  }
}
