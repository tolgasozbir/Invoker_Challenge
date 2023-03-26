import '../constants/app_strings.dart';

enum Items {
  Void_stone(Description: "+2 Mana per second.", cooldown: 0),
  Kaya(Description: "+8% Increased Ability Damage", cooldown: 0);

  const Items({required this.Description, required this.cooldown});

  final String Description;
  final double cooldown;
}

extension ItemExtension on Items {
  String get image => ImagePaths.items+name+'_icon.png';
}