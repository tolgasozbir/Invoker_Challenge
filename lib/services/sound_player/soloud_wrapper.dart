import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter_soloud/flutter_soloud.dart';

import '../sound_manager.dart';
import 'sound_player_interface.dart';

class SoLoudWrapper implements ISoundPlayer {
  SoLoudWrapper._();
  static final SoLoudWrapper _instance = SoLoudWrapper._();
  static SoLoudWrapper get instance => _instance;

  final _soLoud = SoLoud.instance;
  // Yükleme future'ı saklanıyor; aynı ses peş peşe istenirse tek yükleme yapılır.
  final _sources = <String, Future<AudioSource>>{};
  final _rnd = math.Random();

  /// SoLoud kısık çaldığı için uygulama sesiyle çarpılan katsayı.
  static const double gain = 1.8;

  /// Sessizlikten sonra cihazın tekrar açılma gecikmesini önler (varsayılan 500 ms).
  static const _deviceIdleTimeout = Duration(seconds: 30);

  @override
  double get appVolume => (SoundManager.instance.appVolume / 100) * gain;

  @override
  Future<void> initialize() async {
    // Bazı Android cihazlar düşük gecikmeli akışı başlatamıyor; normal modla tekrar dene.
    // İkisi de olmazsa uygulama sessiz açılsın, çökmesin.
    for (final lowLatency in [true, false]) {
      try {
        await _soLoud.init(lowLatency: lowLatency);
        _soLoud.setAudioDeviceIdleTimeout(_deviceIdleTimeout);
        _soLoud.audioDeviceStartFailures.listen((_) => _restartDevice());
        return;
      } catch (e) {
        log('Failed to initialize SoLoud (lowLatency: $lowLatency): $e');
      }
    }
  }

  @override
  Future<void> play(String filePath, {double volume = 0.35, bool loop = false}) async {
    if (!_soLoud.isInitialized) return;
    try {
      final source = await _load(filePath);
      _soLoud.play(
        source,
        volume: (volume * appVolume).clamp(0.0, 1.0),
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

  // Boşta kapanan cihaz play() ile tekrar açılamazsa ses sessizce kesilir; bir kez yeniden dene.
  // startAudioDevice hatayı stream'e değil çağırana atar, döngü oluşmaz.
  Future<void> _restartDevice() async {
    try {
      await _soLoud.startAudioDevice();
    } catch (e) {
      log('Failed to restart audio device: $e');
    }
  }

  // Başarısız yükleme cache'ten silinir, sonraki çalmada tekrar denenir.
  Future<AudioSource> _load(String path) {
    return _sources.putIfAbsent(path, () async {
      try {
        return await _soLoud.loadAsset(path);
      } catch (_) {
        _sources.remove(path);
        rethrow;
      }
    });
  }

}
