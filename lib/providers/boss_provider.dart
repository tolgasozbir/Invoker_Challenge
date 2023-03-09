import 'dart:async';
import 'user_manager.dart';
import 'package:flutter/material.dart';

import '../models/spell.dart';

class BossProvider extends ChangeNotifier {
  bool started = false;
  Timer? _timer;

  double roundProgress = 0;
  double healthProgress = 0;
  double timeProgress = 0;

  int get roundUnit => 12;
  int get healthUnit => 60;
  int get timeUnits => 180;

  double baseDamage = UserManager.instance.user.level * 5;

  List<Spell> castedAbility = [];

  void switchAbility(Spell spell) {
    if (castedAbility.length > 1 && spell.combine.toString() == castedAbility.first.combine.toString()) return;
    castedAbility.insert(0, spell);
    while (castedAbility.length > 2) {
      castedAbility.removeLast();
    }
    notifyListeners();
  }


  void autoHit(){
    var damage = baseDamage;
    var health = (1000 * roundProgress) / healthUnit;
    var totalDamge = damage/health;
    healthProgress += totalDamge;
  }

  //
  void hit(double damage) {
    healthProgress += damage;
  }

  void _increaseTime() {
    timeProgress++;
  }

  void nextRound() {
    roundProgress++;
    healthProgress = 0;
    timeProgress = 0;
    //started = false;
    notifyListeners();
  }

  void checkTimeOrHp() {
    if (healthProgress == healthUnit) {
      print("Boss down");
      _timer?.cancel();
      _timer = null;
      return;
    }

    if (timeProgress == timeUnits) {
      print("Time out");
      _timer?.cancel();
      return;
    }

  }

  void startGame() {
    nextRound();
    if (_timer != null) return;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      print("Tick");
      _increaseTime();
      autoHit();
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
    castedAbility = [];
  }

  void disposeTimer() {
    _reset();
    if (_timer == null) return;
    _timer?.cancel();
    _timer = null;
  }

}