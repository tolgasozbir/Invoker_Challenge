import '../constants/app_strings.dart';
import '../extensions/string_extension.dart';

enum Bosses {
  warlock(16000),
  omniknight(20000),
  riki(25000),
  huskar(32000),
  templar(40000),
  anti_mage(48000),
  juggernaut(56000),
  blood_seeker(64000),
  drow_ranger(72000),
  axe(80000),
  pudge(90000),
  wraith_king(100000);

  const Bosses(this._health);

  final double _health;
}

extension bossExtension on Bosses {
  double get getHp => _health;
  String get getImage => '${ImagePaths.bosses}boss_$name.png';
  String get getName => name.replaceAll("_", " ").capitalize();
}