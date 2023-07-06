import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/base_service.dart';

enum Sound { bababoie }

extension SoundExtension on Sound {
  String get path {
    switch (this) {
      case Sound.bababoie:
        return 'other/night2remember.wav';
    }
  }
}

/// This Service tells the [AudioPlayerManager] when and what notification/dialog to display.
abstract class AudioPlayerServiceModel {
  Future<void> playAudio(Sound sound);
}

class AudioPlayerService extends BaseService
    implements AudioPlayerServiceModel {
  final AudioPlayer player = AudioPlayer();

  static const String basePath = 'assets/audio';

  @override
  Future<void> playAudio(Sound sound) async {
    try {
      final String path = sound.path;
      await player.play(AssetSource('$basePath/$path'));
    } catch (error) {
      logError('playAudio', error);
    }
  }
}

final Provider<AudioPlayerServiceModel> audioPlayerService =
    Provider<AudioPlayerServiceModel>((_) => AudioPlayerService());
