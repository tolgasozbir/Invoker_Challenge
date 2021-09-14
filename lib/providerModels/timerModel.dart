import 'package:flutter/material.dart';

class TimerModel extends ChangeNotifier {
  int time=0;
  int time60=60;

  int getTimeValue(){
    return time;
  }

  int getTime60Value(){
    return time60;
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

  void timeDecrease(){
    time60--;
    notifyListeners();
  }

}