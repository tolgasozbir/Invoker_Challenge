import 'package:dota2_invoker_game/enums/items.dart';
import 'package:dota2_invoker_game/extensions/context_extension.dart';
import 'package:dota2_invoker_game/extensions/widget_extension.dart';
import 'package:dota2_invoker_game/providers/boss_provider.dart';
import 'package:dota2_invoker_game/widgets/cooldown_animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/Item.dart';
import '../../../../widgets/app_dialogs.dart';
import 'item_description_widget.dart';

class InventoryHud extends StatefulWidget {
  const InventoryHud({super.key, this.isItemsSellable = false});

  ///The sentence describes the state of items in two different screens and highlights their sellability status in each of them.
  final bool isItemsSellable;

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

  Widget itemSlot(Item item) {
    return InkWell(
      child: CooldownAnimation(
        key: ObjectKey(item),
        duration: Duration(seconds: (item.item.cooldown ?? 0).toInt()),
        remainingCd: item.cooldownLeft,
        size: context.dynamicWidth(0.12),
        child: Container(
          width: context.dynamicWidth(0.12),
          height: context.dynamicWidth(0.12),
          margin: EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.black.withOpacity(0.64),
            image: DecorationImage(image: AssetImage(item.item.image))
          ),
          child: Text(
            widget.isItemsSellable 
              ? "" 
              : (item.item.mana?.toStringAsFixed(0) ?? ""), 
            style: TextStyle(
              fontSize: context.sp(10), 
              fontWeight: FontWeight.bold,
              shadows: [
                BoxShadow(blurRadius: 4),
                BoxShadow(blurRadius: 4),
                BoxShadow(blurRadius: 4),
              ]
            ),
          ).wrapPadding(EdgeInsets.all(2)).wrapAlign(Alignment.bottomRight),
        ),
      ),
      onTap: () {
        if (widget.isItemsSellable) {
          AppDialogs.showScaleDialog(
            dialogBgColor: Color(0xFF1C2834),
            content: ItemDescriptionWidget(item: item, isItemSellable: true),
          );
        } else {
          context.read<BossProvider>().onPressedItem(item);
        }
      },
    );
  }
}
