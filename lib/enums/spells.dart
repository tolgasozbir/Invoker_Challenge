import '../constants/app_image_paths.dart';
import '../constants/app_sounds_paths.dart';
import '../services/user_manager.dart';

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
  String get image => UserManager.instance.invokerType.spells[this] ?? ImagePaths.ic_unknown;

  String get castSound => '${AppSoundsPaths.spellCastSounds}/${name}_cast.mpeg';

  bool get _isPersona => UserManager.instance.isPersonaActive;
  
  List<String> get spellSounds {
    switch (this) {
      case Spell.cold_snap:       return _isPersona ? AppSoundsPaths.coldSnapSoundsKid        : AppSoundsPaths.coldSnapSounds;
      case Spell.ghost_walk:      return _isPersona ? AppSoundsPaths.ghostWalkSoundsKid       : AppSoundsPaths.ghostWalkSounds;
      case Spell.ice_wall:        return _isPersona ? AppSoundsPaths.iceWallSoundsKid         : AppSoundsPaths.iceWallSounds;
      case Spell.emp:             return _isPersona ? AppSoundsPaths.empSoundsKid             : AppSoundsPaths.empSounds;
      case Spell.tornado:         return _isPersona ? AppSoundsPaths.tornadoSoundsKid         : AppSoundsPaths.tornadoSounds;
      case Spell.alacrity:        return _isPersona ? AppSoundsPaths.alacritySoundsKid        : AppSoundsPaths.alacritySounds;
      case Spell.deafening_blast: return _isPersona ? AppSoundsPaths.deafeningBlastSoundsKid  : AppSoundsPaths.deafeningBlastSounds;
      case Spell.sun_strike:      return _isPersona ? AppSoundsPaths.sunStrikeSoundsKid       : AppSoundsPaths.sunStrikeSounds;
      case Spell.forge_spirit:    return _isPersona ? AppSoundsPaths.forgeSpiritSoundsKid     : AppSoundsPaths.forgeSpiritSounds;
      case Spell.chaos_meteor:    return _isPersona ? AppSoundsPaths.chaosMeteorSoundsKid     : AppSoundsPaths.chaosMeteorSounds;
    }
  }

}
