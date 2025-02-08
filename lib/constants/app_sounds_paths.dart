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
  static const String notEnoughMana     = '$_root/not_enough_mana/nomana';

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

  static const List<String> failSounds = [
    '$_root/fail_sounds/fail1.mp3',
    '$_root/fail_sounds/fail2.mp3',
    '$_root/fail_sounds/fail3.mp3',
    '$_root/fail_sounds/fail4.mp3',
    '$_root/fail_sounds/fail5.mp3',
    '$_root/fail_sounds/fail6.mp3',
    '$_root/fail_sounds/fail7.mp3',
  ];

  static const List<String> loadingSounds = [
    '$_loadingSounds/begin1.mp3',
    '$_loadingSounds/begin2.mp3',
    '$_loadingSounds/begin3.mp3',
    '$_loadingSounds/begin4.mp3',
    '$_loadingSounds/begin5.mp3',
  ];

  static const List<String> ggSounds = [
    '$_ggSounds/gg1.mpeg',
    '$_ggSounds/gg2.mpeg',
    '$_ggSounds/gg3.mpeg',
    '$_ggSounds/gg4.mpeg',
  ];

  
  //  Spell Sounds  //

  static const coldSnapSounds = [
    '$_spellSounds/cold_snap1.mp3',
    '$_spellSounds/cold_snap2.mp3',
    '$_spellSounds/cold_snap3.mp3',
  ];

  static const ghostWalkSounds = [
    '$_spellSounds/ghost_walk1.mp3',
    '$_spellSounds/ghost_walk2.mp3',
    '$_spellSounds/ghost_walk3.mp3',
  ];

  static const iceWallSounds = [
    '$_spellSounds/icewall1.mp3',
    '$_spellSounds/icewall2.mp3',
  ];

  static const empSounds = [
    '$_spellSounds/emp1.mp3',
    '$_spellSounds/emp2.mp3',
    '$_spellSounds/emp3.mp3',
  ];

  static const tornadoSounds = [
    '$_spellSounds/tornado1.mp3',
    '$_spellSounds/tornado2.mp3',
    '$_spellSounds/tornado3.mp3',
  ];

  static const alacritySounds = [
    '$_spellSounds/alacrity1.mp3',
    '$_spellSounds/alacrity2.mp3',
  ];

  static const deafeningBlastSounds = [
    '$_spellSounds/blast1.mp3',
    '$_spellSounds/blast2.mp3',
    '$_spellSounds/blast3.mp3',
  ];

  static const sunStrikeSounds = [
    '$_spellSounds/sunstrike1.mp3',
    '$_spellSounds/sunstrike2.mp3',
    '$_spellSounds/sunstrike3.mp3',
  ];

  static const forgeSpiritSounds = [
    '$_spellSounds/forge_spirit1.mp3',
    '$_spellSounds/forge_spirit2.mp3',
  ];

  static const chaosMeteorSounds = [
    '$_spellSounds/meteor1.mp3',
    '$_spellSounds/meteor2.mp3',
  ];

}
