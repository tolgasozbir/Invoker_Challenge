import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../components/trueFalseWidget.dart';
import '../../../entities/spells.dart';
import '../../../providerModels/timer_provider.dart';
import 'training_view.dart';

abstract class TrainingViewModel extends State<TrainingView> with TickerProviderStateMixin {

  final globalAnimKey = GlobalKey<TrueFalseWidgetState>();

  bool isStart=false;
  int trueCounterValue=0;
  int totalTabs=0;
  int totalCast=0;
  bool showAllSpells=false;
  double startButtonOpacity=1.0;

  Timer? timer;
 
  Spells spells=Spells();
  
  String randomSpellImg="images/quas-wex-exort.jpg";
  List<String> trueCombination=[];
  List<String> currentCombination=["q","w","e"];

  @override
  void initState() {
    init();
    super.initState();
  }
  
  void init() async {
    Future.microtask(() => context.read<TimerProvider>().disposeTimer());
  }

}