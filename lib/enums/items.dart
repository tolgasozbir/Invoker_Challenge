import '../constants/app_strings.dart';

enum Items {
  Null_talisman(
    bonus: 'Increases mana by +60 and +0.8 mana regeneration', 
    cost: 500,
  ),

  Void_stone(
    bonus: '+2.25 mana regeneration', 
    cost: 825,
  ),

  Arcane_boots(
    bonus: '+250 mana', 
    cost: 1300, 
    active: 'Restore 175 mana', 
    cooldown: 40, 
    manaCost: 0,
    hasSound: true,
  ),

  Power_treads(
    bonus: '+100 mana and +10 damage', 
    cost: 1400,
  ),

  Phase_boots(
    bonus: '+16 damage', 
    cost: 1500,
  ),

  Veil_of_discord(
    bonus: 'Increases magic damage taken by bosses.'
    '\nDuration: 16 seconds', 
    cost: 1525, 
    active: 'Spell amplification +20%', 
    cooldown: 30, 
    manaCost: 50, 
    duration: 16,
    hasSound: true,
  ),

  Kaya(
    bonus: 'Mana regen amp +24% and spell amp +8%', 
    cost: 2050,
  ),

  Hand_of_midas(
    bonus: "Gives 360 gold at the end of each round.\n(Multiple items won't work!)", 
    cost: 2200,
    hasSound: true,
  ),

  Aether_lens(
    bonus: '+300 mana and +3 mana regeneration', 
    cost: 2275,
  ),

  Meteor_hammer(
    bonus: '+2.75 mana regeneration'
    '\nDuration: 6 seconds. Deals damage to bosses over time.', 
    cost: 2300, 
    active: 'Damage Per Second: 100', 
    cooldown: 24, 
    manaCost: 100, 
    duration: 6,
    hasSound: true,
  ),

  Vladmirs_offering(
    bonus: 'Damage +24%', 
    cost: 2450,
  ),

  Ethereal_blade(
    bonus: '+400 Mana with mana regen amp +72% and spell amp +16%'
    '\nDuration: 8 Seconds'
    "\n(Multiple item stats won't stacks!)", 
    cost: 4650, 
    active: 'Magic Amplification +40%', 
    cooldown: 36, 
    manaCost: 200, 
    duration: 8,
    hasSound: true,
  ),

  Monkey_king_bar(
    bonus: 'Increases damage by 48', 
    cost: 4575,
  ),

  Refresher_orb(
    bonus: '+7 mana regeneration', 
    cost: 5000, 
    active: 'Resets the cooldowns of all your items and abilities.'
    "\n(Multiple items won't stacks)", 
    cooldown: 180, 
    manaCost: 350,
    hasSound: true,
  ),

  Daedalus(
    bonus: 'Increases damage by 64', 
    cost: 5650,
  ),
  
  Eye_of_skadi(
    bonus: 'Increases mana by +1600', 
    cost: 5200,
  ),
  
  Bloodthorn(
    bonus: '+40 Attack Damage'
    '\n+400 Mana'
    '\n+4.0 Mana Regeneration', 
    cost: 6800,
  ),
  
  Dagon(
    bonus: 'Energy Burst',
    cost: 7950,
    active: '+3200 Magic Damage',
    cooldown: 30,
    manaCost: 200,
    duration: 1,
    hasSound: true,
  ),
  
  Divine_rapier(
    bonus: 'Increases damage by 128', 
    cost: 9900,
  );

  // Aegis(
  //   bonus: "",
  //   cost: 0,
  // );

  const Items({required this.bonus, required this.cost, this.active, this.cooldown, this.manaCost, this.duration, this.hasSound = false});

  final String bonus;
  final int cost;
  final String? active;
  final double? cooldown;
  final double? manaCost;
  final double? duration;
  final bool hasSound;
}

extension ItemExtension on Items {
  String get getName => name.replaceAll('_', ' ');
  String get image => '${ImagePaths.items}$name.png';
}
