// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fellowship.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Fellowship _$FellowshipFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'name', 'pin'],
  );
  return Fellowship(
    id: json['id'] as String,
    name: json['name'] as String,
    pin: json['pin'] as String,
    members: membersFromJson(json['members']),
  );
}

Map<String, dynamic> _$FellowshipToJson(Fellowship instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'pin': instance.pin,
      'members': membersToJson(instance.members),
    };
