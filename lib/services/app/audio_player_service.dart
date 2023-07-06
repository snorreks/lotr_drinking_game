import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/base_service.dart';
import '../../constants/characters.dart';

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
  Future<void> playSound(Sound sound);
  Future<void> playCharacterSound(Character character);
}

class AudioPlayerService extends BaseService
    implements AudioPlayerServiceModel {
  final AudioPlayer player = AudioPlayer();

  static const String basePath = 'assets/audio';

  @override
  Future<void> playSound(Sound sound) async {
    try {
      final String path = sound.path;
      await player.play(AssetSource('$basePath/$path'));
    } catch (error) {
      logError('playSound', error);
    }
  }

  @override
  Future<void> playCharacterSound(Character character) async {
    try {
      final String fileName = character.value;
      await player.play(AssetSource('$basePath/$fileName.wav'));
    } catch (error) {
      logError('playCharacterSound', error);
    }
  }
}

final Provider<AudioPlayerServiceModel> audioPlayerService =
    Provider<AudioPlayerServiceModel>((_) => AudioPlayerService());
