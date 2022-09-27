import 'dart:async';
import 'package:dota2_invoker/constants/app_colors.dart';
import 'package:dota2_invoker/constants/app_strings.dart';
import 'package:dota2_invoker/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../components/trueFalseWidget.dart';
import '../../../entities/spells.dart';
import '../../../models/spell.dart';
import '../../../providerModels/timer_provider.dart';
import 'training_view.dart';

abstract class TrainingViewModel extends State<TrainingView> with TickerProviderStateMixin {

  final globalAnimKey = GlobalKey<TrueFalseWidgetState>();

  bool isStart = false;
  int trueCounterValue = 0;
  int totalTabs = 0;
  int totalCast = 0;
  bool showAllSpells = false;
  double startButtonOpacity = 1.0;
  String nextSpellImg = ImagePaths.spellImage;
  List<String> trueCombination=[];
  List<String> currentCombination=["q","w","e"];

  BoxDecoration skillBlackShadowDec = BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: AppColors.blackShadow, 
        blurRadius: 12, 
        spreadRadius: 4
      ),
    ],
  );

  @override
  void initState() {
    init();
    super.initState();
  }
  
  void init() async {
    Future.microtask(() => context.read<TimerProvider>().disposeTimer());
  }
  

  late List<Widget> selectedOrbs = [
    orb(ImagePaths.quasOrb),
    orb(ImagePaths.wexOrb),
    orb(ImagePaths.exortOrb),
  ];

  Widget orb(String image) {
    return Container(
      decoration: skillBlackShadowDec,
      child: Image.asset(image,width: context.dynamicWidth(0.07))
    );
  }

  void switchOrb(String image,String key) {
    totalTabs++;
    selectedOrbs.removeAt(0);
    currentCombination.removeAt(0);
    currentCombination.add(key);
    selectedOrbs.add(orb(image));
    setState(() {});
  }

  void nextSpell(){
    Spell nextSpell = Spells.instance.getRandomSpell;
    nextSpellImg = nextSpell.image;
    trueCombination = nextSpell.combine;
    setState(() {});
    print('Next Combination : $trueCombination');
  }

}