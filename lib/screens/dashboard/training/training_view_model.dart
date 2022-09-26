import 'dart:async';
import 'package:dota2_invoker/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../components/trueFalseWidget.dart';
import '../../../entities/sounds.dart';
import '../../../entities/spells.dart';
import '../../../providerModels/timer_provider.dart';
import 'training_view.dart';

abstract class TrainingViewModel extends State<TrainingView> with TickerProviderStateMixin {

  final globalAnimKey = GlobalKey<TrueFalseWidgetState>();

  Sounds sounds =Sounds();
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

  late List<dynamic> selectedElement=[
    invokerSelectedElements("images/invoker_quas.png"),
    invokerSelectedElements("images/invoker_wex.png"),
    invokerSelectedElements("images/invoker_exort.png"),
  ];

  void switchElements(String image,String key) {
    selectedElement.removeAt(0);
    currentCombination.removeAt(0);
    currentCombination.add(key);
    selectedElement.add(invokerSelectedElements(image));
    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
  }
  
  void init() async {
    Future.microtask(() => context.read<TimerProvider>().disposeTimer());
  }

  Widget invokerSelectedElements(String image) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [ BoxShadow(color: Colors.black54, blurRadius: 12, spreadRadius: 4), ],
      ),
      child: Image.asset(image,width: context.dynamicWidth(0.07))
    );
  }


}