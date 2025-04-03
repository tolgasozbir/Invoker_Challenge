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

  void playLoadingSound() {
    player.playRandomSound(
      _isPersona ? AppSoundsPaths.loadingSoundsKid : AppSoundsPaths.loadingSounds, 
      volume: 0.40,
    );
  }

  void playMeepMerp() => player.play(AppSoundsPaths.meepMerp);

  void failCombinationSound() {
    player.playRandomSound(
      _isPersona ? AppSoundsPaths.failSoundsKid : AppSoundsPaths.failSounds,
      volume: 0.35,
    );
  }

  void ggSound() {
    player.playRandomSound(
      _isPersona ? AppSoundsPaths.ggSoundsKid : AppSoundsPaths.ggSounds,
      volume: 0.35,
    );
  }

  void playInvoke({double volume = 0.35}) => player.play(AppSoundsPaths.invoke, volume: volume);

  void playSpellSound(Spell spell) => player.playRandomSound(spell.spellSounds);

  
  //  Boss Battle Mode Specific Sounds  //

  void playHorn() => player.playRandomSound(AppSoundsPaths.horns);

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
    final String sound = '${AppSoundsPaths.bossSounds}/${boss.name}/entering$num.mpeg';

    if (boss == Bosses.templar) {
      volume = 0.50;
    }

    if (boss == Bosses.juggernaut) {
      duration = const Duration(milliseconds: 600);
      final String omnislash = '${AppSoundsPaths.bossSounds}/${boss.name}/omnislash';
      await Future.delayed(Duration.zero, () => player.play('${omnislash}1.mpeg'));
      await Future.delayed(const Duration(milliseconds: 200), () => player.play('${omnislash}2.mpeg'));
      await Future.delayed(const Duration(milliseconds: 350), () => player.play('${omnislash}3.mpeg'));
    }

    if (boss == Bosses.blood_seeker) {
      volume = 0.60;
      duration = const Duration(milliseconds: 400);
      final String rupture = '${AppSoundsPaths.bossSounds}/${boss.name}/rupture.mpeg';
      await Future.delayed(Duration.zero, () => player.play(rupture, volume: 0.10));
    }

    if (boss == Bosses.drow_ranger) {
      volume = 0.50;
      duration = const Duration(milliseconds: 600);
      final String shh = '${AppSoundsPaths.bossSounds}/${boss.name}/shh.mpeg';
      await Future.delayed(Duration.zero, () => player.play(shh));
    }

    await Future.delayed(duration, () => player.play(sound, volume: volume));

    // Boss specific sounds
    if (boss == Bosses.riki) {
      final String smoke = '${AppSoundsPaths.bossSounds}/${boss.name}/smoke.mpeg';
      await Future.delayed(const Duration(seconds: 1), () => player.play(smoke, volume: 0.16));
    }

    if (boss == Bosses.anti_mage) {
      final String blink = '${AppSoundsPaths.bossSounds}/${boss.name}/blink.mpeg';
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
    final String sound = '${AppSoundsPaths.bossSounds}/${boss.name}/dying$num.mpeg';

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
        final String death1 = '${AppSoundsPaths.bossSounds}/${boss.name}/death1.mpeg';
        final String death2 = '${AppSoundsPaths.bossSounds}/${boss.name}/death2.mpeg';
        await Future.delayed(const Duration(milliseconds: 400), () => player.play(death1));
        await Future.delayed(const Duration(milliseconds: 2000), () => player.play(death2));
      } else {
        final String death3 = '${AppSoundsPaths.bossSounds}/${boss.name}/death3.mpeg';
        final String death4 = '${AppSoundsPaths.bossSounds}/${boss.name}/death4.mpeg';
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
      final String laugh = '${AppSoundsPaths.bossSounds}/${boss.name}/laugh.mpeg';
      await Future.delayed(Duration.zero, () => player.play(laugh));
      await Future.delayed(const Duration(milliseconds: 2600));
    }

    final int num = _rnd.nextInt(soundCount) + 1;
    final String sound = '${AppSoundsPaths.bossSounds}/${boss.name}/taunt$num.mpeg';
    player.play(sound, volume: volume);

    // Boss specific sounds
    if (boss == Bosses.anti_mage) {
      final String manaVoid = '${AppSoundsPaths.bossSounds}/${boss.name}/mana_void.mpeg';
      await Future.delayed(Duration.zero, () => player.play(manaVoid));
    }

    if (boss == Bosses.blood_seeker) {
      final String laugh = '${AppSoundsPaths.bossSounds}/${boss.name}/laugh.mpeg';
      await Future.delayed(const Duration(milliseconds: 1850), () => player.play(laugh));
    }

    if (boss == Bosses.axe) {
      final String cullingBlade = '${AppSoundsPaths.bossSounds}/${boss.name}/culling_blade.mpeg';
      await Future.delayed(Duration.zero, () => player.play(cullingBlade, volume: 0.20));
    }
  }

  void playWkReincarnation() async {
    const String reincarnation = '${AppSoundsPaths.bossSounds}/wraith_king/reincarnation.mp3';
    const String surprise = '${AppSoundsPaths.bossSounds}/wraith_king/surprise.mp3';
    const String laugh = '${AppSoundsPaths.bossSounds}/wraith_king/laugh.mpeg';

    await Future.delayed(const Duration(milliseconds: 600));
    player.play(laugh);

    await Future.delayed(const Duration(milliseconds: 1000));
    player.play(reincarnation);

    await Future.delayed(const Duration(milliseconds: 3600));
    player.play(surprise);
  }

  void playItemSound(String itemName) => player.play('${AppSoundsPaths.itemSounds}/$itemName.mpeg');

  void playItemBuyingSound() => player.play(AppSoundsPaths.itemBuying);
  
  void playItemSellingSound() => player.play(AppSoundsPaths.itemSelling);
  
  void playWelcomeShopSound() {
    final int soundNum = _rnd.nextInt(6) + 1;
    final String sound = '${AppSoundsPaths.shopWelcome}$soundNum.mpeg';
    player.play(sound);
  }
  
  void playLeaveShopSound() {
    final int soundNum = _rnd.nextInt(5) + 1;
    final String sound = '${AppSoundsPaths.shopLeave}$soundNum.mpeg';
    player.play(sound);
  }

  DateTime lastPlayedCdTime = DateTime.now();
  void playCooldownSound() {
    if (!(DateTime.now().difference(lastPlayedCdTime) > const Duration(seconds: 1))) return;
    lastPlayedCdTime = DateTime.now();
    final int soundNum = _rnd.nextInt(9) + 1;
    String sound = '${AppSoundsPaths.abilityOnCooldown}$soundNum.mpeg';
    if (_isPersona) {
      sound = '${AppSoundsPaths.abilityOnCooldownKid}$soundNum.mp3';
    }
    player.play(sound, volume: 0.35);
  }
  
  DateTime lastPlayedNoManaTime = DateTime.now();
  void playNoManaSound() {
    if (!(DateTime.now().difference(lastPlayedNoManaTime) > const Duration(seconds: 1))) return;
    lastPlayedNoManaTime = DateTime.now();
    final int soundNum = _rnd.nextInt(9) + 1;
    String sound = '${AppSoundsPaths.notEnoughMana}$soundNum.mpeg';
    if (_isPersona) {
      sound = '${AppSoundsPaths.notEnoughManaKid}$soundNum.mp3';
    }
    player.play(sound, volume: 0.35);
  }

  void spellCastTriggerSound(Spell spell) {
    playSpellSound(spell);
    player.play(spell.castSound, volume: 0.2);
  }

  // Oth
  DateTime lastPlayedPersonaPickTime = DateTime.now();
  void playPersonaPickedSound() {
    if (!(DateTime.now().difference(lastPlayedPersonaPickTime) > const Duration(seconds: 2))) return;
    lastPlayedPersonaPickTime = DateTime.now();
    player.playRandomSound(AppSoundsPaths.personaPickSounds, volume: 0.40);
  }

}
