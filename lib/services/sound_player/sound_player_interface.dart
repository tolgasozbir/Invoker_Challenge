abstract class ISoundPlayer {
  double get appVolume;
  Future<void> initialize();
  Future<void> play(String filePath, {double volume = 0.35, bool loop = false});
  void playRandomSound(List<String> sounds, {double volume = 0.35});
}
