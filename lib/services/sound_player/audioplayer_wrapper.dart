import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:dota2_invoker_game/services/sound_manager.dart';
import 'package:dota2_invoker_game/services/sound_player/sound_player_interface.dart';

class AudioPlayerWrapper implements ISoundPlayer {
  AudioPlayerWrapper._();
  static final AudioPlayerWrapper _instance = AudioPlayerWrapper._();
  static AudioPlayerWrapper get instance => _instance;

  AudioPlayer? _player;
  final _cache = AudioCache(prefix: '');
  final _rnd = math.Random();

  @override
  double get appVolume => SoundManager.instance.appVolume/100;

  @override
  Future<void> initialize() async {
    //await _cache.loadAll([]);
  }
  
  @override
  Future<void> play(String filePath, {double volume = 0.35, bool loop = false}) async {
    _player = await _cache.play(filePath, volume: volume * appVolume);
    if (loop) {
      _player?.setReleaseMode(ReleaseMode.LOOP);
    }
  }
  
  @override
  void playRandomSound(List<String> sounds, {double volume = 0.35}) {
    if (sounds.isNotEmpty) {
      final sound = sounds[_rnd.nextInt(sounds.length)];
      play(sound, volume: volume);
    }
  }

}
