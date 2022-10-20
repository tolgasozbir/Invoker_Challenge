import '../extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../enums/elements.dart';
import '../providers/timer_provider.dart';

mixin OrbMixin<T extends StatefulWidget> on State<T> {

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

  late List<Widget> selectedOrbs = [
    orb(Elements.quas),
    orb(Elements.wex),
    orb(Elements.exort),
  ];

  Widget orb(Elements element) {
    return Container(
      decoration: skillBlackShadowDec,
      child: Image.asset(element.getImage, width: context.dynamicWidth(0.07))
    );
  }

  void switchOrb(Elements element) {
    bool isStart = context.read<TimerProvider>().isStart;
    if (isStart) {
      context.read<TimerProvider>().increaseTotalTabs();
    }
    selectedOrbs.removeAt(0);
    currentCombination.removeAt(0);
    currentCombination.add(element.getKey);
    selectedOrbs.add(orb(element));
  }
}