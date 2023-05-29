import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../enums/spells.dart';

class SpellProvider extends ChangeNotifier {

  String _spellImage = ImagePaths.spellImage;
  String _trueCombination = '';

  String get getNextSpellImage => _spellImage;
  String get getNextCombination => _trueCombination;

  final List<Spells> _tempSpells = [];
  final _rng  = math.Random();

  void getRandomSpell() {
    var rndSpell = Spells.values[_rng.nextInt(Spells.values.length)];

    do {
      rndSpell = Spells.values[_rng.nextInt(Spells.values.length)];
    } 
    while (_tempSpells.contains(rndSpell));

    _tempSpells.insert(0, rndSpell);
    if (_tempSpells.length > 3) _tempSpells.removeLast();
 
    _spellImage = rndSpell.image;
    _trueCombination = rndSpell.combine;
    notifyListeners();
    log('Next Combination : $_trueCombination');
  }

  //Combo
  final int _comboSpellNum = 3;
  int get comboSpellNum => _comboSpellNum;

  final List<Spells> _comboTempSpells = [];
  final List<Spells> _comboSpells = [];
  List<bool> correctSpells = [];
  List<Spells> get comboSpells => _comboSpells;

  void getRandomComboSpells() {
    _comboSpells.clear();
    correctSpells = List.generate(comboSpellNum, (index) => false);
    for (var i = 0; i < comboSpellNum; i++) {
      var rndSpell = Spells.values[_rng.nextInt(Spells.values.length)];

      do {
        rndSpell = Spells.values[_rng.nextInt(Spells.values.length)];
      } 
      while (_comboTempSpells.contains(rndSpell) || _comboSpells.contains(rndSpell));

      _comboSpells.add(rndSpell);
    }

    _comboTempSpells.clear();
    _comboTempSpells.addAll(_comboSpells);

    notifyListeners();
  }

  void updateView() {
    notifyListeners();
  }

}
