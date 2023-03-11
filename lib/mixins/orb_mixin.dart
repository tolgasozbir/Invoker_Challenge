import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../enums/elements.dart';
import '../extensions/context_extension.dart';
import '../providers/boss_provider.dart';
import '../providers/game_provider.dart';

mixin OrbMixin<T extends StatefulWidget> on State<T> {

  List<String> currentCombination=['q','w','e'];

  BoxDecoration qwerAbilityDecoration(Color color) => BoxDecoration(
    borderRadius: BorderRadius.circular(2),
    border: Border.all(strokeAlign: BorderSide.strokeAlignOutside),
    boxShadow: [
      BoxShadow(
        color: color, 
        blurRadius: 16,
        offset: Offset(2, 2)
      ),
    ],
  );

  final _orbDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(2),
    border: Border.all(
      width: 1.6, 
      strokeAlign: BorderSide.strokeAlignOutside
    ),
    boxShadow: [
      BoxShadow(
        color: AppColors.orbsShadow, 
        blurRadius: 4, 
        spreadRadius: 2,
        offset: Offset(2, 2)
      ),
    ],
  );  

  late List<Widget> selectedOrbs = [
    orb(Elements.quas),
    orb(Elements.wex),
    orb(Elements.exort),
  ];

  Widget orb(Elements element) {
    return DecoratedBox(
      decoration: _orbDecoration,
      child: Image.asset(element.getImage, width: context.dynamicWidth(0.07)),
    );
  }

  void switchOrb(Elements element) {
    selectedOrbs.removeAt(0);
    currentCombination.removeAt(0);
    currentCombination.add(element.getKey);
    selectedOrbs.add(orb(element));
    context.read<GameProvider>().updateView();
    context.read<BossProvider>().updateView();
  }
  
}
