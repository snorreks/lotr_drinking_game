import 'package:json_annotation/json_annotation.dart';

import '../constants/characters.dart';
import '../constants/game_rule.dart';
import 'fellowship_member.dart';

part 'fellowship.g.dart';

/// Decodes the `members` map of a fellowship document.
///
/// Members are keyed by their unique [FellowshipMember.id], so multiple
/// players can pick the same character without overwriting each other.
/// Documents created before member ids existed keyed members directly by
/// their character value; for those the character is derived from the key.
Map<String, FellowshipMember> membersFromJson(dynamic value) {
  final Map<String, FellowshipMember> members = <String, FellowshipMember>{};
  for (final MapEntry<String, dynamic> entry
      in (value as Map<String, dynamic>).entries) {
    final Map<String, dynamic> json = entry.value as Map<String, dynamic>;
    final Character? character = _characterFromJson(json, entry.key);
    if (character == null) {
      // Skip malformed members instead of failing the whole fellowship.
      continue;
    }
    members[entry.key] = FellowshipMember(
      id: entry.key,
      name: json['name'] as String,
      character: character,
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
      isAdmin: json['isAdmin'] as bool? ?? false,
      difficulty: RuleDifficultyExtension.fromValue(
        json['difficulty'] as String?,
      ),
    );
  }
  return members;
}

Character? _characterFromJson(Map<String, dynamic> json, String key) {
  final String? value = json['character'] as String?;
  if (value != null) {
    try {
      return CharacterExtension.fromValue(value);
    } catch (_) {
      return null;
    }
  }
  // Legacy documents key members by their character value.
  try {
    return CharacterExtension.fromValue(key);
  } catch (_) {
    return null;
  }
}

@JsonSerializable()
class Fellowship {
  Fellowship({
    required this.id,
    required this.pin,
    required this.name,
    required this.currentMovie,
    required this.members,
    this.lastSummaryShown,
    this.currentMovieStart,
  });

  factory Fellowship.fromJson(Map<String, dynamic> json) =>
      _$FellowshipFromJson(json);

  @JsonKey(required: true)
  final String id;

  @JsonKey(required: true)
  final String name;

  @JsonKey(required: true)
  final String pin;

  @JsonKey(required: true)
  final String currentMovie;

  @JsonKey(fromJson: membersFromJson)
  final Map<String, FellowshipMember> members;

  /// The member belonging to this client, if any.
  ///
  /// Prefers the unique [FellowshipMember.id]; falls back to matching by
  /// [character] for sessions joined before member ids existed.
  FellowshipMember? findMember(String? memberId, Character? character) {
    if (memberId != null) {
      final FellowshipMember? byId = members[memberId];
      if (byId != null) {
        return byId;
      }
    }
    if (character != null) {
      for (final FellowshipMember member in members.values) {
        if (member.character == character) {
          return member;
        }
      }
    }
    return null;
  }

  final String? lastSummaryShown;

  /// The moment the current movie was started, i.e. when the previous movie
  /// summary was shown. Drinks and saves after this moment belong to the
  /// current movie. May be null for fellowships created before this field
  /// existed.
  @JsonKey(fromJson: timestampToDateTime)
  final DateTime? currentMovieStart;

  Map<String, dynamic> toJson() => _$FellowshipToJson(this);

  List<FellowshipMember> get membersList {
    final List<FellowshipMember> list = members.values.toList();
    list.sort((FellowshipMember a, FellowshipMember b) => a.id.compareTo(b.id));
    return list;
  }
}
