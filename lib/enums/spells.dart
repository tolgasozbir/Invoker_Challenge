import 'dart:ui';

import 'package:flutter/material.dart';

import '../constants/app_image_paths.dart';
import '../constants/app_sound_paths.dart';
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

  String get castSound => '${AppSoundPaths.spellCast}/${name}_cast.mp3';

  bool get _isPersona => UserManager.instance.isPersonaActive;
  
  List<String> get spellSounds {
    switch (this) {
      case Spell.cold_snap:       return _isPersona ? AppSoundPaths.coldSnapPersona        : AppSoundPaths.coldSnap;
      case Spell.ghost_walk:      return _isPersona ? AppSoundPaths.ghostWalkPersona       : AppSoundPaths.ghostWalk;
      case Spell.ice_wall:        return _isPersona ? AppSoundPaths.iceWallPersona         : AppSoundPaths.iceWall;
      case Spell.emp:             return _isPersona ? AppSoundPaths.empPersona             : AppSoundPaths.emp;
      case Spell.tornado:         return _isPersona ? AppSoundPaths.tornadoPersona         : AppSoundPaths.tornado;
      case Spell.alacrity:        return _isPersona ? AppSoundPaths.alacrityPersona        : AppSoundPaths.alacrity;
      case Spell.deafening_blast: return _isPersona ? AppSoundPaths.deafeningBlastPersona  : AppSoundPaths.deafeningBlast;
      case Spell.sun_strike:      return _isPersona ? AppSoundPaths.sunStrikePersona       : AppSoundPaths.sunStrike;
      case Spell.forge_spirit:    return _isPersona ? AppSoundPaths.forgeSpiritPersona     : AppSoundPaths.forgeSpirit;
      case Spell.chaos_meteor:    return _isPersona ? AppSoundPaths.chaosMeteorPersona     : AppSoundPaths.chaosMeteor;
    }
  }
  
  Color get spellColor {
    switch (this) {
      case Spell.cold_snap:       return _isPersona ? const Color(0xff5eb3f4) : const Color(0xff5eb3f4);
      case Spell.ghost_walk:      return _isPersona ? const Color(0xffbb80cb) : const Color(0xffd3c8e5);
      case Spell.ice_wall:        return _isPersona ? const Color(0xffd2e7f6) : const Color(0xffd2e7f6);
      case Spell.emp:             return _isPersona ? const Color(0xffe673e8) : const Color(0xffe673e8);
      case Spell.tornado:         return _isPersona ? const Color(0xffe058d6) : const Color(0xff9d51b6);
      case Spell.alacrity:        return _isPersona ? const Color(0xfff0c593) : const Color(0xffe1a1dc);
      case Spell.deafening_blast: return _isPersona ? const Color(0xffdd45da) : const Color(0xffe097ae);
      case Spell.sun_strike:      return _isPersona ? const Color(0xffd5852d) : const Color(0xffdfbb54);
      case Spell.forge_spirit:    return _isPersona ? const Color(0xffe9430e) : const Color(0xffd4a723);
      case Spell.chaos_meteor:    return _isPersona ? const Color(0xffe2b672) : const Color(0xffe2b672);
    }
  }

}
