import 'package:flutter/material.dart';

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

  List<String> get rulesFellowship {
    switch (this) {
      case Character.frodo:
        return <String>[
          'The ring affects his behavior.',
          'He mentions Bilbo.',
          'His eyes are wide-open in fear or amazement.',
          'He trips over his own feet.'
        ];
      case Character.sam:
        return <String>[
          'He says, “Mr Frodo”.',
          "He's mean to Gollum.",
          'He supports a Frodo who has once again fucked up or is having a Heroic BSoD'
        ];
      case Character.merrypippin:
        return <String>[
          'They cause trouble or create mischief.',
          'They talk about food.',
          'They are drinking or eating',
          'They manage to make a seemingly hopeless situation light-hearted.'
        ];
      case Character.gandalf:
        return <String>[
          'He lights up his pipe (Give one to another person if he is smoking with someone)',
          'Drink when he refers to someone by their full name.',
          'Drink whenever he mysteriously disappears or appears without clear explanation',
          'Drink whenever he calls on the name of a higher power like "Elbereth", "Mithrandir", or "Udun"'
        ];
      case Character.aragorn:
        return <String>[
          'He lights up his pipe.',
          'He refers to Frodo and Sam as "Mr. Frodo" and "Mr. Sam".',
          'He unsheathes his sword.'
        ];
      case Character.legolas:
        return <String>[
          "He uses his bow (extra sip if it's a major action scene).",
          'He gives a silent, knowing look.',
          'His hair blows dramatically in the wind.'
        ];
      case Character.gimli:
        return <String>[
          'He says “dwarf” or “elf”.',
          "He's used as a comic relief (Beware of the Director's Cut).",
          'He grumbles or complains.',
          'He mentions his father, ancestors or the skill of dwarves.'
        ];
    }
  }

  List<String> get rulesTwoTowers {
    switch (this) {
      case Character.frodo:
        return <String>[
          'He clutches his chest (where the Ring is).',
          'He talks about the heaviness or burden of the Ring.',
          'He trips over his own feet.'
        ];
      case Character.sam:
        return <String>[
          'He says, “Mr Frodo”.',
          "He's mean to Gollum.",
          'He talks about food (taters, rabbit stew, lembas bread, etc.).',
          'He pulls out his small sword.'
        ];
      case Character.merrypippin:
        return <String>[
          'They cause trouble or create mischief.',
          'They talk about food.',
          'They show bravery despite their fear.',
          'They manage to make a seemingly hopeless situation light-hearted.'
        ];
      case Character.gandalf:
        return <String>[
          'He gives sage advice or shares a piece of ancient wisdom.',
          'Drink whenever he mysteriously disappears or appears without clear explanation',
          'Drink whenever he calls on the name of a higher power like "Elbereth", "Mithrandir", or "Udun"'
        ];
      case Character.aragorn:
        return <String>[
          'He kills something.',
          "He's doubtful of his ability to be the rightful king of Gondor.",
          'He smiles like an idiot'
        ];
      case Character.legolas:
        return <String>[
          "He uses his bow (extra sip if it's a major action scene).",
          'He gives a silent, knowing look.',
          'He interacts with Gimli, displaying their unique friendship.'
        ];
      case Character.gimli:
        return <String>[
          'He says “dwarf” or “elf”.',
          "He's used as a comic relief (Beware of the Director's Cut).",
          'He laughs heartily.',
          'He is seen panting or struggling to keep up.'
        ];
    }
  }

  List<String> get rulesROTK {
    switch (this) {
      case Character.frodo:
        return <String>[
          'The ring affects his behavior.',
          'He says, “Oh Sam”.',
          'He trips over his own feet.'
        ];
      case Character.sam:
        return <String>[
          'He says, “Mr Frodo”.',
          "He's mean to Gollum.",
          'He supports a Frodo who has once again fucked up or is having a Heroic BSoD'
        ];
      case Character.merrypippin:
        return <String>[
          'They cause trouble or create mischief.',
          'They talk about food.',
          'They show bravery despite their fear.',
          'They manage to make a seemingly hopeless situation light-hearted.'
        ];
      case Character.gandalf:
        return <String>[
          'He gives sage advice or shares a piece of ancient wisdom.',
          'Drink whenever he mysteriously disappears or appears without clear explanation',
          'Drink whenever he calls on the name of a higher power like "Elbereth", "Mithrandir", or "Udun"'
        ];
      case Character.aragorn:
        return <String>[
          'He kills something.',
          "He's doubtful of his ability to be the rightful king of Gondor.",
          'He smiles like an idiot'
        ];
      case Character.legolas:
        return <String>[
          "He uses his bow (extra sip if it's a major action scene).",
          'He gives a silent, knowing look.',
          'He interacts with Gimli, displaying their unique friendship.'
        ];
      case Character.gimli:
        return <String>[
          'He says “dwarf” or “elf”.',
          "He's used as a comic relief (Beware of the Director's Cut).",
          'He mentions the skill or strength of dwarves.'
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
