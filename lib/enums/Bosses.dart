import '../constants/app_image_paths.dart';
import '../extensions/string_extension.dart';

enum Bosses {
  warlock(16000),
  omniknight(20000),
  riki(25000),
  huskar(32000),
  templar(40000),
  anti_mage(50000),
  juggernaut(60000),
  blood_seeker(72000),
  drow_ranger(84000),
  axe(100000),
  pudge(110000),
  wraith_king(120000);

  const Bosses(this._health);

  final double _health;
}

extension BossExtension on Bosses {
  double get getHp => _health;
  String get getImage => '${ImagePaths.bosses}boss_$name.png';
  /// anti_mage to Anti Mage
  String get getReadableName => this.name.toSpacedTitle();
  /// anti_mage to Anti_Mage
  String get getDbName => this.name.toSnakeTitle();
}
