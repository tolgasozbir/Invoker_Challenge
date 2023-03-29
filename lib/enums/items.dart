import '../constants/app_strings.dart';

enum Items {
  Null_talisman(
    bonus: "Increases mana by +60 and +1 mana regeneration", 
    cost: 505
  ),
  Void_stone(
    bonus: "+2.25 mana regeneration", 
    cost: 825
  ),
  Arcane_boots(
    bonus: "+250 mana", 
    cost: 1300, 
    active: "Restore 175 mana", 
    cooldown: 40, 
    mana: 0
  ),
  Power_treads(
    bonus: "+100 mana and +10 damage", 
    cost: 1400
  ),
  Phase_boots(
    bonus: "+18 damage", 
    cost: 1500
  ),
  Veil_of_discord(
    bonus: "Increases magic damage taken by bosses."
    +"\nDuration: 16 seconds", 
    cost: 1525, 
    active: "Spell amplification +18%", 
    cooldown: 30, 
    mana: 50, 
    duration: 16
  ),
  Kaya(
    bonus: "Mana regen amp +24% and spell amp +8%", 
    cost: 2050
  ),
  Hand_of_midas(
    bonus: "Gives 200 gold at the end of each round.\n(Multiple items won't work!)", 
    cost: 2200
  ),
  Aether_lens(
    bonus: "+300 mana and +2.5 mana regeneration", 
    cost: 2275
  ),
  Meteor_hammer(
    bonus: "+2.5 mana regeneration"
    +"\nDuration: 6 seconds. Deals damage to bosses over time.", 
    cost: 2300, 
    active: "Damage Per Second: 100", 
    cooldown: 24, 
    mana: 100, 
    duration: 6
  ),
  Vladmirs_offering(
    bonus: "Damage +24%", 
    cost: 2450
  ),
  Ethereal_blade(
    bonus: "+500 Mana with mana regen amp +75% and spell amp +16%"
    +"\nDuration: 10 Seconds"
    +"\n(Multiple item stats won't stacks!)", 
    cost: 4650, 
    active: "Magic Amplification +40%", 
    cooldown: 20, 
    mana: 200, 
    duration: 8
  ),
  Monkey_king_bar(
    bonus: "Increases damage by 36", 
    cost: 4975
  ),
  Refresher_orb(
    bonus: "+7 mana regeneration", 
    cost: 5000, 
    active: "Resets the cooldowns of all your items and abilities."
    +"\n(Multiple items won't stacks)", 
    cooldown: 180, 
    mana: 350
  );

  const Items({required this.bonus, required this.cost, this.active, this.cooldown, this.mana, this.duration});

  final String bonus;
  final int cost;
  final String? active;
  final double? cooldown;
  final double? mana;
  final double? duration;
}

extension ItemExtension on Items {
  String get getName => name.replaceAll("_", " ");
  String get image => ImagePaths.items+name+'.png';
}