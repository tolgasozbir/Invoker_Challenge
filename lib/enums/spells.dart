import '../constants/app_image_paths.dart';
import '../constants/app_sounds_paths.dart';

enum Spell {
  cold_snap       (combination: 'qqq', cooldown: 20, mana: 125, damage: 72,  duration: 6),  //432
  ghost_walk      (combination: 'qqw', cooldown: 20, mana: 100, damage: 50,  duration: 8),  //400
  ice_wall        (combination: 'qqe', cooldown: 24, mana: 125, damage: 48,  duration: 9),  //432
  emp             (combination: 'www', cooldown: 20, mana: 125, damage: 400, duration: 1, effectDelay: Duration(milliseconds: 2800)),  //400
  tornado         (combination: 'wwq', cooldown: 22, mana: 150, damage: 460, duration: 1, effectDelay: Duration(milliseconds: 1600)),  //460
  alacrity        (combination: 'wwe', cooldown: 17, mana: 100, damage: 64,  duration: 8),  //512
  deafening_blast (combination: 'qwe', cooldown: 28, mana: 250, damage: 640, duration: 1),  //640
  sun_strike      (combination: 'eee', cooldown: 24, mana: 175, damage: 480, duration: 1, effectDelay: Duration(milliseconds: 1600)),  //480
  forge_spirit    (combination: 'eeq', cooldown: 26, mana: 75,  damage: 68,  duration: 8),  //544
  chaos_meteor    (combination: 'eew', cooldown: 30, mana: 200, damage: 160, duration: 5, effectDelay: Duration(milliseconds: 1200));  //800

  const Spell({required this.combination, required this.cooldown, required this.mana, required this.damage, required this.duration, this.effectDelay = Duration.zero});

  final String combination;
  final double cooldown;
  final double mana;
  final double damage;
  final int duration;
  final Duration effectDelay;

}

extension SpellsExtension on Spell {
  String get image => '${ImagePaths.spells}$name.png';

  String get castSound => '${AppSoundsPaths.spellCastSounds}/${name}_cast.mpeg';
  
  List<String> get spellSounds {
    switch (this) {
      case Spell.cold_snap:       return AppSoundsPaths.coldSnapSounds;
      case Spell.ghost_walk:      return AppSoundsPaths.ghostWalkSounds;
      case Spell.ice_wall:        return AppSoundsPaths.iceWallSounds;
      case Spell.emp:             return AppSoundsPaths.empSounds;
      case Spell.tornado:         return AppSoundsPaths.tornadoSounds;
      case Spell.alacrity:        return AppSoundsPaths.alacritySounds;
      case Spell.deafening_blast: return AppSoundsPaths.deafeningBlastSounds;
      case Spell.sun_strike:      return AppSoundsPaths.sunStrikeSounds;
      case Spell.forge_spirit:    return AppSoundsPaths.forgeSpiritSounds;
      case Spell.chaos_meteor:    return AppSoundsPaths.chaosMeteorSounds;
    }
  }

}
