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
      isAdmin: json['isAdmin'] as bool,
    );

Map<String, dynamic> _$FellowshipMemberToJson(FellowshipMember instance) =>
    <String, dynamic>{
      'name': instance.name,
<<<<<<< master
=======
      'drinks': instance.drinks,
      'saves': instance.saves,
      'callout': instance.callout,
      'isAdmin': instance.isAdmin,
>>>>>>> admin_handling
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
