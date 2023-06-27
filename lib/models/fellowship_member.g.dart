// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fellowship_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FellowshipMember _$FellowshipMemberFromJson(Map<String, dynamic> json) =>
    FellowshipMember(
      name: json['name'] as String,
      drinks: json['drinks'] as int,
      saves: json['saves'] as int,
      callout: json['callout'] as String,
      isAdmin: json['isAdmin'] as bool,
      character: $enumDecode(_$CharacterEnumMap, json['character']),
    );

Map<String, dynamic> _$FellowshipMemberToJson(FellowshipMember instance) =>
    <String, dynamic>{
      'name': instance.name,
      'drinks': instance.drinks,
      'saves': instance.saves,
      'callout': instance.callout,
      'isAdmin': instance.isAdmin,
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
