import '../constants/app_strings.dart';

enum Spells {
  cold_snap,
  ghost_walk,
  ice_wall,
  emp,
  tornado,
  alacrity,
  deafening_blast,
  sun_strike,
  forge_spirit,
  chaos_meteor,
}

extension spellsExtension on Spells {
  String get getImage => '${ImagePaths.spells}${this.name}.png';

  // List<String> spellCombination(Spells spell) {
  //   switch (spell) {
  //     case Spells.cold_snap: return ["q","q","q"];
  //     case Spells.ghost_walk: return ["q","q","w"];
  //     case Spells.ice_wall: return ["q","q","e"];
  //     case Spells.emp: return ["w","w","w"];
  //     case Spells.tornado: return ["w","w","q"];
  //     case Spells.alacrity: return ["w","w","e"];
  //     case Spells.deafening_blast: return ["q","w","e"];
  //     case Spells.sun_strike: return ["e","e","e"];
  //     case Spells.forge_spirit: return ["e","e","q"];
  //     case Spells.chaos_meteor: return ["e","e","w"];
  //   }
  // }
}