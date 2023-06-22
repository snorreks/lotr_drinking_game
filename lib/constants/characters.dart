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

  List<String> get rules {
    switch (this) {
      case Character.frodo:
        return [
          'The ring affects his behavior.',
          'He says, “Oh Sam”.',
          'He trips over his own feet.'
        ];
      case Character.sam:
        return [
          'He says, “Mr Frodo”.',
          "He's mean to Gollum.",
          'He supports a Frodo who has once again fucked up or is having a Heroic BSoD'
        ];
      case Character.merrypippin:
        return [
          'They cause trouble or create mischief.',
          'They talk about food.',
          'They show bravery despite their fear.',
          'They manage to make a seemingly hopeless situation light-hearted.'
        ];
      case Character.gandalf:
        return [
          'He gives sage advice or shares a piece of ancient wisdom.',
          'Drink whenever he mysteriously disappears or appears without clear explanation',
          'Drink whenever he calls on the name of a higher power like “Elberet, “Mithrandir”, or “Udun”'
        ];
      case Character.aragorn:
        return [
          'He kills something.',
          "He's doubtful of his ability to be the rightful king of Gondor.",
          'He smiles like an idiot'
        ];
      case Character.legolas:
        return [
          "He uses his bow (extra sip if it's a major action scene).",
          'He gives a silent, knowing look.',
          'He interacts with Gimli, displaying their unique friendship.'
        ];
      case Character.gimli:
        return [
          'He says “dwarf” or “elf”.',
          "He's used as a comic relief (Beware of the Director's Cut).",
          'He mentions the skill or strength of dwarves.'
        ];
    }
  }
}
