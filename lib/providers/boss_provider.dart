import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:dota2_invoker_game/enums/Bosses.dart';
import 'package:flutter/material.dart';
import 'package:snappable_thanos/snappable_thanos.dart';

import '../models/spell.dart';
import 'user_manager.dart';

class BossProvider extends ChangeNotifier {
  Timer? _timer;
  final rng = math.Random();
  bool started = false;

  //Circle Values
  int get roundUnit => Bosses.values.length;//12;
  int get healthUnit => 60;
  int get timeUnits => 180;
  int roundProgress = -1;
  double healthProgress = 0;
  double timeProgress = 0;

  bool currentBossAlive = false;
  double currentBossHp = 0;
  final bossList = Bosses.values;
  var currentBoss = Bosses.values.first;
  final snappableKey = GlobalKey<SnappableState>();

  bool snapIsDone = true;
  void changeSnapIsDoneStatus () {
    snapIsDone = !snapIsDone;
    ChangeNotifier();
  }

  Future<void> snapBoss() async {
    changeSnapIsDoneStatus();
    await snappableKey.currentState?.snap();
    await Future.delayed(Duration(milliseconds: 3000));
    changeSnapIsDoneStatus();
  }


  double get baseDamage => UserManager.instance.user.level * 5;

  List<Spell> _castedAbility = [];
  List<Spell> get castedAbility => _castedAbility;

  void switchAbility(Spell spell) {
    if (_castedAbility.length > 1 && spell.combine.toString() == _castedAbility.first.combine.toString()) return;
    _castedAbility.insert(0, spell);
    while (_castedAbility.length > 2) {
      _castedAbility.removeLast();
    }
    notifyListeners();
  }

  AnimationController? _dpsController;
  double dps = 0;
  void setDpsController(AnimationController controller) {
    _dpsController = controller;
  }

  void autoHit(){
    _dpsController!.reset();
    var damage = baseDamage + rng.nextInt(10) +3000;
    var health = currentBoss.getHp / healthUnit;
    var totalDamge = damage/health;
    healthProgress += totalDamge;
    _dpsController!.repeat(reverse: true);
    dps = damage;
    currentBossHp = currentBoss.getHp - (healthProgress * health);
    print(currentBoss.name + " Hp : " + (currentBoss.getHp - (healthProgress * health)).toStringAsFixed(0));
  }

  void hit() {
    autoHit();
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
    healthProgress = 0;
    timeProgress = 0;
    dps = 0;
    notifyListeners();
  }

  void checkTimeOrHp() async {
    if (healthProgress >= healthUnit) {
      log("Boss down");
      _timer?.cancel();
      _timer = null;
      started = false;
      _dpsController!.stop();
      _dpsController!.reset();
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
      _increaseTime();
      hit();
      checkTimeOrHp();
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
    currentBossAlive = false;
    currentBoss = Bosses.values.first;
  }

  void disposeTimer() {
    _reset();
    if (_timer == null) return;
    _timer?.cancel();
    _timer = null;
  }

}