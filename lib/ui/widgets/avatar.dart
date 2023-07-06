import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/characters.dart';
import '../../services/app/audio_player_service.dart';

class Avatar extends ConsumerWidget {
  const Avatar(this.character,
      {this.fit, this.height, this.circle = false, super.key});
  final Character character;
  final BoxFit? fit;
  final double? height;
  final bool circle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Widget image = GestureDetector(
      onDoubleTap: () =>
          ref.read(audioPlayerService).playCharacterSound(character),
      child: Hero(
        tag: character,
        child: Image.asset(
          'assets/images/characters/${character.value}.png',
          fit: fit,
          height: height,
        ),
      ),
    );

    if (!circle) {
      return image;
    }
    return ClipOval(child: image);
  }
}
