import '../constants/app_strings.dart';
import '../extensions/string_extension.dart';

enum Bosses {
  warlock(12000),
  omniknight(16000),
  riki(20000),
  huskar(24000),
  templar(30000),
  anti_mage(36000),
  juggernaut(42000),
  blood_seeker(48000),
  drow_ranger(54000);

  const Bosses(this._health);

  final double _health;
}

extension bossExtension on Bosses {
  double get getHp => _health;
  String get getImage => '${ImagePaths.bosses}boss_$name.png';
  String get getName => name.replaceAll("_", " ").capitalize();
}