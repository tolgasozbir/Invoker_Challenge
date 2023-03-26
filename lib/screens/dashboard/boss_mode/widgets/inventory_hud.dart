import 'package:dota2_invoker_game/enums/items.dart';
import 'package:dota2_invoker_game/extensions/context_extension.dart';
import 'package:dota2_invoker_game/providers/boss_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InventoryHud extends StatefulWidget {
  const InventoryHud({super.key});

  @override
  State<InventoryHud> createState() => _InventoryHudState();
}

class _InventoryHudState extends State<InventoryHud> {
  @override
  Widget build(BuildContext context) {
    var items = context.watch<BossProvider>().inventory;
    return Container(
      margin: EdgeInsets.only(left: 24),
      padding: EdgeInsets.all(2),
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
            children: _buildRowWidgets(items, 0, 3),
          ),
          //EmptyBox.h4(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: _buildRowWidgets(items, 3, 6),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRowWidgets(List myList, int start, int end) {
    List<Widget> rowWidgets = [];
    for (int i = start; i < end; i++) {
      if (i < myList.length) {
        rowWidgets.add(itemSlot(myList[i]));
      } else {
        rowWidgets.add(emptySlot());
      }
    }
    return rowWidgets;
  }

  Container emptySlot() {
    return Container(
      width: context.dynamicWidth(0.12),
      height: context.dynamicWidth(0.12),
      margin: EdgeInsets.all(2),
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

  Container itemSlot(Items item) {
    return Container(
      width: context.dynamicWidth(0.12),
      height: context.dynamicWidth(0.12),
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.black,
        image: DecorationImage(image: AssetImage(item.image))
      ),
    );
  }
}
