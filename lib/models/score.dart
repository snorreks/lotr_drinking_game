import 'package:flutter/material.dart' show immutable;

@immutable
class Score {
  const Score(
    this.id,
    this.name,
  );

  Score.fromJson(
    this.id,
    Map<String, dynamic>? parsedJson,
  ) : name = parsedJson?['ScoreStatus'] as String;

  final String id, name;
}
