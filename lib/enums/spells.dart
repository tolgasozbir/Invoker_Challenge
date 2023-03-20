import '../constants/app_strings.dart';

enum Spells {
  cold_snap       (combine: 'qqq', cooldown: 20, mana: 100, damage: 56,  duration: 6),
  ghost_walk      (combine: 'qqw', cooldown: 35, mana: 175, damage: 50,  duration: 5),
  ice_wall        (combine: 'qqe', cooldown: 25, mana: 125, damage: 42,  duration: 12),
  emp             (combine: 'www', cooldown: 30, mana: 125, damage: 200, duration: 0),
  tornado         (combine: 'wwq', cooldown: 24, mana: 150, damage: 385, duration: 0),
  alacrity        (combine: 'wwe', cooldown: 17, mana: 100, damage: 82,  duration: 9),
  deafening_blast (combine: 'qwe', cooldown: 40, mana: 300, damage: 300, duration: 0),
  sun_strike      (combine: 'eee', cooldown: 25, mana: 175, damage: 480, duration: 0),
  forge_spirit    (combine: 'eeq', cooldown: 30, mana: 75,  damage: 64,  duration: 10),
  chaos_meteor    (combine: 'eew', cooldown: 40, mana: 200, damage: 200, duration: 5);

  const Spells({required this.combine, required this.cooldown, required this.mana, required this.damage, required this.duration});

  final String combine;
  final double cooldown;
  final double mana;
  final double damage;
  final int duration;

}

extension spellsExtension on Spells {
  String get image => '${ImagePaths.spells}$name.png';
}
