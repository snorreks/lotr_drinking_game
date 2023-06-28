import 'package:json_annotation/json_annotation.dart';

import '../constants/characters.dart';
import 'fellowship_member.dart';

part 'fellowship.g.dart';

Map<Character, FellowshipMember> membersFromJson(dynamic value) {
  final Map<Character, FellowshipMember> members =
      <Character, FellowshipMember>{};
  for (final MapEntry<String, dynamic> entry
      in (value as Map<String, dynamic>).entries) {
    members[CharacterExtension.fromValue(entry.key)] =
        FellowshipMember.fromJson(<String, dynamic>{
      ...entry.value as Map<String, dynamic>,
      'character': entry.key,
    });
  }
  return members;
}

Map<String, dynamic> membersToJson(Map<Character, FellowshipMember> value) {
  final Map<String, dynamic> members = <String, dynamic>{};
  for (final MapEntry<Character, FellowshipMember> entry in value.entries) {
    members[entry.key.value] = entry.value.toJson();
  }
  return members;
}

@JsonSerializable()
class Fellowship {
  Fellowship({
    required this.id,
    required this.pin,
    required this.name,
    required this.members,
  });

  factory Fellowship.fromJson(Map<String, dynamic> json) =>
      _$FellowshipFromJson(json);

  @JsonKey(required: true)
  final String id;

  @JsonKey(required: true)
  final String name;

  @JsonKey(required: true)
  final String pin;

  @JsonKey(fromJson: membersFromJson, toJson: membersToJson)
  final Map<Character, FellowshipMember> members;

  Map<String, dynamic> toJson() => _$FellowshipToJson(this);
}
