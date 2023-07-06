import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/app/audio_player_service.dart';

enum LogoType { title, square }

class Logo extends ConsumerWidget {
  const Logo({this.type = LogoType.square, this.size, super.key});

  final LogoType type;
  final double? size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String assetName =
        type == LogoType.title ? 'logo-title.png' : 'logo.png';
    final double height = size ?? (type == LogoType.title ? 55 : 100);

    return GestureDetector(
      onDoubleTap: () => ref.read(audioPlayerService).playSound(Sound.bababoie),
      child: Hero(
        tag: type,
        child: Image.asset(
          'assets/images/logo/$assetName',
          height: height,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
