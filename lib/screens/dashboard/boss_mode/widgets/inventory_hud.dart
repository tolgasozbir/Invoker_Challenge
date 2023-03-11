import 'package:dota2_invoker_game/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import '../../../../extensions/widget_extension.dart';

class InventoryHud extends StatelessWidget {
  const InventoryHud({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 24),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [Color(0xFF37596D), Color(0xFF244048), Color(0xFF2B5167)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              emptySlot(context),
              EmptyBox.w4(),
              emptySlot(context),
              EmptyBox.w4(),
              emptySlot(context),
            ],
          ),
          EmptyBox.h4(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              emptySlot(context),
              EmptyBox.w4(),
              emptySlot(context),
              EmptyBox.w4(),
              emptySlot(context),
            ],
          ),
        ],
      ),
    );
  }

  Container emptySlot(BuildContext context) {
    return Container(
      width: context.dynamicWidth(0.12),
      height: context.dynamicWidth(0.12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        gradient: LinearGradient(
          colors: [Color(0xFF1A222B), Color(0xFF1F2B37)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

}
