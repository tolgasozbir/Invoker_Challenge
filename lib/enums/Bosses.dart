import '../extensions/string_extension.dart';
import '../constants/app_strings.dart';

enum Bosses {
  warlock(12000),
  omniknight(16000),
  riki(22000),
  huskar(30000),
  templar(40000),
  anti_mage(50000);

  const Bosses(this._health);

  final double _health;
}

extension bossExtension on Bosses {
  double get getHp => _health;
  String get getImage => '${ImagePaths.bosses}boss_$name.png';
  String get getName => name.replaceAll("_", " ").capitalize();
}