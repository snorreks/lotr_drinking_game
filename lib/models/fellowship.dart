import 'package:json_annotation/json_annotation.dart';

import '../constants/characters.dart';
import 'fellowship_member.dart';

part 'fellowship.g.dart';

Map<Character, FellowshipMember> membersFromJson(dynamic value) {
  final Map<Character, FellowshipMember> members =
      <Character, FellowshipMember>{};
  for (final MapEntry<String, dynamic> entry
      in (value as Map<String, dynamic>).entries) {
    final Map<String, dynamic> json = entry.value as Map<String, dynamic>;
    // ignore: always_specify_types
    const Map<Character, String> $CharacterEnumMap = {
      Character.frodo: 'frodo',
      Character.sam: 'sam',
      Character.merrypippin: 'merrypippin',
      Character.gandalf: 'gandalf',
      Character.aragorn: 'aragorn',
      Character.legolas: 'legolas',
      Character.gimli: 'gimli',
    };

    members[CharacterExtension.fromValue(entry.key)] = FellowshipMember(
      name: json['name'] as String,
      character: $enumDecode($CharacterEnumMap, entry.key),
      drinks: json['drinks'] == null
          ? const <DateTime>[]
          : timestampArrayFromJson(json['drinks']),
      saves: json['saves'] == null
          ? const <DateTime>[]
          : timestampArrayFromJson(json['saves']),
      callout: json['callout'] == null
          ? null
          : Callout(
              // ignore: avoid_dynamic_calls
              rule: json['callout']['rule'] as String,
              // ignore: avoid_dynamic_calls
              caller: json['callout']['caller'] as String,
            ),
      isAdmin: json['isAdmin'] as bool,
    );
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

  @JsonKey(fromJson: membersFromJson)
  final Map<Character, FellowshipMember> members;

  Map<String, dynamic> toJson() => _$FellowshipToJson(this);

  List<FellowshipMember> get membersList => members.values.toList();
}
