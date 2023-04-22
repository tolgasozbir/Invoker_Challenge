import 'package:dota2_invoker_game/enums/spells.dart';
import 'package:dota2_invoker_game/extensions/context_extension.dart';
import 'package:dota2_invoker_game/extensions/widget_extension.dart';
import 'package:dota2_invoker_game/providers/user_manager.dart';
import 'package:flutter/material.dart';

class InfoView extends StatelessWidget {
  const InfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About the game."), //TODO: LANG
        centerTitle: true,
      ),
      body: SafeArea(child: _bodyView(context)),
    );
  }
  
  Widget _bodyView(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(8),
      children: [
        //BackButton().wrapAlign(Alignment.centerLeft),
        Divider(height: 0),
        ...aboutTheCircles(context),
        Divider(height: 32),
        ...spellDamageSheet(context),
      ],
    );
  }

  List<Widget> spellDamageSheet(BuildContext context) => [
    Text(
      "Spell Damage Sheets", 
      style: TextStyle(
        fontSize: context.sp(14), 
        decoration: TextDecoration.underline
      ),
    ).wrapCenter(),
    EmptyBox.h8(),
    Text("Note: Each level increases the spell damage by 2%.").wrapFittedBox(),
    EmptyBox.h8(),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Spell").wrapExpanded(),
        Text("DPS", textAlign: TextAlign.center,).wrapExpanded(),
        Text("Duration", textAlign: TextAlign.center,).wrapExpanded(),
        Text("Total Base Damage", textAlign: TextAlign.center,).wrapExpanded(),
        Text("Current Total Damage", textAlign: TextAlign.right,).wrapExpanded(), 
      ]
    ),
    Column(
      children: Spells.values.map((e) => spellDamageInfo(e)).toList(),
    )
  ];

  Widget spellDamageInfo(Spells spell) {
    return Table(
      children: [
        TableRow(
          children: [
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Image.asset(spell.image, height: 48,).wrapAlign(Alignment.centerLeft),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Text(spell.duration == 1 ? "-" : (spell.damage).toString()).wrapCenter(),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Text(spell.duration == 1 ? "-" : (spell.duration).toString()).wrapCenter(),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Text((spell.damage*spell.duration).toString()).wrapCenter(),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Text(((spell.damage*spell.duration) + ((spell.damage*spell.duration) * UserManager.instance.user.level * 0.02)).toStringAsFixed(1)).wrapAlign(Alignment.centerRight),
            ),
          ]
        )
      ],
    ).wrapPadding(EdgeInsets.only(bottom: 8));
  }

  List<Widget> aboutTheCircles(BuildContext context) => [
    Text(
      "Meaning of Circles", 
      style: TextStyle(
        fontSize: context.sp(14),
        decoration: TextDecoration.underline,
      ),
    ).wrapCenter(),
    EmptyBox.h12(),
    Stack(
      alignment: Alignment.center,
      children: [
        circle(176, color: Colors.red),
        circle(128, color: Colors.amber),
        circle(80,  color: Colors.green),
      ],
    ),
    EmptyBox.h12(),
    Text(
      "The outer circle represents the boss's health.", 
      style: TextStyle(
        fontSize: context.sp(12),
        color: Colors.red, 
        fontWeight: FontWeight.w500
      ),
    ),
    EmptyBox.h4(),
    Text(
      "The middle circle represents the number of rounds.",
      style: TextStyle(
        fontSize: context.sp(12),
        color: Colors.amber, 
        fontWeight: FontWeight.w500
      ),
    ),
    EmptyBox.h4(),
    Text(
      "The inner circle represents the passage of time.",
      style: TextStyle(
        fontSize: context.sp(12),
        color: Colors.green, 
        fontWeight: FontWeight.w500
      ),
    ),
    EmptyBox.h4(),
    Text(
      "Each round is 180 seconds long.",
      style: TextStyle(
        fontSize: context.sp(12),
        fontWeight: FontWeight.w500
      ),
    ),
  ];

  Container circle(double size, {Color? color}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: color ?? Colors.white,
          width: 8,
        ),
      ),
    );
  }

}