import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../enums/database_table.dart';
import '../screens/profile/achievements/achievement_manager.dart';
import '../widgets/app_dialogs.dart';
import '../widgets/dialog_contents/result_dialog_content.dart';
import '../widgets/game_ui_widget.dart';
import 'user_manager.dart';

typedef ResultDialogVoidFunc = void Function(DatabaseTable);

class GameProvider extends ChangeNotifier {
  Timer? _timer;

  bool _isStart = false;
  bool _spellHeplerIsOpen = false;
  int _timerValue = 0;
  int _countdownValue = 10;
  int _correctCombinationCount = 0;

  bool get isStart => _isStart;
  bool get spellHelperIsOpen => _spellHeplerIsOpen;
  int get getTimeValue => _timerValue;
  int get getCountdownValue => _countdownValue;
  int get getCorrectCombinationCount => _correctCombinationCount;

  bool isAdWatched = false;
  void continueChallangerAfterWatchingAd() {
    isAdWatched = true;
    startTimer();
    notifyListeners();
  }  
  
  void continueTimerAfterWatchingAd() {
    isAdWatched = true;
    _countdownValue += 30;
    startCoundown();
    notifyListeners();
  }

  void showResultDialog(GameType gameType, DatabaseTable databaseTable) {
    final int score = getCorrectCombinationCount;
    final int challangerTime = getTimeValue;
    final int withTimerTime = 60 + (isAdWatched ? 30 : 0);
    AchievementManager.instance.updatePlayedGame();
    UserManager.instance.addExp(score);
    AchievementManager.instance.updateLevel();
    UserManager.instance.setBestScore(gameType, score);
    AppDialogs.showSlidingDialog(
      title: AppStrings.result, 
      content: ResultDialogContent(
        correctCount: score,
        time: gameType == GameType.Timer ? withTimerTime : challangerTime,
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

  void startTimer(){
    changeIsStartStatus();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) { 
      _increaseTimer();
    });
  }

  void startCoundown(){
    changeIsStartStatus();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) { 
      _decreaseCountdownValue();
      if (_countdownValue <= 0) {
        disposeTimer();
        changeIsStartStatus();
        showResultDialog(GameType.Timer, DatabaseTable.TimeTrial);
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
