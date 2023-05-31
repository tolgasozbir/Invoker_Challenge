import 'package:flutter/material.dart';

import '../../../../enums/spells.dart';
import '../../../../extensions/context_extension.dart';
import '../../../../extensions/widget_extension.dart';
import '../../../../providers/user_manager.dart';
import '../../../../widgets/empty_box.dart';

class InfoView extends StatelessWidget {
  const InfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About the game.'), //TODO: LANG
        centerTitle: true,
      ),
      body: SafeArea(child: _bodyView(context)),
    );
  }
  
  Widget _bodyView(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        //BackButton().wrapAlign(Alignment.centerLeft),
        const Divider(height: 0),
        ...aboutTheCircles(context),
        const Divider(height: 32),
        ...spellDamageSheet(context),
      ],
    );
  }

  List<Widget> spellDamageSheet(BuildContext context) => [
    Text(
      'Spell Damage Sheets', 
      style: TextStyle(
        fontSize: context.sp(14), 
        decoration: TextDecoration.underline,
      ),
    ).wrapCenter(),
    const EmptyBox.h8(),
    const Text('Note: Each level increases the spell damage by 2%.').wrapFittedBox(),
    const EmptyBox.h8(),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Spell').wrapExpanded(),
        const Text('DPS', textAlign: TextAlign.center,).wrapExpanded(),
        const Text('Duration', textAlign: TextAlign.center,).wrapExpanded(),
        const Text('Total Base Damage', textAlign: TextAlign.center,).wrapExpanded(),
        const Text('Current Total Damage', textAlign: TextAlign.right,).wrapExpanded(), 
      ],
    ),
    Column(
      children: Spell.values.map((e) => spellDamageInfo(e)).toList(),
    )
  ];

  Widget spellDamageInfo(Spell spell) {
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
              child: Text(spell.duration == 1 ? '-' : (spell.damage).toString()).wrapCenter(),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Text(spell.duration == 1 ? '-' : (spell.duration).toString()).wrapCenter(),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Text((spell.damage*spell.duration).toString()).wrapCenter(),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Text(((spell.damage*spell.duration) + ((spell.damage*spell.duration) * UserManager.instance.user.level * 0.02)).toStringAsFixed(1)).wrapAlign(Alignment.centerRight),
            ),
          ],
        )
      ],
    ).wrapPadding(const EdgeInsets.only(bottom: 8));
  }

  List<Widget> aboutTheCircles(BuildContext context) => [
    Text(
      'Meaning of Circles', 
      style: TextStyle(
        fontSize: context.sp(14),
        decoration: TextDecoration.underline,
      ),
    ).wrapCenter(),
    const EmptyBox.h12(),
    Stack(
      alignment: Alignment.center,
      children: [
        circle(176, color: Colors.red),
        circle(128, color: Colors.amber),
        circle(80,  color: Colors.green),
      ],
    ),
    const EmptyBox.h12(),
    Text(
      "The outer circle represents the boss's health.", 
      style: TextStyle(
        fontSize: context.sp(12),
        color: Colors.red, 
        fontWeight: FontWeight.w500,
      ),
    ),
    const EmptyBox.h4(),
    Text(
      'The middle circle represents the number of rounds.',
      style: TextStyle(
        fontSize: context.sp(12),
        color: Colors.amber, 
        fontWeight: FontWeight.w500,
      ),
    ),
    const EmptyBox.h4(),
    Text(
      'The inner circle represents the passage of time.',
      style: TextStyle(
        fontSize: context.sp(12),
        color: Colors.green, 
        fontWeight: FontWeight.w500,
      ),
    ),
    const EmptyBox.h4(),
    Text(
      'Each round is 180 seconds long.',
      style: TextStyle(
        fontSize: context.sp(12),
        fontWeight: FontWeight.w500,
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
