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
      given: json['given'] as int,
      character: $enumDecode(_$CharacterEnumMap, json['character']),
    );

Map<String, dynamic> _$FellowshipMemberToJson(FellowshipMember instance) =>
    <String, dynamic>{
      'name': instance.name,
      'drinks': instance.drinks,
      'saves': instance.saves,
      'given': instance.given,
    };

const _$CharacterEnumMap = {
  Character.frodo: 'frodo',
  Character.sam: 'sam',
  Character.merryAndPippin: 'merryAndPippin',
  Character.gandalf: 'gandalf',
  Character.aragorn: 'aragorn',
  Character.legolas: 'legolas',
  Character.gimli: 'gimli',
};
