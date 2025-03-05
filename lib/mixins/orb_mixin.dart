import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../enums/elements.dart';
import '../extensions/context_extension.dart';

mixin OrbMixin<T extends StatefulWidget> on State<T> {

  final List<String> _currentCombination = ['q','w','e'];
  String get currentCombination => _currentCombination.join();

  BoxDecoration qwerAbilityDecoration(Color color) => BoxDecoration(
    borderRadius: const BorderRadius.all(Radius.circular(8)),
    border: const Border.symmetric(
      horizontal: BorderSide(strokeAlign: BorderSide.strokeAlignOutside),
      vertical: BorderSide(strokeAlign: BorderSide.strokeAlignOutside),
    ),
    boxShadow: [
      BoxShadow(
        color: color, 
        blurRadius: 16,
        //offset: const Offset(2, 2),
      ),
    ],
  );

  final selectedOrbs = ValueNotifier<List<Widget>>([
    const Orb(Elements.quas),
    const Orb(Elements.wex),
    const Orb(Elements.exort),
  ]);

  void switchOrb(Elements element) {
    selectedOrbs.value.removeAt(0);
    _currentCombination.removeAt(0);
    _currentCombination.add(element.getKey);
    selectedOrbs.value = List.from(selectedOrbs.value)..add(Orb(element));
  }
  
}

class Orb extends StatelessWidget {
  const Orb(this.orb, {super.key});

  final Elements orb;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(2.0)),
        border: Border.symmetric(
          horizontal: BorderSide(width: 1.6, strokeAlign: BorderSide.strokeAlignOutside),
          vertical: BorderSide(width: 1.6, strokeAlign: BorderSide.strokeAlignOutside),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.orbsShadow, 
            blurRadius: 4, 
            spreadRadius: 2,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Image.asset(orb.getImage, width: context.dynamicWidth(0.07)),
    );
  }
}
