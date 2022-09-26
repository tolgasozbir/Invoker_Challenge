import 'dart:async';

import 'package:flutter/material.dart';

class TimerProvider extends ChangeNotifier {

  Timer? _timer;

  int _time=0;
  int time60=60;

  int get getTimeValue=> _time;

  void setTimerValue(int value){
    _time = value;
    notifyListeners();
  }

  int getTime60Value(){
    return time60;
  }

  double calculateCps(int totalTabs){
    return totalTabs/_time;
  }

  double calculateScps(int totalCast){
    return totalCast/_time;
  }

  void timeIncrease(){
    _time++;
    notifyListeners();
  }

  void timeDecrease(){
    time60--;
    notifyListeners();
  }

  void startTimer(){
    _timer=Timer.periodic(Duration(seconds: 1), (timer) { 
        timeIncrease();
    });
  }

  void disposeTimer(){
    _time = 0;
    if (_timer!=null) {
      _timer!.cancel();
    }
    notifyListeners();
  }

}