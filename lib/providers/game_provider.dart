import 'dart:async';

import 'package:dota2_invoker_game/extensions/string_extension.dart';
import 'package:flutter/material.dart';

import '../constants/locale_keys.g.dart';
import '../enums/database_table.dart';
import '../services/achievement_manager.dart';
import '../services/user_manager.dart';
import '../widgets/app_dialogs.dart';
import '../widgets/dialog_contents/result_dialog_content.dart';
import '../widgets/game_ui_widget.dart';

typedef ResultDialogVoidFunc = void Function(DatabaseTable);

class GameProvider extends ChangeNotifier {
  Timer? _timer;

  bool get isPremium => UserManager.instance.user.isPremium;
  bool _isStart = false;
  bool _spellHeplerIsOpen = false;
  int _timerValue = 0;
  int _countdownValue = 60;
  int _correctCombinationCount = 0;
  int _comboPassingTime = 0;

  //Variable used to track how many times the user has pressed a button
  //Increment this variable each time the button is pressed
  //This allows you to keep track of how many times the user has pressed the button
  int buttonPressCount = 0;



  bool get isStart => _isStart;
  bool get spellHelperIsOpen => _spellHeplerIsOpen;
  int get getTimerValue => _timerValue;
  int get getCountdownValue => _countdownValue;
  int get getCorrectCombinationCount => _correctCombinationCount;

  bool isAdWatched = false;
  void continueChallangerAfterWatchingAd() {
    isAdWatched = true;
    startTimer();
    notifyListeners();
  }  
  
  void continueTimeTrialAfterWatchingAd() {
    isAdWatched = true;
    _countdownValue += 30;
    startCoundown(
      gameType: GameType.Timer, 
      databaseTable: DatabaseTable.TimeTrial,
    );
    notifyListeners();
  }  
  
  void continueComboAfterWatchingAd() {
    isAdWatched = true;
    _countdownValue += isPremium ? 15 : 10;
    startCoundown(
      gameType: GameType.Combo, 
      databaseTable: DatabaseTable.Combo,
    );
    notifyListeners();
  }

  void showResultDialog(GameType gameType, DatabaseTable databaseTable) {
    final int score = getCorrectCombinationCount;
    int exp = getCorrectCombinationCount;
    final int challangerTime = getTimerValue;
    final int timeTrialTime = 60 + (isAdWatched ? 30 : 0) + (isPremium ? 30 : 0);
    int time = 0;
    switch (gameType) {
      case GameType.Training:
        break;
      case GameType.Challanger:
        time = challangerTime;
      case GameType.Timer:
        time = timeTrialTime;
      case GameType.Combo:
        time = _comboPassingTime + (isAdWatched ? 10 : 0); //6 sec comboduration
        exp = score * 3;
    }
    AchievementManager.instance.updatePlayedGame();
    UserManager.instance.addExp(exp);
    UserManager.instance.setBestScore(gameType, score);
    AppDialogs.showSlidingDialog(
      title: LocaleKeys.commonGeneral_result.locale, 
      content: ResultDialogContent(
        correctCount: score,
        time: time,
        exp: exp,
        gameType: gameType,
      ),
      action: ResultDialogAction(databaseTable: databaseTable, gameType: gameType),
    );
  }

  void changeIsStartStatus(){
    _isStart = !_isStart;
    notifyListeners();
  }

  void showCloseHelperWidget() {
    _spellHeplerIsOpen = !_spellHeplerIsOpen;
    notifyListeners();
  }

  void _increaseComboPassingTime() {
    _comboPassingTime++;
  }

  void increaseCorrectCounter(){
    _correctCombinationCount++;
    notifyListeners();
  }
  
  void decreaseCorrectCounter(){
    if (_correctCombinationCount > 0) {
      _correctCombinationCount--;
      notifyListeners();
    }
  }  
  
  void _increaseTimer(){
    _timerValue++;
    notifyListeners();
  }

  void _decreaseCountdownValue(){
    _countdownValue--;  
    notifyListeners();
  }

  void _setCountdownTime(int val) {
    _countdownValue = val;
    notifyListeners();
  }

  void updateCountdownTimeBasedOnScore() {
    final score = getCorrectCombinationCount;
    int countdownTime;

    if (score < 8) countdownTime = 8;
    else if (score < 16) countdownTime = 7;
    else if (score < 32) countdownTime = 6;
    else if (score < 64) countdownTime = 5;
    else if (score < 128) countdownTime = 4;
    else countdownTime = 3;

    _setCountdownTime(countdownTime);
  }

  void startTimer(){
    changeIsStartStatus();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) { 
      _increaseTimer();
    });
  }

  void startCoundown({required GameType gameType, required DatabaseTable databaseTable}){
    changeIsStartStatus();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) { 
      _decreaseCountdownValue();
      _increaseComboPassingTime();
      buttonPressCount = 0;
      if (_countdownValue <= 0) {
        disposeTimer();
        changeIsStartStatus();
        if (isPremium && gameType == GameType.Combo && isAdWatched == false) {
          continueComboAfterWatchingAd();
          return;
        }
        showResultDialog(gameType, databaseTable);
      }
    });
  }

  void updateView() {
    notifyListeners();
  }

  void resetTimer(){
    isAdWatched = false;
    _isStart = false;
    _timerValue = 0;
    _countdownValue = 60 + (isPremium ? 30 : 0);
    _correctCombinationCount = 0;
    _comboPassingTime = 0;
    disposeTimer();
    notifyListeners();
  }

  void disposeTimer(){
    if (_timer!=null) {
      _timer!.cancel();
    }
  }

}
