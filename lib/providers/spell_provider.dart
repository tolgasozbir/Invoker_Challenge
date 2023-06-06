import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../enums/spells.dart';

class SpellProvider extends ChangeNotifier {
  final List<Spell> _tempSpells = [];
  List<Spell> _comboTempSpells = [];

  final _rng = math.Random();

  // Single Spell Fields
  Spell _nextSpell = Spell.values.first;
  Spell get nextSpell => _nextSpell;

  // Combo Multi Spell Fields
  final int _comboSpellNum = 3;
  int get comboSpellNum => _comboSpellNum;

  final List<Spell> _comboSpells = [];
  List<Spell> get comboSpells => _comboSpells;

  List<bool> correctSpells = [];

  ///Returns a random spell
  void getRandomSpell() {

    Spell rndSpell;
    do {
      rndSpell = _generateRandomSpell();
    } while (_tempSpells.contains(rndSpell));

    _tempSpells.insert(0, rndSpell);
    if (_tempSpells.length > 3) _tempSpells.removeLast();

    _nextSpell = rndSpell;
    notifyListeners();
    log('Next Combination: ${_nextSpell.combination}');
  }

  ///Returns [comboSpellNum] number of spells
  void getRandomComboSpells() {
    _comboSpells.clear();
    correctSpells = List.generate(comboSpellNum, (index) => false);

    for (var i = 0; i < comboSpellNum; i++) {
      Spell rndSpell;
      do {
        rndSpell = _generateRandomSpell();
      } while (_comboTempSpells.contains(rndSpell) || _comboSpells.contains(rndSpell));

      _comboSpells.add(rndSpell);
    }

    _comboTempSpells = List.from(_comboSpells);
    notifyListeners();
  }

  Spell _generateRandomSpell() {
    return Spell.values[_rng.nextInt(Spell.values.length)];
  }

  void updateView() {
    notifyListeners();
  }

}
