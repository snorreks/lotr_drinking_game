import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/characters.dart';

List<DateTime> timestampArrayFromJson(dynamic value) {
  if (value == null) {
    return <DateTime>[];
  }
  return (value as List<dynamic>)
      .map((dynamic e) => (e as Timestamp).toDate())
      .toList();
}

class Callout {
  Callout({
    required this.rule,
    required this.caller,
  });

  /// The rule that was called out
  final String rule;

  /// The name of the player who called out the other player
  final String caller;
}

class FellowshipMember {
  FellowshipMember({
    required this.name,
    required this.character,
    this.isAdmin = false,
    this.drinks = const <DateTime>[],
    this.saves = const <DateTime>[],
    this.callout,
  });

  final String name;
  final List<DateTime> drinks;
  final List<DateTime> saves;
  final Callout? callout;
  final bool isAdmin;
  final Character character;

  int get drinksAmount => drinks.length;

  int get savesAmount => saves.length;
}
