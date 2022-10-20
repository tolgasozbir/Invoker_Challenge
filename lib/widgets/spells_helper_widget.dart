import 'package:dota2_invoker/extensions/context_extension.dart';
import 'package:dota2_invoker/providers/spell_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/spell.dart';

enum QWEKey { Q, W, E, }

extension qweExtension on QWEKey {
  Widget getSpellKey(String combineKey){
    switch (this) {
      case QWEKey.Q:
        return Card(color: Color(0x703DA5FF), child: Text(" ${this.name} ", style: TextStyle(fontSize: 17),));
      case QWEKey.W:
        return Card(color: Color(0x70EC3DFF), child: Text(" ${this.name} ", style: TextStyle(fontSize: 17),));
      case QWEKey.E:
        return Card(color: Color(0x70FFAA00), child: Text(" ${this.name} ", style: TextStyle(fontSize: 17),));
    }
  }
}

class SpellsHelperWidget extends StatefulWidget {
  SpellsHelperWidget({Key? key, this.height,}) : super(key: key);
  
  final double? height;

  @override
  State<SpellsHelperWidget> createState() => _SpellsHelperWidgetState();
}

class _SpellsHelperWidgetState extends State<SpellsHelperWidget> {
  late final List<Spell> allSpells;

  @override
  void initState() {
    allSpells = context.read<SpellProvider>().gelSpellList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? context.dynamicHeight(0.24), 
      child: Card(
        color: Colors.black12,
        child: Row(
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
        ...List.generate(allSpells[i].combine.length, (index) {
          return QWEKey.values.byName(allSpells[i].combine[index].toUpperCase()).getSpellKey(allSpells[i].combine[index]);
        }),
      ],
    );
  }

  Widget quasColumn() {
    return Expanded(
      child: Card(
        color: Color(0x333DA5FF),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) => Card(
              color: Color(0x443DA5FF),
              child: keyCard(i),
            ),),
        ),
      ),
    );
  }

  Widget wexColumn() {
    return Card(
      color: Color(0x23EC3DFF),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
           children: List.generate(4, (i) => Card(
              color: Color(0x34EC3DFF),
              child: keyCard(i+3),
            ),),
      ),
    );
  }

  Widget exortColumn() {
    return Expanded(
      child: Card(
        color: Color(0x33EE9900),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) => Card(
                color: Color(0x22FFAA11),
                child: keyCard(i+7),
              ),),
        ),
      ),
    );
  }
}
