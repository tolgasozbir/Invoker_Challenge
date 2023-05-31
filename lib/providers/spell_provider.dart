import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../enums/spells.dart';

class SpellProvider extends ChangeNotifier {

  Spell _nextSpell = Spell.values.first;
  Spell get nextSpell => _nextSpell;

  final List<Spell> _tempSpells = [];
  final _rng  = math.Random();

  void getRandomSpell() {
    var rndSpell = Spell.values[_rng.nextInt(Spell.values.length)];

    do {
      rndSpell = Spell.values[_rng.nextInt(Spell.values.length)];
    } 
    while (_tempSpells.contains(rndSpell));

    _tempSpells.insert(0, rndSpell);
    if (_tempSpells.length > 3) _tempSpells.removeLast();
 
    _nextSpell = rndSpell;
    notifyListeners();
    log('Next Combination : ${_nextSpell.combination}');
  }

  //Combo
  final int _comboSpellNum = 3;
  int get comboSpellNum => _comboSpellNum;

  final List<Spell> _comboTempSpells = [];
  final List<Spell> _comboSpells = [];
  List<bool> correctSpells = [];
  List<Spell> get comboSpells => _comboSpells;

  void getRandomComboSpells() {
    _comboSpells.clear();
    correctSpells = List.generate(comboSpellNum, (index) => false);
    for (var i = 0; i < comboSpellNum; i++) {
      var rndSpell = Spell.values[_rng.nextInt(Spell.values.length)];

      do {
        rndSpell = Spell.values[_rng.nextInt(Spell.values.length)];
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
