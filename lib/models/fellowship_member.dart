import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../constants/characters.dart';

part 'fellowship_member.g.dart';

List<DateTime> timestampArrayFromJson(dynamic value) {
  if (value == null) {
    return <DateTime>[];
  }
  return (value as List<dynamic>)
      .map((dynamic e) => (e as Timestamp).toDate())
      .toList();
}

@JsonSerializable()
class FellowshipMember {
  FellowshipMember({
    required this.name,
    required this.character,
    this.drinks = const <DateTime>[],
    this.saves = const <DateTime>[],
    this.callout,
    required this.isAdmin,
  });

  factory FellowshipMember.fromJson(Map<String, dynamic> json) =>
      _$FellowshipMemberFromJson(json);

  @JsonKey()
  final String name;
  @JsonKey(fromJson: timestampArrayFromJson, includeToJson: false)
  final List<DateTime> drinks;
  @JsonKey(fromJson: timestampArrayFromJson, includeToJson: false)
  final List<DateTime> saves;
  @JsonKey(includeToJson: false)
  final String? callout;
  @JsonKey(includeToJson: false)
  final bool isAdmin;

  @JsonKey(includeToJson: false)
  final Character character;

  int get drinksAmount => drinks.length;

  int get savesAmount => saves.length;

  Map<String, dynamic> toJson() => _$FellowshipMemberToJson(this);
}
