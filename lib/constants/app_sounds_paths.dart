class AppSoundsPaths {
  const AppSoundsPaths._();

  //  Paths  //
  static const String _root           = 'assets/sounds';
  static const String _ggSounds       = '$_root/gg_sounds';
  static const String _loadingSounds  = '$_root/loading_sounds';
  static const String _spellSounds    = '$_root/spell_sounds';
  static const String _miscSounds     = '$_root/misc';
  static const String _shopSounds     = '$_root/shop_sounds';
  
  static const String spellCastSounds   = '$_spellSounds/cast_sounds';
  static const String itemSounds        = '$_root/item_sounds';
  static const String bossSounds        = '$_root/boss_sounds';
  static const String abilityOnCooldown = '$_root/ability_on_cooldown/notyet';
  static const String abilityOnCooldownKid = '$_root/ability_on_cooldown/kid_notyet';
  static const String notEnoughMana     = '$_root/not_enough_mana/nomana';
  static const String notEnoughManaKid     = '$_root/not_enough_mana/kid_nomana';

  //  Shop Sounds  //
  static const String itemBuying  = '$_shopSounds/item_buying.mpeg';
  static const String itemSelling = '$_shopSounds/Item_selling.mpeg';
  static const String shopWelcome = '$_shopSounds/shop_welcome';
  static const String shopLeave   = '$_shopSounds/shop_leave';

  //  Misc  //
  static const String meepMerp      = '$_miscSounds/meep_merp.mp3';
  static const String invoke        = '$_miscSounds/Invoke.mpeg';
  static const List<String> horns = [
    '$_miscSounds/horn_dire.mpeg',
    '$_miscSounds/horn_radiant.mpeg',
  ];
  static const List<String> personaPickSounds = [
    '$_miscSounds/kid_select1.mp3',
    '$_miscSounds/kid_select2.mp3',
  ];

  static const List<String> failSounds = [
    '$_root/fail_sounds/fail1.mp3',
    '$_root/fail_sounds/fail2.mp3',
    '$_root/fail_sounds/fail3.mp3',
    '$_root/fail_sounds/fail4.mp3',
    '$_root/fail_sounds/fail5.mp3',
    '$_root/fail_sounds/fail6.mp3',
    '$_root/fail_sounds/fail7.mp3',
  ];  
  
  static const List<String> failSoundsKid = [
    '$_root/fail_sounds/kid_fail1.mp3',
    '$_root/fail_sounds/kid_fail2.mp3',
    '$_root/fail_sounds/kid_fail3.mp3',
    '$_root/fail_sounds/kid_fail4.mp3',
    '$_root/fail_sounds/kid_fail5.mp3',
  ];

  static const List<String> loadingSounds = [
    '$_loadingSounds/begin1.mp3',
    '$_loadingSounds/begin2.mp3',
    '$_loadingSounds/begin3.mp3',
    '$_loadingSounds/begin4.mp3',
    '$_loadingSounds/begin5.mp3',
  ];  
  
  static const List<String> loadingSoundsKid = [
    '$_loadingSounds/kid_begin1.mp3',
    '$_loadingSounds/kid_begin2.mp3',
    '$_loadingSounds/kid_begin3.mp3',
    '$_loadingSounds/kid_begin4.mp3',
    '$_loadingSounds/kid_begin5.mp3',
  ];

  static const List<String> ggSounds = [
    '$_ggSounds/gg1.mpeg',
    '$_ggSounds/gg2.mpeg',
    '$_ggSounds/gg3.mpeg',
    '$_ggSounds/gg4.mpeg',
  ];
  
  static const List<String> ggSoundsKid = [
    '$_ggSounds/kid_gg1.mp3',
    '$_ggSounds/kid_gg2.mp3',
    '$_ggSounds/kid_gg3.mp3',
    '$_ggSounds/kid_gg4.mp3',
  ];

  
  //  Spell Sounds  //

  static const coldSnapSounds = [
    '$_spellSounds/cold_snap1.mp3',
    '$_spellSounds/cold_snap2.mp3',
    '$_spellSounds/cold_snap3.mp3',
  ];
  
  static const coldSnapSoundsKid = [
    '$_spellSounds/kid_cold_snap1.mp3',
    '$_spellSounds/kid_cold_snap2.mp3',
    '$_spellSounds/kid_cold_snap3.mp3',
  ];

  static const ghostWalkSounds = [
    '$_spellSounds/ghost_walk1.mp3',
    '$_spellSounds/ghost_walk2.mp3',
    '$_spellSounds/ghost_walk3.mp3',
  ];
  
  static const ghostWalkSoundsKid = [
    '$_spellSounds/kid_ghost_walk1.mp3',
    '$_spellSounds/kid_ghost_walk2.mp3',
  ];

  static const iceWallSounds = [
    '$_spellSounds/icewall1.mp3',
    '$_spellSounds/icewall2.mp3',
  ];
  
  static const iceWallSoundsKid = [
    '$_spellSounds/kid_icewall1.mp3',
    '$_spellSounds/kid_icewall2.mp3',
  ];

  static const empSounds = [
    '$_spellSounds/emp1.mp3',
    '$_spellSounds/emp2.mp3',
    '$_spellSounds/emp3.mp3',
  ];
  
  static const empSoundsKid = [
    '$_spellSounds/kid_emp1.mp3',
    '$_spellSounds/kid_emp2.mp3',
    '$_spellSounds/kid_emp3.mp3',
  ];

  static const tornadoSounds = [
    '$_spellSounds/tornado1.mp3',
    '$_spellSounds/tornado2.mp3',
    '$_spellSounds/tornado3.mp3',
  ];
  
  static const tornadoSoundsKid = [
    '$_spellSounds/kid_tornado1.mp3',
    '$_spellSounds/kid_tornado2.mp3',
    '$_spellSounds/kid_tornado3.mp3',
  ];

  static const alacritySounds = [
    '$_spellSounds/alacrity1.mp3',
    '$_spellSounds/alacrity2.mp3',
  ];

  static const alacritySoundsKid = [
    '$_spellSounds/kid_alacrity1.mp3',
    '$_spellSounds/kid_alacrity2.mp3',
  ];

  static const deafeningBlastSounds = [
    '$_spellSounds/blast1.mp3',
    '$_spellSounds/blast2.mp3',
    '$_spellSounds/blast3.mp3',
  ];
  
  static const deafeningBlastSoundsKid = [
    '$_spellSounds/kid_blast1.mp3',
    '$_spellSounds/kid_blast2.mp3',
    '$_spellSounds/kid_blast3.mp3',
  ];

  static const sunStrikeSounds = [
    '$_spellSounds/sunstrike1.mp3',
    '$_spellSounds/sunstrike2.mp3',
    '$_spellSounds/sunstrike3.mp3',
  ];
  
  static const sunStrikeSoundsKid = [
    '$_spellSounds/kid_sun_strike1.mp3',
    '$_spellSounds/kid_sun_strike2.mp3',
    '$_spellSounds/kid_sun_strike3.mp3',
  ];

  static const forgeSpiritSounds = [
    '$_spellSounds/forge_spirit1.mp3',
    '$_spellSounds/forge_spirit2.mp3',
  ];
  
  static const forgeSpiritSoundsKid = [
    '$_spellSounds/kid_forge_spirit1.mp3',
    '$_spellSounds/kid_forge_spirit2.mp3',
  ];

  static const chaosMeteorSounds = [
    '$_spellSounds/meteor1.mp3',
    '$_spellSounds/meteor2.mp3',
  ];
  
  static const chaosMeteorSoundsKid = [
    '$_spellSounds/kid_meteor1.mp3',
    '$_spellSounds/kid_meteor2.mp3',
    '$_spellSounds/kid_meteor3.mp3',
  ];

}
