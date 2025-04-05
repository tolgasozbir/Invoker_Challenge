/// Provides sound asset paths.
class AppSoundPaths {
  const AppSoundPaths._();

  /// Generates a list of sound file paths.
  /// Constructs file paths sequentially by appending numbers to the file name.
  ///
  /// [basePath] - The directory path where the sound files are located.
  /// [fileName] - The base name of the sound files.
  /// [fileCount] - The number of files to generate.
  /// [extension] - The file extension (default is 'mp3').
  ///
  /// Example:
  /// ```dart
  /// List<String> soundPaths = _createSoundList('assets/sounds', 'sound', 3);
  /// print(soundPaths);
  /// // Output: ['assets/sounds/sound1.mp3', 'assets/sounds/sound2.mp3', 'assets/sounds/sound3.mp3']
  /// ```
  static List<String> _createSoundList(String basePath, String fileName, int fileCount, {String extension = 'mp3'}) {
    return List<String>.generate(
      fileCount,
      (index) => '$basePath/$fileName${index + 1}.$extension',
    );
  }

  // Root directory
  static const String _base = 'assets/sounds';
  // Subdirectories
  static const String _cooldown = '$_base/ability_cooldown';
  static const String _failCast = '$_base/fail_cast';
  static const String _gameOver = '$_base/game_over';
  static const String _noMana   = '$_base/insufficient_mana';
  static const String _loading  = '$_base/loading';
  static const String _shop     = '$_base/shop';
  static const String _misc     = '$_base/misc';
  static const String _spell    = '$_base/spell';
  static const String spellCast = '$_spell/cast';
  static const String boss      = '$_base/boss';
  static const String item      = '$_base/item';

  // -- Invoker Sounds (default/persona) --
  static final List<String> abilityCooldownDefault = _createSoundList('$_cooldown/default', 'not_ready', 9);
  static final List<String> abilityCooldownPersona = _createSoundList('$_cooldown/persona', 'not_ready', 9);

  static final List<String> failCastDefault = _createSoundList('$_failCast/default', 'fail', 7);
  static final List<String> failCastPersona = _createSoundList('$_failCast/persona', 'fail', 5);

  static final List<String> gameOverDefault = _createSoundList('$_gameOver/default', 'game_over', 4);
  static final List<String> gameOverPersona = _createSoundList('$_gameOver/persona', 'game_over', 4);  

  static final List<String> noManaDefault = _createSoundList('$_noMana/default', 'no_mana', 9);
  static final List<String> noManaPersona = _createSoundList('$_noMana/persona', 'no_mana', 9);

  static final List<String> loadingDefault = _createSoundList('$_loading/persona', 'loading', 5);
  static final List<String> loadingPersona = _createSoundList('$_loading/persona', 'loading', 5);

  // -- Shop Sounds --
  static const String itemBuy  = '$_shop/item_buy.mp3';
  static const String itemSell = '$_shop/item_sell.mp3';
  static final List<String> shopEnter = _createSoundList(_shop, 'welcome', 6);
  static final List<String> shopExit  = _createSoundList(_shop, 'leave', 5);

  // -- Misc Sounds --
  static const String meepMerp = '$_misc/meep_merp.mp3';
  static const String invoke   = '$_misc/invoke.mp3';
  static const List<String> horns = [
    '$_misc/horn_dire.mp3',
    '$_misc/horn_radiant.mp3',
  ];
  static final List<String> personaSelect = _createSoundList(_misc, 'persona_select', 3);

  // -- Invoker Spell Sounds (default/persona) --
  static final coldSnap         = _createSoundList(_spell, 'cold_snap', 3);
  static final coldSnapPersona  = _createSoundList(_spell, 'cold_snap_persona', 3);

  static final ghostWalk        = _createSoundList(_spell, 'ghost_walk', 3);
  static final ghostWalkPersona = _createSoundList(_spell, 'ghost_walk_persona', 2);
  
  static final iceWall          = _createSoundList(_spell, 'icewall', 2);
  static final iceWallPersona   = _createSoundList(_spell, 'icewall_persona', 2);

  static final emp              = _createSoundList(_spell, 'emp', 3);
  static final empPersona       = _createSoundList(_spell, 'emp_persona', 3);

  static final tornado          = _createSoundList(_spell, 'tornado', 3);
  static final tornadoPersona   = _createSoundList(_spell, 'tornado_persona', 3);

  static final alacrity         = _createSoundList(_spell, 'alacrity', 2);
  static final alacrityPersona  = _createSoundList(_spell, 'alacrity_persona', 2);

  static final deafeningBlast         = _createSoundList(_spell, 'blast', 3);
  static final deafeningBlastPersona  = _createSoundList(_spell, 'blast_persona', 3);

  static final sunStrike          = _createSoundList(_spell, 'sun_strike', 3);
  static final sunStrikePersona   = _createSoundList(_spell, 'sun_strike_persona', 3);

  static final forgeSpirit        = _createSoundList(_spell, 'forge_spirit', 2);
  static final forgeSpiritPersona = _createSoundList(_spell, 'forge_spirit_persona', 2);

  static final chaosMeteor        = _createSoundList(_spell, 'meteor', 2);
  static final chaosMeteorPersona = _createSoundList(_spell, 'meteor_persona', 3);
  
}
