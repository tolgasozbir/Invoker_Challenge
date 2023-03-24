import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:snappable_thanos/snappable_thanos.dart';

import 'package:dota2_invoker_game/enums/Bosses.dart';
import 'package:dota2_invoker_game/enums/spells.dart';

import '../models/ability_cooldown.dart';
import '../services/sound_manager.dart';
import 'user_manager.dart';

class BossProvider extends ChangeNotifier {
  Timer? _timer;
  final rng = math.Random();
  bool started = false;

  //Circle Values
  int get roundUnit => Bosses.values.length;
  int get healthUnit => 60;
  int get timeUnits => 180;
  int roundProgress = -1;
  double healthProgress = 0;
  double timeProgress = 0;

  double dps = 0;

  bool currentBossAlive = false;
  double currentBossHp = 0;
  final bossList = Bosses.values;
  var currentBoss = Bosses.values.first;

  //Mana Bar

  final double totalMana = 200 + UserManager.instance.user.level * 67;
  double currentMana = 200 + UserManager.instance.user.level * 67;
  final double baseManaRegen = UserManager.instance.user.level * 0.27;
  double get manaBarWidthMultiplier => ((currentMana / totalMana) * 100) / 100;

  void manaRegenFn() {
    if (currentMana < totalMana) {
      currentMana += baseManaRegen;
      if (currentMana > totalMana) {
        currentMana = totalMana;
      }
    }
  }

  updateCurrentMana(double val) {
    currentMana -= val;
  }

  //

  //
  final snappableKey = GlobalKey<SnappableState>();
  bool snapIsDone = true;
  void changeSnapStatus () {
    snapIsDone = !snapIsDone;
    notifyListeners();
  }

  Future<void> snapBoss() async {
    changeSnapStatus();
    await snappableKey.currentState?.snap();
    await Future.delayed(Duration(milliseconds: 3000));
    changeSnapStatus();
  }

  double get baseDamage => UserManager.instance.user.level * 5 + rng.nextDouble() * 10;
  double spellDamage = 0;

  List<AbilityCooldown> _castedAbility = [];
  List<AbilityCooldown> get castedAbility => _castedAbility;

  void switchAbility(AbilityCooldown abilityCooldown) {
    if (_castedAbility.length > 1 && abilityCooldown.spell.combine == _castedAbility.first.spell.combine) return;
    _castedAbility.insert(0, abilityCooldown);
    while (_castedAbility.length > 2) {
      _castedAbility.removeLast();
    }
    notifyListeners();
  }

  
  void autoHit(){
    var health = currentBoss.getHp / healthUnit;
    var totalDamge = baseDamage/health;
    healthProgress += totalDamge;
    dps += baseDamage;
    currentBossHp = currentBoss.getHp - (healthProgress * health);
    print(currentBoss.name + " Hp : " + (currentBoss.getHp - (healthProgress * health)).toStringAsFixed(0));
  }

  void hitWithSpell(double damage) {
    var health = currentBoss.getHp / healthUnit;
    var totalDamge = damage/health;
    healthProgress += totalDamge;
    dps += damage;
    currentBossHp = currentBoss.getHp - (healthProgress * health);
    notifyListeners();
  }

  void _increaseTime() {
    timeProgress++;
  }

  void nextRound() {
    started = true;
    currentBossAlive = true;
    snappableKey.currentState?.reset();
    roundProgress++;
    currentBoss = bossList[roundProgress];
    currentBossHp = currentBoss.getHp;
    healthProgress = 0;
    timeProgress = 0;
    currentMana = totalMana;
    notifyListeners();
  }

  void checkTimeOrHp() async {
    if (healthProgress >= healthUnit) {
      log("Boss down");
      _timer?.cancel();
      _timer = null;
      started = false;
      currentBossHp = 0; // eksi değer göstermemesi için
      dps = 0;
      await Future.delayed(Duration(milliseconds: 100)); //snap işleminde 100 ms sonrasını baz almak için
      await snapBoss();
      currentBossAlive = false;
      notifyListeners();
      return;
    }

    if (timeProgress >= timeUnits) {
      log("Time out");
      _timer?.cancel();
      started = false;
      return;
    }

  }

  void startGame() {
    nextRound();
    if (_timer != null) return;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      dps = 0;
      _increaseTime();
      autoHit();
      hitWithSpell(spellDamage);
      checkTimeOrHp();
      manaRegenFn();
      //if (!started) timer.cancel();
      notifyListeners();
    });
  }

  void updateView() {
    notifyListeners();
  }

  void _reset() {
    started = false;
    roundProgress = -1;
    healthProgress = 0;
    timeProgress = 0;
    _castedAbility.clear();
    dps = 0;
    snapIsDone = true;
    currentBossAlive = false;
    currentBoss = Bosses.values.first;
  }

  void disposeTimer() {
    _reset();
    if (_timer == null) return;
    _timer?.cancel();
    _timer = null;
  }

  List<AbilityCooldown> SpellCooldowns = Spells.values.map((e) => AbilityCooldown(spell: e)).toList();
  void onPressedAbility(Spells spell) async {
    if (!started) {
      SoundManager.instance.playMeepMerp();
      return;
    }
    var index = Spells.values.indexOf(spell);
    var spellUsed = SpellCooldowns[index].onPressedAbility(currentMana);
    if (spellUsed) {
      updateCurrentMana(spell.mana);
      if (spell.duration == 0) {
        spellDamage += spell.damage;
        await Future.delayed(Duration(seconds: 1), () => spellDamage -= spell.damage );
      }
      else {
        spellDamage += spell.damage;
        await Future.delayed(Duration(seconds: spell.duration), () => spellDamage -= spell.damage );
      }
    }
  }

}