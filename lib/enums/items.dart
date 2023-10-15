import 'package:dota2_invoker_game/extensions/string_extension.dart';

import '../constants/app_image_paths.dart';
import '../constants/locale_keys.g.dart';

enum Items {

  Null_talisman(
    bonuses: ItemBonuses(
      mana: 60,
      manaRegen: 0.8,
    ),
    activeProps: ItemActiveProps(),
    cost: 500,
  ),

  Void_stone(
    bonuses: ItemBonuses(
      manaRegen: 2.25,
    ),
    activeProps: ItemActiveProps(),
    cost: 825,
  ),

  Arcane_boots(
    bonuses: ItemBonuses(
      mana: 250,
    ),
    activeProps: ItemActiveProps(
      cooldown: 40,
      manaCost: 0,
      activeBonuses: ItemActiveBonuses(
        mana: 175,
      ),
    ),
    cost: 1300, 
    hasSound: true,
  ),

  Power_treads(
    bonuses: ItemBonuses(
      mana: 120,
      damage: 12,
    ),
    activeProps: ItemActiveProps(),
    cost: 1400,
  ),

  Phase_boots(
    bonuses: ItemBonuses(
      mana: 120,
      damage: 18,
    ),
    activeProps: ItemActiveProps(),
    cost: 1500,
  ),

  Veil_of_discord(
    bonuses: ItemBonuses(),
    activeProps: ItemActiveProps(
      cooldown: 30,
      manaCost: 50,
      duration: 16,
      activeBonuses: ItemActiveBonuses(
        spellAmp: 0.20,
      ),
    ),
    cost: 1525, 
    hasSound: true,
  ),

  Kaya(
    bonuses: ItemBonuses(
      spellAmp: 0.08,
      manaRegenAmp: 0.24,
    ),
    activeProps: ItemActiveProps(),
    cost: 2050,
  ),

  Hand_of_midas(
    bonuses: ItemBonuses(),
    activeProps: ItemActiveProps(),
    cost: 2200,
    hasSound: true,
  ),

  Aether_lens(
    bonuses: ItemBonuses(
      mana: 320,
      manaRegen: 3,
    ), 
    activeProps: ItemActiveProps(),
    cost: 2275,
  ),

  Meteor_hammer(
    bonuses: ItemBonuses(
      manaRegen: 2.75,
    ),
    activeProps: ItemActiveProps(
      cooldown: 24, 
      manaCost: 100, 
      duration: 6,
      activeBonuses: ItemActiveBonuses(
        magicalDamage: 100,
      ),
    ),
    cost: 2300, 
    hasSound: true,
  ),

  Vladmirs_offering(
    bonuses: ItemBonuses(
      damageMultiplier: 0.24,
    ),
    activeProps: ItemActiveProps(),
    cost: 2450,
  ),

  Ethereal_blade(
    bonuses: ItemBonuses(
      mana: 400,
      manaRegenAmp: 0.72,
      spellAmp: 0.16,
    ),
    activeProps: ItemActiveProps(
      cooldown: 36, 
      manaCost: 200, 
      duration: 8,
      activeBonuses: ItemActiveBonuses(
        spellAmp: 0.40,
      ),
    ),
    cost: 4650, 
    hasSound: true,
  ),

  Monkey_king_bar(
    bonuses: ItemBonuses(
      damage: 48,
    ),
    activeProps: ItemActiveProps(),
    cost: 4575,
  ),

  Refresher_orb(
    bonuses: ItemBonuses(
      manaRegen: 7,
    ),
    activeProps: ItemActiveProps(
      cooldown: 180, 
      manaCost: 350,
    ),
    cost: 5000, 
    hasSound: true,
  ),

  Daedalus(
    bonuses: ItemBonuses(
      damage: 64,
    ),
    activeProps: ItemActiveProps(),
    cost: 5650,
  ),
  
  Eye_of_skadi(
    bonuses: ItemBonuses(
      mana: 1600,
    ),
    activeProps: ItemActiveProps(),
    cost: 5200,
  ),
  
  Bloodthorn(
    bonuses: ItemBonuses(
      damage: 40,
      mana: 400,
      manaRegen: 4.0,
    ),
    activeProps: ItemActiveProps(),
    cost: 6800,
  ),
  
  Dagon(
    bonuses: ItemBonuses(), //damage?
    activeProps: ItemActiveProps(
      cooldown: 30,
      manaCost: 200,
      duration: 1,
      activeBonuses: ItemActiveBonuses(
        magicalDamage: 3200,
      ),
    ),
    cost: 7950,
    hasSound: true,
  ),
  
  Divine_rapier(
    bonuses: ItemBonuses(
      damage: 128,
    ),
    activeProps: ItemActiveProps(),
    cost: 9900,
  ),

  Aghanims_scepter(
    bonuses: ItemBonuses(
      mana: 400,
      damage: 10,
    ),
    activeProps: ItemActiveProps(),
    cost: 5800,
    consumable: true,
  ),
  
  Aghanims_shard(
    bonuses: ItemBonuses(),
    activeProps: ItemActiveProps(),
    cost: 1400,
    consumable: true,
  );

  // Aegis(
  //   bonus: "",
  //   cost: 0,
  // );

  const Items({required this.bonuses, required this.activeProps, required this.cost, this.hasSound = false, this.consumable = false});

  final ItemBonuses bonuses;
  final ItemActiveProps activeProps;
  final int cost;

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

class ItemActiveBonuses {
  final double mana;
  //final double physicalDamage;
  final double magicalDamage;
  final double spellAmp;

  const ItemActiveBonuses({
    this.mana = 0,
    this.spellAmp = 0,
    this.magicalDamage = 0,
    //this.physicalDamage = 0,
  });
}

class ItemActiveProps {
  final double? cooldown;
  final double? manaCost;
  final double? duration;
  final ItemActiveBonuses activeBonuses;

  const ItemActiveProps({this.cooldown, this.manaCost, this.duration, this.activeBonuses = const ItemActiveBonuses()});
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
