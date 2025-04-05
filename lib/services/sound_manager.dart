import 'dart:async';
import 'dart:math';

import 'package:dota2_invoker_game/services/sound_player/audioplayer_wrapper.dart';
import 'package:dota2_invoker_game/services/sound_player/soloud_wrapper.dart';
import 'package:dota2_invoker_game/services/user_manager.dart';
import '../constants/app_sounds_paths.dart';

import '../enums/Bosses.dart';
import '../enums/spells.dart';
import 'sound_player/sound_player_interface.dart';

class SoundManager {
  SoundManager._();
  static final SoundManager _instance = SoundManager._();
  static SoundManager get instance => _instance;

  // Rastgele ses seçimi için Random nesnesi
  final _rnd = Random();

  // SoundPlayer için varsayılan olarak SoLoud
  ISoundPlayer _player = SoLoudWrapper.instance;
  ISoundPlayer get player => _player;

  void switchPlayer(ISoundPlayer newPlayer) {
    _player = newPlayer;
  }

  // Uygulama genel ses seviyesi
  double _appVolume = 100; // Varsayılan olarak %100
  double get appVolume => _appVolume;

  void setVolume(double value) {
    // Ses seviyesini 0 ile 100 arasında sınırlandır
    _appVolume = value.clamp(0, 100);
  }

  // Başlatma işlemleri (tüm player'lar için)
  Future<void> initialize() async {
    await SoLoudWrapper.instance.initialize();
    await AudioPlayerWrapper.instance.initialize();
  }

  // Common Sounds //
  bool get _isPersona => UserManager.instance.isPersonaActive;

  void failCombinationSound() {
    player.playRandomSound(
      _isPersona ? AppSoundPaths.failCastPersona : AppSoundPaths.failCastDefault,
      volume: 0.35,
    );
  }

  void ggSound() {
    player.playRandomSound(
      _isPersona ? AppSoundPaths.gameOverPersona : AppSoundPaths.gameOverDefault,
      volume: 0.35,
    );
  }
  
  // Map to store the last played time of each sound
  final Map<String, DateTime> _lastPlayedTimes = {};

  // Checks the cooldown for a specific sound and plays it if the cooldown has passed (1 second)
  void _playSoundWithCooldown(String soundId, List<String> soundPaths, {double volume = 0.35, Duration cooldown = const Duration(seconds: 1)}) {
    final now = DateTime.now();

    // Prevent playing the sound if less than 1 second has passed since the last play
    if (_lastPlayedTimes[soundId] != null && now.difference(_lastPlayedTimes[soundId]!) <= cooldown) {
      return; // Skip playing the sound
    }

    // Update the last played time for the sound
    _lastPlayedTimes[soundId] = now;

    // Play a random sound from the list
    player.playRandomSound(
      soundPaths,
      volume: volume,
    );
  }

  void playCooldownSound() {
    _playSoundWithCooldown(
      'ability_cooldown', 
      _isPersona ? AppSoundPaths.abilityCooldownPersona : AppSoundPaths.abilityCooldownDefault,
      volume: 0.35,
    );
  }

  void playNoManaSound() {
    _playSoundWithCooldown(
      'insufficient_mana', 
      _isPersona ? AppSoundPaths.noManaPersona : AppSoundPaths.noManaDefault,
      volume: 0.35,
    );
  }

  void playPersonaPickedSound() {
    _playSoundWithCooldown(
      'persona_select', 
      AppSoundPaths.personaSelect,
      volume: 0.40,
    );
  }

  void playLoadingSound() {
    player.playRandomSound(
      _isPersona ? AppSoundPaths.loadingPersona : AppSoundPaths.loadingDefault, 
      volume: 0.40,
    );
  }

  void playMeepMerp() => player.play(AppSoundPaths.meepMerp);





  void playInvoke({double volume = 0.35}) => player.play(AppSoundPaths.invoke, volume: volume);

  void playSpellSound(Spell spell) => player.playRandomSound(spell.spellSounds);

  
  //  Boss Battle Mode Specific Sounds  //

  void playHorn() => player.playRandomSound(AppSoundPaths.horns);

  void playBossEnteringSound(Bosses boss) async {
    int soundCount = 0;
    double volume = 0.35;
    Duration duration = Duration.zero;

    switch (boss) {
      case Bosses.templar:
      case Bosses.anti_mage:
      case Bosses.drow_ranger:
        soundCount = 1;
      default: soundCount = 2;
    }

    final int num = _rnd.nextInt(soundCount) + 1;
    final String sound = '${AppSoundPaths.boss}/${boss.name}/entering$num.mp3';

    if (boss == Bosses.templar) {
      volume = 0.50;
    }

    if (boss == Bosses.juggernaut) {
      duration = const Duration(milliseconds: 600);
      final String omnislash = '${AppSoundPaths.boss}/${boss.name}/omnislash';
      await Future.delayed(Duration.zero, () => player.play('${omnislash}1.mp3'));
      await Future.delayed(const Duration(milliseconds: 200), () => player.play('${omnislash}2.mp3'));
      await Future.delayed(const Duration(milliseconds: 350), () => player.play('${omnislash}3.mp3'));
    }

    if (boss == Bosses.blood_seeker) {
      volume = 0.60;
      duration = const Duration(milliseconds: 400);
      final String rupture = '${AppSoundPaths.boss}/${boss.name}/rupture.mp3';
      await Future.delayed(Duration.zero, () => player.play(rupture, volume: 0.10));
    }

    if (boss == Bosses.drow_ranger) {
      volume = 0.50;
      duration = const Duration(milliseconds: 600);
      final String shh = '${AppSoundPaths.boss}/${boss.name}/shh.mp3';
      await Future.delayed(Duration.zero, () => player.play(shh));
    }

    await Future.delayed(duration, () => player.play(sound, volume: volume));

    // Boss specific sounds
    if (boss == Bosses.riki) {
      final String smoke = '${AppSoundPaths.boss}/${boss.name}/smoke.mp3';
      await Future.delayed(const Duration(seconds: 1), () => player.play(smoke, volume: 0.16));
    }

    if (boss == Bosses.anti_mage) {
      final String blink = '${AppSoundPaths.boss}/${boss.name}/blink.mp3';
      await Future.delayed(Duration.zero, () => player.play(blink));
    }
  }
  
  void playBossDyingSound(Bosses boss) async {
    int soundCount = 0;
    double volume = 0.35;

    switch (boss) {
      case Bosses.anti_mage:
      case Bosses.templar:
        soundCount = 1;
      default : soundCount = 2;
    }

    final int num = _rnd.nextInt(soundCount) + 1;
    final String sound = '${AppSoundPaths.boss}/${boss.name}/dying$num.mp3';

    if (boss == Bosses.templar) {
      volume = 1.0;
    }

    if (boss == Bosses.juggernaut) {
      volume = 0.50;
    }

    if (boss == Bosses.blood_seeker) {
      volume = 0.50;
    }

    if (boss == Bosses.pudge && num == 1) {
      volume = 1.0;
    }

    if (boss == Bosses.wraith_king) {
      if (num == 1) {
        final String death1 = '${AppSoundPaths.boss}/${boss.name}/death1.mp3';
        final String death2 = '${AppSoundPaths.boss}/${boss.name}/death2.mp3';
        await Future.delayed(const Duration(milliseconds: 400), () => player.play(death1));
        await Future.delayed(const Duration(milliseconds: 2000), () => player.play(death2));
      } else {
        final String death3 = '${AppSoundPaths.boss}/${boss.name}/death3.mp3';
        final String death4 = '${AppSoundPaths.boss}/${boss.name}/death4.mp3';
        await Future.delayed(Duration.zero, () => player.play(death3));
        await Future.delayed(const Duration(milliseconds: 1400), () => player.play(death4));
      }
      return;
    }

    player.play(sound, volume: volume);
  }
  
  void playBossTauntSound(Bosses boss) async {
    int soundCount = 0;
    final double volume = boss == Bosses.templar ? 1.0 : 0.35;

    switch (boss) {
      case Bosses.anti_mage:
      case Bosses.huskar:
        soundCount = 1;
      default: soundCount = 2;
    }

    if (boss == Bosses.wraith_king) {
      final String laugh = '${AppSoundPaths.boss}/${boss.name}/laugh.mp3';
      await Future.delayed(Duration.zero, () => player.play(laugh));
      await Future.delayed(const Duration(milliseconds: 2600));
    }

    final int num = _rnd.nextInt(soundCount) + 1;
    final String sound = '${AppSoundPaths.boss}/${boss.name}/taunt$num.mp3';
    player.play(sound, volume: volume);

    // Boss specific sounds
    if (boss == Bosses.anti_mage) {
      final String manaVoid = '${AppSoundPaths.boss}/${boss.name}/mana_void.mp3';
      await Future.delayed(Duration.zero, () => player.play(manaVoid));
    }

    if (boss == Bosses.blood_seeker) {
      final String laugh = '${AppSoundPaths.boss}/${boss.name}/laugh.mp3';
      await Future.delayed(const Duration(milliseconds: 1850), () => player.play(laugh));
    }

    if (boss == Bosses.axe) {
      final String cullingBlade = '${AppSoundPaths.boss}/${boss.name}/culling_blade.mp3';
      await Future.delayed(Duration.zero, () => player.play(cullingBlade, volume: 0.20));
    }
  }

  void playWkReincarnation() async {
    const String reincarnation = '${AppSoundPaths.boss}/wraith_king/reincarnation.mp3';
    const String surprise = '${AppSoundPaths.boss}/wraith_king/surprise.mp3';
    const String laugh = '${AppSoundPaths.boss}/wraith_king/laugh.mp3';

    await Future.delayed(const Duration(milliseconds: 600));
    player.play(laugh);

    await Future.delayed(const Duration(milliseconds: 1000));
    player.play(reincarnation);

    await Future.delayed(const Duration(milliseconds: 3600));
    player.play(surprise);
  }

  void playItemSound(String itemName) => player.play('${AppSoundPaths.item}/$itemName.mp3');

  void playItemBuyingSound() => player.play(AppSoundPaths.itemBuy);
  
  void playItemSellingSound() => player.play(AppSoundPaths.itemSell);
  
  void playWelcomeShopSound() => player.playRandomSound(AppSoundPaths.shopEnter);

  void playLeaveShopSound() => player.playRandomSound(AppSoundPaths.shopExit);
  
  void spellCastTriggerSound(Spell spell) {
    playSpellSound(spell);
    player.play(spell.castSound, volume: 0.2);
  }



}
