import 'package:flutter/material.dart';

import '../../constants/characters.dart';

class Avatar extends StatelessWidget {
  const Avatar(this.character, this.currentMovie,
      {this.fit, this.height, this.circle = false, super.key});
  final Character character;
  final String currentMovie;
  final BoxFit? fit;
  final double? height;
  final bool circle;

  @override
  Widget build(BuildContext context) {
    final Widget image = Hero(
      tag: character,
      child: Image.asset(
        'assets/images/characters/${character.value}${currentMovie == "Return of the King" ? "2" : ""}.png',
        fit: fit,
        height: height,
      ),
    );

    if (!circle) {
      return image;
    }
    return ClipOval(child: image);
  }
}
