import 'package:json_annotation/json_annotation.dart';

part 'fellowship_member.g.dart';

@JsonSerializable()
class FellowshipMember {
  FellowshipMember({
    required this.name,
    required this.drinks,
    required this.saves,
    required this.given,
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
  final int given;

  Map<String, dynamic> toJson() => _$FellowshipMemberToJson(this);
}
