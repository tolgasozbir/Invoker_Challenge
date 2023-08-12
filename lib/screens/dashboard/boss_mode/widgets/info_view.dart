import 'package:dota2_invoker_game/constants/locale_keys.g.dart';
import 'package:dota2_invoker_game/extensions/string_extension.dart';
import 'package:flutter/material.dart';

import '../../../../enums/spells.dart';
import '../../../../extensions/context_extension.dart';
import '../../../../extensions/widget_extension.dart';
import '../../../../services/user_manager.dart';
import '../../../../widgets/empty_box.dart';

class InfoView extends StatelessWidget {
  const InfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.bossBattleInfo_aboutTheGame.locale),
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
      LocaleKeys.bossBattleInfo_spellDamageSheet.locale, 
      style: TextStyle(
        fontSize: context.sp(14), 
        decoration: TextDecoration.underline,
      ),
    ).wrapCenter(),
    const EmptyBox.h8(),
    Text(LocaleKeys.bossBattleInfo_note.locale).wrapFittedBox(),
    const EmptyBox.h8(),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(LocaleKeys.bossBattleInfo_spell.locale).wrapExpanded(),
        Text(LocaleKeys.bossBattleInfo_dps.locale, textAlign: TextAlign.center,).wrapExpanded(),
        Text(LocaleKeys.bossBattleInfo_duration.locale, textAlign: TextAlign.center,).wrapExpanded(),
        Text(LocaleKeys.bossBattleInfo_totalBaseDamage.locale, textAlign: TextAlign.center,).wrapExpanded(),
        Text(LocaleKeys.bossBattleInfo_currentTotalDamage.locale, textAlign: TextAlign.right,).wrapExpanded(), 
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
      LocaleKeys.bossBattleInfo_circlesMeaning.locale, 
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
      LocaleKeys.bossBattleInfo_outerCircleInfo.locale, 
      style: TextStyle(
        fontSize: context.sp(12),
        color: Colors.red, 
        fontWeight: FontWeight.w500,
      ),
    ),
    const EmptyBox.h4(),
    Text(
      LocaleKeys.bossBattleInfo_middleCircleInfo.locale,
      style: TextStyle(
        fontSize: context.sp(12),
        color: Colors.amber, 
        fontWeight: FontWeight.w500,
      ),
    ),
    const EmptyBox.h4(),
    Text(
      LocaleKeys.bossBattleInfo_innerCircleInfo.locale,
      style: TextStyle(
        fontSize: context.sp(12),
        color: Colors.green, 
        fontWeight: FontWeight.w500,
      ),
    ),
    const EmptyBox.h4(),
    Text(
      LocaleKeys.bossBattleInfo_roundInfo.locale,
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
