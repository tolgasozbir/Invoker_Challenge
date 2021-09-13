import 'package:flutter/material.dart';

class TimerModel extends ChangeNotifier {
  int time=0;

  int getTimeValue(){
    return time;
  }

  double calculateCps(int totalTabs){
    return totalTabs/time;
  }

  double calculateScps(int totalCast){
    return totalCast/time;
  }

  void timeIncrease(){
    time++;
    notifyListeners();
  }

}