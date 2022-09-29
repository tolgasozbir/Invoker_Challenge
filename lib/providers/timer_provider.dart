import 'dart:async';
import 'package:flutter/material.dart';

class TimerProvider extends ChangeNotifier {

  Timer? _timer;

  int _timerValue = 0;
  int _countdownValue = 60;
  int _totalTabs = 0;
  int _totalCast = 0;
  int _correctCombinationCount = 0;

  int get getTimeValue=> _timerValue;
  int get getCountdownValue => _countdownValue;
  int get getTotalTabs => _totalTabs;
  int get getTotalCast => _totalCast;
  int get getCorrectCombinationCount => _correctCombinationCount;

  double get calculateCps => _totalTabs/_timerValue;
  double get calculateScps => _totalCast/_timerValue;

  void setTimerValue(int value){
    _timerValue = value;
    notifyListeners();
  }

  void increaseTotalTabs(){
    _totalTabs++;
    notifyListeners();
  }  

  void increaseTotalCast(){
    _totalCast++;
    notifyListeners();
  }

  void increaseCorrectCounter(){
    _correctCombinationCount++;
    notifyListeners();
  }  
  
  void resetCountdownValue(){ // no need
    _countdownValue = 60;
    notifyListeners();
  }

  void _increaseTimer(){
    _timerValue++;
    notifyListeners();
  }

  // void decreaseCountdownValue(){  //TODO
  //   _countdownValue--;  
  //   notifyListeners();
  // }

  void startTimer(){
    _timer=Timer.periodic(Duration(seconds: 1), (timer) { 
      _increaseTimer();
    });
  }

  void resetTimer(){
    _timerValue = 0;
    _countdownValue = 60;
    _totalTabs = 0;
    _totalCast = 0;
    _correctCombinationCount = 0;
    _disposeTimer();
    notifyListeners();
  }

  void _disposeTimer(){
    if (_timer!=null) {
      _timer!.cancel();
    }
  }

}