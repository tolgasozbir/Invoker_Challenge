import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../enums/spells.dart';
import '../extensions/context_extension.dart';

enum QWEKey { Q, W, E, }

extension KeyExtension on QWEKey {
  Widget getSpellKey(String combineKey){
    switch (this) {
      case QWEKey.Q:
        return Card(
          color: const Color(0x703DA5FF), 
          child: Text(' $name ', style: const TextStyle(fontSize: 17)),
        );
      case QWEKey.W:
        return Card(
          color: const Color(0x70EC3DFF), 
          child: Text(' $name ', style: const TextStyle(fontSize: 17)),
        );
      case QWEKey.E:
        return Card(
          color: const Color(0x70FFAA00), 
          child: Text(' $name ', style: const TextStyle(fontSize: 17)),
        );
    }
  }
}

class SpellsHelperWidget extends StatefulWidget {
  const SpellsHelperWidget({super.key, this.height,});
  
  final double? height;

  @override
  State<SpellsHelperWidget> createState() => _SpellsHelperWidgetState();
}

class _SpellsHelperWidgetState extends State<SpellsHelperWidget> {
  final List<Spell> allSpells = Spell.values;
  final margin = const EdgeInsets.symmetric(vertical: 4);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? context.dynamicHeight(0.24), 
      child: Card(
        color: AppColors.spellHelperShadow,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            quasColumn(),
            wexColumn(),
            exortColumn(),
          ],
        ),
      ),
    );
  }

  Row keyCard(int i) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(allSpells[i].image, scale: 5,),
        ...List.generate(allSpells[i].combination.length, (index) {
          return QWEKey.values.byName(allSpells[i].combination[index].toUpperCase()).getSpellKey(allSpells[i].combination[index]);
        }),
      ],
    );
  }

  Widget quasColumn() {
    return Card(
      margin: margin,
      color: const Color(0x333DA5FF),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (i) => Card(
          color: const Color(0x443DA5FF),
          child: keyCard(i),
        ),),
      ),
    );
  }

  Widget wexColumn() {
    return Card(
      margin: margin,
      color: const Color(0x23EC3DFF),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (i) => Card(
          color: const Color(0x34EC3DFF),
          child: keyCard(i+3),
        ),),
      ),
    );
  }

  Widget exortColumn() {
    return Card(
      margin: margin,
      color: const Color(0x33EE9900),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (i) => Card(
          color: const Color(0x22FFAA11),
          child: keyCard(i+7),
        ),),
      ),
    );
  }
}
