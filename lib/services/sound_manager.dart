import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import '../constants/app_sounds_paths.dart';

import '../enums/Bosses.dart';
import '../enums/spells.dart';

class SoundManager {
  SoundManager._();

  static SoundManager? _instance;
  static SoundManager get instance => _instance ??= SoundManager._();

  AudioPlayer? _player;
  final _cache = AudioCache();
  final Random _rnd = Random();

  double _volume = 100;
  double get getVolume => _volume;
  void setVolume(double value) {
    _volume = value;
  }

  void _playSound({required String fileName, double volume = 0.35, bool nonstop = true}) async {
    if (!nonstop) {
      await _player?.stop();
    }
    //_player = await _cache.play(fileName, volume: volume * getVolume/100);
  }

  void _playRandomSound(List<String> sounds, {double volume = 0.35}) {
    if (sounds.isNotEmpty) {
      final sound = sounds[_rnd.nextInt(sounds.length)];
      _playSound(fileName: sound, volume: volume);
    }
  }

  
  // Common Sounds //

  void playLoadingSound() => _playRandomSound(AppSoundsPaths.loadingSounds, volume: 0.40);

  void playMeepMerp() => _playSound(fileName: AppSoundsPaths.meepMerp);

  void failCombinationSound() => _playRandomSound(AppSoundsPaths.failSounds);

  void ggSound() => _playRandomSound(AppSoundsPaths.ggSounds);

  void playInvoke({double volume = 0.35}) => _playSound(fileName: AppSoundsPaths.invoke, volume: volume);

  void playSpellSound(Spell spell) => _playRandomSound(spell.spellSounds);

  
  //  Boss Battle Mode Specific Sounds  //

  void playHorn() => _playRandomSound(AppSoundsPaths.horns);

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
      await Future.delayed(Duration.zero, () => _playSound(fileName: '${omnislash}1.mpeg'));
      await Future.delayed(const Duration(milliseconds: 200), () => _playSound(fileName: '${omnislash}2.mpeg'));
      await Future.delayed(const Duration(milliseconds: 350), () => _playSound(fileName: '${omnislash}3.mpeg'));
    }

    if (boss == Bosses.blood_seeker) {
      volume = 0.60;
      duration = const Duration(milliseconds: 400);
      final String rupture = '${AppSoundsPaths.bossSounds}/${boss.name}/rupture.mpeg';
      await Future.delayed(Duration.zero, () => _playSound(fileName: rupture, volume: 0.10));
    }

    if (boss == Bosses.drow_ranger) {
      volume = 0.50;
      duration = const Duration(milliseconds: 600);
      final String shh = '${AppSoundsPaths.bossSounds}/${boss.name}/shh.mpeg';
      await Future.delayed(Duration.zero, () => _playSound(fileName: shh));
    }

    await Future.delayed(duration, () => _playSound(fileName: sound, volume: volume));

    // Boss specific sounds
    if (boss == Bosses.riki) {
      final String smoke = '${AppSoundsPaths.bossSounds}/${boss.name}/smoke.mpeg';
      await Future.delayed(const Duration(seconds: 1), () => _playSound(fileName: smoke, volume: 0.16));
    }

    if (boss == Bosses.anti_mage) {
      final String blink = '${AppSoundsPaths.bossSounds}/${boss.name}/blink.mpeg';
      await Future.delayed(Duration.zero, () => _playSound(fileName: blink));
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
        await Future.delayed(const Duration(milliseconds: 400), () => _playSound(fileName: death1));
        await Future.delayed(const Duration(milliseconds: 2000), () => _playSound(fileName: death2));
      } else {
        final String death3 = '${AppSoundsPaths.bossSounds}/${boss.name}/death3.mpeg';
        final String death4 = '${AppSoundsPaths.bossSounds}/${boss.name}/death4.mpeg';
        await Future.delayed(Duration.zero, () => _playSound(fileName: death3));
        await Future.delayed(const Duration(milliseconds: 1400), () => _playSound(fileName: death4));
      }
      return;
    }

    _playSound(fileName: sound, volume: volume);
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
      await Future.delayed(Duration.zero, () => _playSound(fileName: laugh));
      await Future.delayed(const Duration(milliseconds: 2600));
    }

    final int num = _rnd.nextInt(soundCount) + 1;
    final String sound = '${AppSoundsPaths.bossSounds}/${boss.name}/taunt$num.mpeg';
    _playSound(fileName: sound, volume: volume);

    // Boss specific sounds
    if (boss == Bosses.anti_mage) {
      final String manaVoid = '${AppSoundsPaths.bossSounds}/${boss.name}/mana_void.mpeg';
      await Future.delayed(Duration.zero, () => _playSound(fileName: manaVoid));
    }

    if (boss == Bosses.blood_seeker) {
      final String laugh = '${AppSoundsPaths.bossSounds}/${boss.name}/laugh.mpeg';
      await Future.delayed(const Duration(milliseconds: 1850), () => _playSound(fileName: laugh));
    }

    if (boss == Bosses.axe) {
      final String cullingBlade = '${AppSoundsPaths.bossSounds}/${boss.name}/culling_blade.mpeg';
      await Future.delayed(Duration.zero, () => _playSound(fileName: cullingBlade, volume: 0.20));
    }
  }

  void playWkReincarnation() async {
    const String reincarnation = '${AppSoundsPaths.bossSounds}/wraith_king/reincarnation.mp3';
    const String surprise = '${AppSoundsPaths.bossSounds}/wraith_king/surprise.mp3';
    const String laugh = '${AppSoundsPaths.bossSounds}/wraith_king/laugh.mpeg';

    await Future.delayed(const Duration(milliseconds: 600));
    _playSound(fileName: laugh);

    await Future.delayed(const Duration(milliseconds: 1000));
    _playSound(fileName: reincarnation);

    await Future.delayed(const Duration(milliseconds: 3600));
    _playSound(fileName: surprise);
  }

  void playItemSound(String itemName) => _playSound(fileName: '${AppSoundsPaths.itemSounds}/$itemName.mpeg');

  void playItemBuyingSound() => _playSound(fileName: AppSoundsPaths.itemBuying);
  
  void playItemSellingSound() => _playSound(fileName: AppSoundsPaths.itemSelling);
  
  void playWelcomeShopSound() {
    final int soundNum = _rnd.nextInt(6) + 1;
    final String sound = '${AppSoundsPaths.shopWelcome}$soundNum.mpeg';
    _playSound(fileName: sound);
  }
  
  void playLeaveShopSound() {
    final int soundNum = _rnd.nextInt(5) + 1;
    final String sound = '${AppSoundsPaths.shopLeave}$soundNum.mpeg';
    _playSound(fileName: sound);
  }

  DateTime lastPlayedCdTime = DateTime.now();
  void playCooldownSound() {
    if (!(DateTime.now().difference(lastPlayedCdTime) > const Duration(seconds: 1))) return;
    lastPlayedCdTime = DateTime.now();
    final int soundNum = _rnd.nextInt(9) + 1;
    final String sound = '${AppSoundsPaths.abilityOnCooldown}$soundNum.mpeg';
    _playSound(fileName: sound);
  }
  
  DateTime lastPlayedNoManaTime = DateTime.now();
  void playNoManaSound() {
    if (!(DateTime.now().difference(lastPlayedNoManaTime) > const Duration(seconds: 1))) return;
    lastPlayedNoManaTime = DateTime.now();
    final int soundNum = _rnd.nextInt(9) + 1;
    final String sound = '${AppSoundsPaths.notEnoughMana}$soundNum.mpeg';
    _playSound(fileName: sound);
  }

  void spellCastTriggerSound(Spell spell) {
    playSpellSound(spell);
    _playSound(fileName: spell.castSound, volume: 0.2);
  }

}
