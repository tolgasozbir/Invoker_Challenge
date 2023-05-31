import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../enums/database_table.dart';
import '../screens/profile/achievements/achievement_manager.dart';
import '../widgets/app_dialogs.dart';
import '../widgets/dialog_contents/result_dialog_content.dart';
import '../widgets/game_ui_widget.dart';
import '../services/user_manager.dart';

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
    _countdownValue += 10;
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
    final int timeTrialTime = 60 + (isAdWatched ? 30 : 0);
    int time = 0;
    switch (gameType) {
      case GameType.Training:
        break;
      case GameType.Challanger:
        time = challangerTime;
        break;
      case GameType.Timer:
        time = timeTrialTime;
        break;
      case GameType.Combo:
        time = (score+1) * 6 + (isAdWatched ? 10 : 0); //6 sec comboduration
        exp = score * 3;
    }
    AchievementManager.instance.updatePlayedGame();
    UserManager.instance.addExp(exp);
    UserManager.instance.setBestScore(gameType, score);
    AppDialogs.showSlidingDialog(
      title: AppStrings.result, 
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

  void setTimeToCountdown(int val) {
    _countdownValue = val;
    notifyListeners();
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
      if (_countdownValue <= 0) {
        disposeTimer();
        changeIsStartStatus();
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
