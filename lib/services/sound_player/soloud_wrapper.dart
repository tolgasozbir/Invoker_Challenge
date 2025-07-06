import 'dart:developer';
import 'dart:math' as math;

import 'package:dota2_invoker_game/services/sound_manager.dart';
import 'package:dota2_invoker_game/services/sound_player/sound_player_interface.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

class SoLoudWrapper implements ISoundPlayer {
  SoLoudWrapper._();
  static final SoLoudWrapper _instance = SoLoudWrapper._();
  static SoLoudWrapper get instance => _instance;

  final _soLoud = SoLoud.instance;
  final _loadedSounds = <String, AudioSource>{};
  final _rnd = math.Random();

  @override
  double get appVolume => (SoundManager.instance.appVolume+70)/100;

  @override
  Future<void> initialize() async {
    await _soLoud.init();
  }

  @override
  Future<void> play(String filePath, {double volume = 0.35, bool loop = false}) async {
    try {
      // Ses yüklenmemişse önce yükle
      if (!_loadedSounds.containsKey(filePath)) {
        await _loadSound(filePath);
      }

      // Sesi çal
      await _soLoud.play(
        _loadedSounds[filePath]!,
        volume: (volume * appVolume).clamp(0.0, 1.0), // Ses seviyesi sınırlandırılıyor
        looping: loop,
      );
    } catch (e) {
      log('Failed to play sound "$filePath": $e');
    }
  }

  @override
  void playRandomSound(List<String> sounds, {double volume = 0.35}) {
    if (sounds.isNotEmpty) {
      final sound = sounds[_rnd.nextInt(sounds.length)];
      play(sound, volume: volume);
    }
  }

  Future<void> _loadSound(String path) async {
    if (_loadedSounds.containsKey(path)) return;

    try {
      final source = await _soLoud.loadAsset(path);
      _loadedSounds[path] = source;
    } catch (e) {
      log('Failed to load sound "$path": $e');
    }
  }

  // Future already completed Hatası için
  // final Map<String, Future<AudioSource>> _loadingFutures = {};

  // Future<void> _loadSound(String path) async {
  //   if (_loadedSounds.containsKey(path)) return;

  //   // Eğer daha önce yükleme başlatıldıysa, aynı future'ı bekle
  //   if (_loadingFutures.containsKey(path)) {
  //     await _loadingFutures[path];
  //     return;
  //   }

  //   try {
  //     final future = _soLoud.loadAsset(path);
  //     _loadingFutures[path] = future;

  //     final source = await future;
  //     _loadedSounds[path] = source;
  //   } catch (e) {
  //     log('Failed to load sound "$path": $e');
  //   } finally {
  //     _loadingFutures.remove(path); // Temizle
  //   }
  // }
  
  
}
