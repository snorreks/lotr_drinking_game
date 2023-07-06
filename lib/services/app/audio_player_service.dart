import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../common/base_service.dart';
import '../../constants/characters.dart';

enum Sound { night2remember, shallnotpass }

extension SoundExtension on Sound {
  String get path {
    switch (this) {
      case Sound.night2remember:
        return 'other/night2remember.mp3';
      case Sound.shallnotpass:
        return 'other/shallnotpass.mp3';
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
  VideoPlayerController? _player;

  static const String basePath = 'assets/audio';

  @override
  Future<void> playSound(Sound sound) async {
    try {
      final String path = sound.path;
      await _setPlayer('$basePath/$path');
    } catch (error) {
      logError('playSound', error);
    }
  }

  @override
  Future<void> playCharacterSound(Character character) async {
    try {
      final String fileName = character.value;

      await _setPlayer('$basePath/characters/$fileName.mp3');
    } catch (error) {
      logError('playCharacterSound', error);
    }
  }

  Future<void> _setPlayer(String path) async {
    _player?.dispose();
    _player = VideoPlayerController.asset(path);
    await _player!.initialize();
    await _player!.play();
  }
}

final Provider<AudioPlayerServiceModel> audioPlayerService =
    Provider<AudioPlayerServiceModel>((_) => AudioPlayerService());
