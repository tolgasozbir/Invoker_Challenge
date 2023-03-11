import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/spell.dart';
import 'user_manager.dart';

class BossProvider extends ChangeNotifier {
  Timer? _timer;
  final rng = math.Random();
  bool started = false;

  //Circle Values
  int get roundUnit => 12;
  int get healthUnit => 60;
  int get timeUnits => 180;
  double roundProgress = 0;
  double healthProgress = 0;
  double timeProgress = 0;

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
    var damage = baseDamage + rng.nextInt(10);
    var health = (1000 * roundProgress) / healthUnit;
    var totalDamge = damage/health;
    healthProgress += totalDamge;
    _dpsController!.repeat(reverse: true);
    dps = damage;
  }

  void hit() {
    autoHit();
  }

  void _increaseTime() {
    timeProgress++;
  }

  void nextRound() {
    started = true;
    roundProgress++;
    healthProgress = 0;
    timeProgress = 0;
    dps = 0;
    notifyListeners();
  }

  void checkTimeOrHp() {
    if (healthProgress >= healthUnit) {
      log("Boss down");
      _timer?.cancel();
      _timer = null;
      started = false;
      _dpsController!.stop();
      _dpsController!.reset();
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
      print("Tick");
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
    roundProgress = 0;
    healthProgress = 0;
    timeProgress = 0;
    _castedAbility.clear();
  }

  void disposeTimer() {
    _reset();
    if (_timer == null) return;
    _timer?.cancel();
    _timer = null;
  }

}