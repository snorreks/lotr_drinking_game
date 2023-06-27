// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fellowship_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FellowshipMember _$FellowshipMemberFromJson(Map<String, dynamic> json) =>
    FellowshipMember(
      name: json['name'] as String,
      character: $enumDecode(_$CharacterEnumMap, json['character']),
      drinks: json['drinks'] == null
          ? const <DateTime>[]
          : timestampArrayFromJson(json['drinks']),
      saves: json['saves'] == null
          ? const <DateTime>[]
          : timestampArrayFromJson(json['saves']),
      callout: json['callout'] as String?,
    );

Map<String, dynamic> _$FellowshipMemberToJson(FellowshipMember instance) =>
    <String, dynamic>{
      'name': instance.name,
    };

const _$CharacterEnumMap = {
  Character.frodo: 'frodo',
  Character.sam: 'sam',
  Character.merrypippin: 'merrypippin',
  Character.gandalf: 'gandalf',
  Character.aragorn: 'aragorn',
  Character.legolas: 'legolas',
  Character.gimli: 'gimli',
};
