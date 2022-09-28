import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/app_strings.dart';
import '../models/spell.dart';

class SpellProvider extends ChangeNotifier {

  String _spellImage = ImagePaths.spellImage;
  List<String> _trueCombination = [];

  String get getNextSpellImage => _spellImage;
  List<String> get getNextCombination => _trueCombination;

  List<Spell> _spellList = [
    Spell("images/spells/invoker_cold_snap.png",        ["q","q","q"]),
    Spell("images/spells/invoker_ghost_walk.png",       ["q","q","w"]),
    Spell("images/spells/invoker_ice_wall.png",         ["q","q","e"]),
    Spell("images/spells/invoker_emp.png",              ["w","w","w"]),
    Spell("images/spells/invoker_tornado.png",          ["w","w","q"]),
    Spell("images/spells/invoker_alacrity.png",         ["w","w","e"]),
    Spell("images/spells/invoker_deafening_blast.png",  ["q","w","e"]),
    Spell("images/spells/invoker_sun_strike.png",       ["e","e","e"]),
    Spell("images/spells/invoker_forge_spirit.png",     ["e","e","q"]),
    Spell("images/spells/invoker_chaos_meteor.png",     ["e","e","w"]),
  ];

  Spell _tempSpell = Spell("images/spells/invoker_alacrity.png",["w","w","e"]);
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

  List<String> get getAllSpellImagePaths => _spellList.map((e) => e.image).toList();
}