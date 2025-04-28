import 'dart:async';
import 'dart:math';

import 'package:dota2_invoker_game/services/sound_player/audioplayer_wrapper.dart';
import 'package:dota2_invoker_game/services/sound_player/soloud_wrapper.dart';
import 'package:dota2_invoker_game/services/user_manager.dart';
import '../constants/app_sound_paths.dart';

import '../enums/Bosses.dart';
import '../enums/spells.dart';
import 'sound_player/sound_player_interface.dart';

class SoundManager {
  SoundManager._();
  static final SoundManager _instance = SoundManager._();
  static SoundManager get instance => _instance;

  final _random = Random();
  final Map<String, DateTime> _lastPlayedTimes = {}; // Map to store the last played time of each sound

  ISoundPlayer _player = SoLoudWrapper.instance; //Default SoLoud
  ISoundPlayer get player => _player;

  double _appVolume = 100; // default %100
  double get appVolume => _appVolume;
  
  bool get _isPersona => UserManager.instance.isPersonaActive;


  void switchPlayer(ISoundPlayer newPlayer) => _player = newPlayer;

  void setVolume(double value) => _appVolume = value.clamp(0, 100);

  // İnitialize all players
  Future<void> initialize() async {
    await SoLoudWrapper.instance.initialize();
    await AudioPlayerWrapper.instance.initialize();
  }

  // Checks the cooldown for a specific sound and plays it if the cooldown has passed (1 second)
  void _playWithCooldown(String id, List<String> soundPaths, {double volume = 0.35, Duration cooldown = const Duration(seconds: 1)}) {
    final now = DateTime.now();
    // Prevent playing the sound if less than giving second has passed since the last play
    if (_lastPlayedTimes[id] != null && now.difference(_lastPlayedTimes[id]!) <= cooldown) return; // Skip playing the sound
    // Update the last played time for the sound
    _lastPlayedTimes[id] = now;
    // Play a random sound from the list
    player.playRandomSound(soundPaths, volume: volume);
  }

  // -------------------- Common/General Sounds --------------------

  void playInvoke({double volume = 0.35}) => player.play(AppSoundPaths.invoke, volume: volume);

  void playMeepMerp() => player.play(AppSoundPaths.meepMerp);

  void playSpellSound(Spell spell) => player.playRandomSound(spell.spellSounds);

  void spellCastTriggerSound(Spell spell) {
    playSpellSound(spell);
    player.play(spell.castSound, volume: 0.2);
  }

  // -------------------- Invoker Responses Sounds --------------------

  void playFailCastSound() {
    player.playRandomSound(
      _isPersona ? AppSoundPaths.failCastPersona : AppSoundPaths.failCastDefault,
      volume: 0.35,
    );
  }

  void playGameOverSound() {
    player.playRandomSound(
      _isPersona ? AppSoundPaths.gameOverPersona : AppSoundPaths.gameOverDefault,
      volume: 0.35,
    );
  }

  void playLoadingSound() {
    player.playRandomSound(
      _isPersona ? AppSoundPaths.loadingPersona : AppSoundPaths.loadingDefault,
      volume: 0.40,
    );
  }

  void playCooldownSound() {
    _playWithCooldown(
      'ability_cooldown', 
      _isPersona ? AppSoundPaths.abilityCooldownPersona : AppSoundPaths.abilityCooldownDefault,
      volume: 0.35,
    );
  }

  void playNoManaSound() {
    _playWithCooldown(
      'insufficient_mana', 
      _isPersona ? AppSoundPaths.noManaPersona : AppSoundPaths.noManaDefault,
      volume: 0.35,
    );
  }

  void playPersonaPickedSound() {
    _playWithCooldown(
      'persona_select', 
      AppSoundPaths.personaSelect,
      volume: 0.40,
      cooldown: const Duration(seconds: 2),
    );
  }


  // -------------------- Item & Shop Sounds --------------------

  void playItemSound(String itemName) => player.play('${AppSoundPaths.item}/$itemName.mp3');

  void playItemBuySound() => player.play(AppSoundPaths.itemBuy);
  
  void playItemSellSound() => player.play(AppSoundPaths.itemSell);
  
  void playShopEnterSound() => player.playRandomSound(AppSoundPaths.shopEnter);

  void playShopExitSound() => player.playRandomSound(AppSoundPaths.shopExit);
  
  
  // -------------------- Boss Sounds --------------------

  void playHorn() => player.playRandomSound(AppSoundPaths.horns);

  // Future<void> playBossSound({
  //   required Bosses boss,
  //   required String soundType, // "entering", "dying" or "taunt" | reincarnating (wk)
  //   required int lineCount, // İlgili ses sayısını belirtir
  // }) async {
  //   final basePath = '${AppSoundPaths.boss}/${boss.name}';
  //   final soundIndex = _random.nextInt(lineCount) + 1;
  //   final soundPath = '$basePath/$soundType$soundIndex.mp3';

  //   player.play(soundPath);
  // }

  void playBossEnteringSound(Bosses boss) async {
    final basePath    = '${AppSoundPaths.boss}/${boss.name}';
    final soundIndex  = _random.nextInt(boss.entryLineCount) + 1;
    final soundPath   = '$basePath/entering$soundIndex.mp3';

    player.play(soundPath);
  }
  
  void playBossDeathSound(Bosses boss) async {
    final basePath    = '${AppSoundPaths.boss}/${boss.name}';
    final soundIndex  = _random.nextInt(boss.deathLineCount) + 1;
    final soundPath   = '$basePath/dying$soundIndex.mp3';

    player.play(soundPath);
  }
  
  void playBossTauntSound(Bosses boss) async {
    final basePath    = '${AppSoundPaths.boss}/${boss.name}';
    final soundIndex = _random.nextInt(boss.tauntLineCount) + 1;
    final soundPath = '$basePath/taunt$soundIndex.mp3';

    player.play(soundPath);
  }

  void playWraithKingReincarnation() async {
    const basePath = '${AppSoundPaths.boss}/wraith_king';
    final soundIndex = _random.nextInt(4) + 1;
    final soundPath = '$basePath/reincarnating$soundIndex.mp3';

    player.play(soundPath);
  }

}
