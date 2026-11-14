import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/characters.dart';
import '../constants/game_rule.dart';

List<DateTime> timestampArrayFromJson(dynamic value) {
  if (value == null) {
    return <DateTime>[];
  }
  return (value as List<dynamic>)
      .map((dynamic e) => (e as Timestamp).toDate())
      .toList();
}

DateTime? timestampToDateTime(dynamic value) {
  if (value == null) {
    return null;
  }
  return (value as Timestamp).toDate();
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
    required this.id,
    required this.name,
    required this.character,
    this.difficulty = RuleDifficulty.easy,
    this.isAdmin = false,
    this.drinks = const <DateTime>[],
    this.saves = const <DateTime>[],
    this.callout,
  });

  /// Firestore map keys are written using dot notation, so only these
  /// characters are safe to use inside a member id.
  static const String _idAlphabet = 'abcdefghijklmnopqrstuvwxyz0123456789';

  /// Unique identifier of this membership.
  ///
  /// Unlike [character], it is unique per player, so multiple players can
  /// pick the same character without overwriting each other.
  final String id;

  final String name;
  final List<DateTime> drinks;
  final List<DateTime> saves;
  final Callout? callout;
  final bool isAdmin;
  final Character character;
  final RuleDifficulty difficulty;

  int get drinksAmount => drinks.length;

  int get savesAmount => saves.length;

  /// Generates a unique, Firestore-safe member id.
  static String generateId() {
    final Random random = Random();
    final String timestamp =
        DateTime.now().microsecondsSinceEpoch.toRadixString(36);
    final String suffix = List<String>.generate(
      8,
      (int index) => _idAlphabet[random.nextInt(_idAlphabet.length)],
    ).join();
    return '$timestamp$suffix';
  }
}
