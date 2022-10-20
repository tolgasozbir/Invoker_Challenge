import 'dart:math';
import '../enums/spells.dart';
import 'package:flutter/material.dart';
import '../constants/app_strings.dart';
import '../models/spell.dart';

class SpellProvider extends ChangeNotifier {

  String _spellImage = ImagePaths.spellImage;
  List<String> _trueCombination = [];

  String get getNextSpellImage => _spellImage;
  List<String> get getNextCombination => _trueCombination;

  List<Spell> _spellList = [
    Spell(Spells.cold_snap.getImage,        ["q","q","q"]),
    Spell(Spells.ghost_walk.getImage,       ["q","q","w"]),
    Spell(Spells.ice_wall.getImage,         ["q","q","e"]),
    Spell(Spells.emp.getImage,              ["w","w","w"]),
    Spell(Spells.tornado.getImage,          ["w","w","q"]),
    Spell(Spells.alacrity.getImage,         ["w","w","e"]),
    Spell(Spells.deafening_blast.getImage,  ["q","w","e"]),
    Spell(Spells.sun_strike.getImage,       ["e","e","e"]),
    Spell(Spells.forge_spirit.getImage,     ["e","e","q"]),
    Spell(Spells.chaos_meteor.getImage,     ["e","e","w"]),
  ];

  Spell _tempSpell = Spell(
    Spells.alacrity.getImage,
    ["w","w","e"],
  );
  
  Random _rnd = Random();

  void getRandomSpell() {
    Spell rndSpell = _spellList[_rnd.nextInt(_spellList.length)];
    do {
      rndSpell = _spellList[_rnd.nextInt(_spellList.length)];
    } while (_tempSpell == rndSpell);

    _tempSpell = rndSpell;
    _spellImage = rndSpell.image;
    _trueCombination = rndSpell.combine;
    notifyListeners();
    print('Next Combination : $_trueCombination');
  }

  //List<String> get getAllSpellImagePaths => _spellList.map((e) => e.image).toList();
  List<Spell> get gelSpellList => _spellList;
}