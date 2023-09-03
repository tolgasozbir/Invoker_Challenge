import 'package:dota2_invoker_game/extensions/string_extension.dart';

import '../constants/app_image_paths.dart';
import '../constants/locale_keys.g.dart';

enum Items {
  //TODO:
  // Octarine_core(
  //   bonuses: ItemBonuses(
  //     mana: 625,
  //     manaRegen: 5,
  //   ),
  //   cost: 5000,
  // ),

  Null_talisman(
    bonuses: ItemBonuses(
      mana: 60,
      manaRegen: 0.8,
    ),
    cost: 500,
  ),

  Void_stone(
    bonuses: ItemBonuses(
      manaRegen: 2.25,
    ),
    cost: 825,
  ),

  Arcane_boots(
    bonuses: ItemBonuses(
      mana: 250,
    ),
    cost: 1300, 
    active: 'Restore 175 mana', 
    cooldown: 40, 
    manaCost: 0,
    hasSound: true,
  ),

  Power_treads(
    bonuses: ItemBonuses(
      mana: 120,
      damage: 12,
    ),
    cost: 1400,
  ),

  Phase_boots(
    bonuses: ItemBonuses(
      mana: 120,
      damage: 18,
    ),
    cost: 1500,
  ),

  Veil_of_discord(
    bonuses: ItemBonuses(),
    // bonus: 'Increases magic damage taken by bosses.'
    // '\nDuration: 16 seconds', ////
    cost: 1525, 
    active: 'Spell amplification +20%', 
    cooldown: 30, 
    manaCost: 50, 
    duration: 16,
    hasSound: true,
  ),

  Kaya(
    bonuses: ItemBonuses(
      spellAmp: 0.08,
      manaRegenAmp: 0.24,
    ),
    cost: 2050,
  ),

  Hand_of_midas(
    bonuses: ItemBonuses(),
    cost: 2200,
    hasSound: true,
  ),

  Aether_lens(
    bonuses: ItemBonuses(
      mana: 320,
      manaRegen: 3,
    ), 
    cost: 2275,
  ),

  Meteor_hammer(
    bonuses: ItemBonuses(
      manaRegen: 2.75,
    ),
    // bonus: '+2.75 mana regeneration'
    // '\nDuration: 6 seconds. Deals damage to bosses over time.', 
    cost: 2300, 
    active: 'Damage Per Second: 100', 
    cooldown: 24, 
    manaCost: 100, 
    duration: 6,
    hasSound: true,
  ),

  Vladmirs_offering(
    bonuses: ItemBonuses(
      damageMultiplier: 0.24,
    ),
    cost: 2450,
  ),

  Ethereal_blade(
    bonuses: ItemBonuses(
      mana: 400,
      manaRegenAmp: 0.72,
      spellAmp: 0.16,
    ),
    cost: 4650, 
    active: 'Magic Amplification +40%', 
    cooldown: 36, 
    manaCost: 200, 
    duration: 8,
    hasSound: true,
  ),

  Monkey_king_bar(
    bonuses: ItemBonuses(
      damage: 48,
    ),
    cost: 4575,
  ),

  Refresher_orb(
    bonuses: ItemBonuses(
      manaRegen: 7,
    ),
    cost: 5000, 
    active: 'Resets the cooldowns of all your items and abilities.'
    "\n(Multiple items won't stacks)", 
    cooldown: 180, 
    manaCost: 350,
    hasSound: true,
  ),

  Daedalus(
    bonuses: ItemBonuses(
      damage: 64,
    ),
    cost: 5650,
  ),
  
  Eye_of_skadi(
    bonuses: ItemBonuses(
      mana: 1600,
    ),
    cost: 5200,
  ),
  
  Bloodthorn(
    bonuses: ItemBonuses(
      damage: 40,
      mana: 400,
      manaRegen: 4.0,
    ),
    cost: 6800,
  ),
  
  Dagon(
    bonuses: ItemBonuses(), //damage?
    cost: 7950,
    active: '+3200 Magic Damage',
    cooldown: 30,
    manaCost: 200,
    duration: 1,
    hasSound: true,
  ),
  
  Divine_rapier(
    bonuses: ItemBonuses(
      damage: 128,
    ),
    cost: 9900,
  ),

  Aghanims_scepter(
    bonuses: ItemBonuses(
      mana: 400,
      damage: 10,
    ),
    cost: 5800,
    consumable: true,
  ),
  
  Aghanims_shard(
    bonuses: ItemBonuses(),
    cost: 1400,
    consumable: true,
  );

  // Aegis(
  //   bonus: "",
  //   cost: 0,
  // );

  const Items({required this.bonuses, required this.cost, this.active, this.cooldown, this.manaCost, this.duration, this.hasSound = false, this.consumable = false});

  final ItemBonuses bonuses;
  final int cost;
  final String? active;
  final double? cooldown;
  final double? manaCost;
  final double? duration;
  final bool hasSound;
  final bool consumable;
}

class ItemBonuses {
  final double mana;
  final double manaRegen;
  final double manaRegenAmp;
  final double damage;
  final double damageMultiplier;
  final double spellAmp;

  const ItemBonuses({
    this.mana = 0,
    this.manaRegen = 0,
    this.manaRegenAmp = 0,
    this.damage = 0,
    this.damageMultiplier = 0,
    this.spellAmp = 0,
  });
}

extension ItemExtension on Items {
  String get getName => name.replaceAll('_', ' ');
  String get image => '${ImagePaths.items}$name.png';
  String get activeTranslation => _ItemTranslations._translations[this]?.active.locale ?? '';
  String get bonusTranslation => _ItemTranslations._translations[this]?.bonus.locale ?? '';
}

class _ItemTranslations {
  static final Map<Items, _Translation> _translations = {
    for (var item in Items.values)
      item: _Translation(
        bonus: _itemBonuses[item] ?? '',
        active: _itemActives[item] ?? '',
      ),
  };

  static final Map<Items, String> _itemBonuses = {
    Items.Null_talisman: LocaleKeys.Item_Null_talisman_bonus,
    Items.Void_stone: LocaleKeys.Item_Void_stone_bonus,
    Items.Arcane_boots: LocaleKeys.Item_Arcane_boots_bonus,
    Items.Power_treads: LocaleKeys.Item_Power_treads_bonus,
    Items.Phase_boots: LocaleKeys.Item_Phase_boots_bonus,
    Items.Veil_of_discord: LocaleKeys.Item_Veil_of_discord_bonus,
    Items.Kaya: LocaleKeys.Item_Kaya_bonus,
    Items.Hand_of_midas: LocaleKeys.Item_Hand_of_midas_bonus,
    Items.Aether_lens: LocaleKeys.Item_Aether_lens_bonus,
    Items.Meteor_hammer: LocaleKeys.Item_Meteor_hammer_bonus,
    Items.Vladmirs_offering: LocaleKeys.Item_Vladmirs_offering_bonus,
    Items.Ethereal_blade: LocaleKeys.Item_Ethereal_blade_bonus,
    Items.Monkey_king_bar: LocaleKeys.Item_Monkey_king_bar_bonus,
    Items.Refresher_orb: LocaleKeys.Item_Refresher_orb_bonus,
    Items.Daedalus: LocaleKeys.Item_Daedalus_bonus,
    Items.Eye_of_skadi: LocaleKeys.Item_Eye_of_skadi_bonus,
    Items.Bloodthorn: LocaleKeys.Item_Bloodthorn_bonus,
    Items.Dagon: LocaleKeys.Item_Dagon_bonus,
    Items.Divine_rapier: LocaleKeys.Item_Divine_rapier_bonus,
    Items.Aghanims_scepter: LocaleKeys.Item_Aghanims_scepter_bonus,
    Items.Aghanims_shard: LocaleKeys.Item_Aghanims_shard_bonus,
  };

  static final Map<Items, String> _itemActives = {
    Items.Null_talisman: LocaleKeys.Item_Null_talisman_active,
    Items.Void_stone: LocaleKeys.Item_Void_stone_active,
    Items.Arcane_boots: LocaleKeys.Item_Arcane_boots_active,
    Items.Power_treads: LocaleKeys.Item_Power_treads_active,
    Items.Phase_boots: LocaleKeys.Item_Phase_boots_active,
    Items.Veil_of_discord: LocaleKeys.Item_Veil_of_discord_active,
    Items.Kaya: LocaleKeys.Item_Kaya_active,
    Items.Hand_of_midas: LocaleKeys.Item_Hand_of_midas_active,
    Items.Aether_lens: LocaleKeys.Item_Aether_lens_active,
    Items.Meteor_hammer: LocaleKeys.Item_Meteor_hammer_active,
    Items.Vladmirs_offering: LocaleKeys.Item_Vladmirs_offering_active,
    Items.Ethereal_blade: LocaleKeys.Item_Ethereal_blade_active,
    Items.Monkey_king_bar: LocaleKeys.Item_Monkey_king_bar_active,
    Items.Refresher_orb: LocaleKeys.Item_Refresher_orb_active,
    Items.Daedalus: LocaleKeys.Item_Daedalus_active,
    Items.Eye_of_skadi: LocaleKeys.Item_Eye_of_skadi_active,
    Items.Bloodthorn: LocaleKeys.Item_Bloodthorn_active,
    Items.Dagon: LocaleKeys.Item_Dagon_active,
    Items.Divine_rapier: LocaleKeys.Item_Divine_rapier_active,
    Items.Aghanims_scepter: LocaleKeys.Item_Aghanims_scepter_active,
    Items.Aghanims_shard: LocaleKeys.Item_Aghanims_shard_active,
  };

}

class _Translation {
  final String bonus;
  final String active;

  const _Translation({
    required this.bonus,
    required this.active,
  });
}
