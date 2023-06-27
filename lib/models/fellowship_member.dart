import 'package:json_annotation/json_annotation.dart';

import '../constants/characters.dart';

part 'fellowship_member.g.dart';

@JsonSerializable()
class FellowshipMember {
  FellowshipMember({
    required this.name,
    required this.drinks,
    required this.saves,
    required this.callout,
    required this.character,
    required this.isAdmin,
  });

  factory FellowshipMember.fromJson(Map<String, dynamic> json) =>
      _$FellowshipMemberFromJson(json);

  @JsonKey()
  final String name;
  @JsonKey()
  final int drinks;
  @JsonKey()
  final int saves;
  @JsonKey()
  final String callout;
  @JsonKey()
  final bool isAdmin;

  @JsonKey(includeToJson: false)
  final Character character;

  Map<String, dynamic> toJson() => _$FellowshipMemberToJson(this);
}
