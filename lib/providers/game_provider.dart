import 'dart:async';

import '../services/database/IDatabaseService.dart';
import 'package:flutter/material.dart';

import '../enums/database_table.dart';

typedef ResultDialogVoidFunc = void Function(DatabaseTable);

class GameProvider extends ChangeNotifier {

  late IDatabaseService _databaseService;

  GameProvider({required IDatabaseService databaseService, required}) {
    this._databaseService = databaseService;
  }

  IDatabaseService get databaseService => this._databaseService;


  Timer? _timer;

  bool _isStart = false;
  int _timerValue = 0;
  int _countdownValue = 60;
  int _totalTabs = 0;
  int _totalCast = 0;
  int _correctCombinationCount = 0;

  bool get isStart => _isStart;
  int get getTimeValue => _timerValue;
  int get getCountdownValue => _countdownValue;
  int get getTotalTabs => _totalTabs;
  int get getTotalCast => _totalCast;
  int get getCorrectCombinationCount => _correctCombinationCount;

  double get calculateCps => _totalTabs/_timerValue;
  double get calculateScps => _totalCast/_timerValue;

  void changeIsStartStatus(){
    _isStart = !_isStart;
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
  
  void _increaseTimer(){
    _timerValue++;
    notifyListeners();
  }

  void _decreaseCountdownValue(){
    _countdownValue--;  
    notifyListeners();
  }

  void startTimer(){
    changeIsStartStatus();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) { 
      _increaseTimer();
    });
  }

  void startCoundown(ResultDialogVoidFunc showDialog){
    changeIsStartStatus();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) { 
      _decreaseCountdownValue();
      if (_countdownValue <= 0) {
        disposeTimer();
        changeIsStartStatus();
        showDialog.call(DatabaseTable.timer);
      }
    });
  }

  void resetTimer(){
    _isStart = false;
    _timerValue = 0;
    _countdownValue = 60;
    _totalTabs = 0;
    _totalCast = 0;
    _correctCombinationCount = 0;
    disposeTimer();
    notifyListeners();
  }

  void disposeTimer(){
    if (_timer!=null) {
      _timer!.cancel();
    }
  }

}