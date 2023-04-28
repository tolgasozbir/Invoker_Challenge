import '../constants/app_strings.dart';

enum Spells {
  cold_snap       (combine: 'qqq', cooldown: 20, mana: 125, damage: 72,  duration: 6),  //432
  ghost_walk      (combine: 'qqw', cooldown: 20, mana: 100, damage: 50,  duration: 8),  //400
  ice_wall        (combine: 'qqe', cooldown: 24, mana: 125, damage: 36,  duration: 12), //432
  emp             (combine: 'www', cooldown: 20, mana: 125, damage: 400, duration: 1),  //400
  tornado         (combine: 'wwq', cooldown: 22, mana: 150, damage: 380, duration: 1),  //380
  alacrity        (combine: 'wwe', cooldown: 17, mana: 100, damage: 70,  duration: 8),  //560
  deafening_blast (combine: 'qwe', cooldown: 28, mana: 250, damage: 640, duration: 1),  //640
  sun_strike      (combine: 'eee', cooldown: 24, mana: 175, damage: 480, duration: 1),  //480
  forge_spirit    (combine: 'eeq', cooldown: 26, mana: 75,  damage: 68,  duration: 8),  //544
  chaos_meteor    (combine: 'eew', cooldown: 30, mana: 200, damage: 160, duration: 5);  //800

  const Spells({required this.combine, required this.cooldown, required this.mana, required this.damage, required this.duration});

  final String combine;
  final double cooldown;
  final double mana;
  final double damage;
  final int duration;

}

extension SpellsExtension on Spells {
  String get image => '${ImagePaths.spells}$name.png';
}
