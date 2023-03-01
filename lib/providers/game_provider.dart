import 'dart:async';

import 'package:flutter/material.dart';

import '../enums/database_table.dart';

typedef ResultDialogVoidFunc = void Function(DatabaseTable);

class GameProvider extends ChangeNotifier {
  Timer? _timer;

  bool _isStart = false;
  bool _spellHeplerIsOpen = false;
  int _timerValue = 0;
  int _countdownValue = 60;
  int _correctCombinationCount = 0;

  bool get isStart => _isStart;
  bool get spellHelperIsOpen => _spellHeplerIsOpen;
  int get getTimeValue => _timerValue;
  int get getCountdownValue => _countdownValue;
  int get getCorrectCombinationCount => _correctCombinationCount;

  void changeIsStartStatus(){
    _isStart = !_isStart;
    notifyListeners();
  }

  void showCloseHelperWidget() {
    _spellHeplerIsOpen = !_spellHeplerIsOpen;
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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) { 
      _increaseTimer();
    });
  }

  void startCoundown(ResultDialogVoidFunc showDialog){
    changeIsStartStatus();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) { 
      _decreaseCountdownValue();
      if (_countdownValue <= 0) {
        disposeTimer();
        changeIsStartStatus();
        showDialog.call(DatabaseTable.timer);
      }
    });
  }

  void updateView() {
    notifyListeners();
  }

  void resetTimer(){
    _isStart = false;
    _timerValue = 0;
    _countdownValue = 60;
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
