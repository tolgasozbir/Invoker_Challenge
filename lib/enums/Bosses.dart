import '../constants/app_image_paths.dart';
import '../extensions/string_extension.dart';

enum Bosses {
  warlock       (health: 16000,  entryLineCount: 3, deathLineCount: 3, tauntLineCount: 3),
  omniknight    (health: 20000,  entryLineCount: 3, deathLineCount: 3, tauntLineCount: 2),
  riki          (health: 25000,  entryLineCount: 3, deathLineCount: 3, tauntLineCount: 2),
  huskar        (health: 32000,  entryLineCount: 2, deathLineCount: 2, tauntLineCount: 1),
  templar       (health: 40000,  entryLineCount: 2, deathLineCount: 1, tauntLineCount: 2),
  anti_mage     (health: 50000,  entryLineCount: 1, deathLineCount: 3, tauntLineCount: 4),
  juggernaut    (health: 60000,  entryLineCount: 2, deathLineCount: 2, tauntLineCount: 2),
  blood_seeker  (health: 72000,  entryLineCount: 2, deathLineCount: 2, tauntLineCount: 2),
  drow_ranger   (health: 84000,  entryLineCount: 1, deathLineCount: 2, tauntLineCount: 3),
  axe           (health: 100000, entryLineCount: 3, deathLineCount: 3, tauntLineCount: 3),
  pudge         (health: 110000, entryLineCount: 4, deathLineCount: 2, tauntLineCount: 4),
  wraith_king   (health: 120000, entryLineCount: 4, deathLineCount: 6, tauntLineCount: 4);

  const Bosses({required this.health, required this.entryLineCount,  required this.deathLineCount,  required this.tauntLineCount});

  /// The boss's total health points.
  final double health;

  /// Number of voice lines the boss says when entryLineCount the stage.
  final int entryLineCount;

  /// Number of voice lines the boss says when deathLineCount.
  final int deathLineCount;

  /// Number of tauntLineCount lines (mocking/reaction quotes) the boss can use during the battle.
  final int tauntLineCount;
}

extension BossExtension on Bosses {
  String get getImage => '${ImagePaths.bosses}boss_$name.png';
  /// anti_mage to Anti Mage
  String get getReadableName => this.name.toSpacedTitle();
  /// anti_mage to Anti_Mage
  String get getDbName => this.name.toSnakeTitle();
}
