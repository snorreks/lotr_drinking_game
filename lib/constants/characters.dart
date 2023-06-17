enum Character {
  frodo,
  sam,
  merryAndPippin,
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
      case Character.merryAndPippin:
        return 'merry-pippin';
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
      case 'merry-pippin':
        return Character.merryAndPippin;
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
      case Character.merryAndPippin:
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
}
