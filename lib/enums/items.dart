import '../constants/app_strings.dart';

enum Items {
  Null_talisman(bonus: "Increases Mana by +60 and +1 Mana Regeneration", cost: 505),
  Void_stone(bonus: "+2.25 Mana Regeneration", cost: 825),
  Arcane_boots(bonus: "+250 Mana", cost: 1300, active: "Restore 175 mana", cooldown: 40, mana: 0),
  Power_treads(bonus: "+120 Mana and +12 Damage", cost: 1400),
  Phase_boots(bonus: "+30 Damage", cost: 1500);
  
  const Items({required this.bonus, required this.cost, this.active, this.cooldown, this.mana});

  final String bonus;
  final int cost;
  final String? active;
  final double? cooldown;
  final double? mana;
}

extension ItemExtension on Items {
  String get getName => name.replaceAll("_", " ");
  String get image => ImagePaths.items+name+'.png';
}