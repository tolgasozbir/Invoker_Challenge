import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../enums/items.dart';
import '../../../../extensions/context_extension.dart';
import '../../../../extensions/widget_extension.dart';
import '../../../../models/Item.dart';
import '../../../../providers/boss_provider.dart';
import '../../../../widgets/app_dialogs.dart';
import '../../../../widgets/cooldown_animation.dart';
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
    return Container(
      margin: const EdgeInsets.only(left: 24),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [Color(0xFF37596D), Color(0xFF244048), Color(0xFF2B5167)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Consumer<BossProvider>(
        builder: (context, provider, child) {
          final items = context.watch<BossProvider>().inventory;
          return Column(
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
          );
        },
      ),
    );
  }

  List<Widget> _buildRowWidgets(List<Item> myList, int start, int end) {
    final List<Widget> rowWidgets = [];
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
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        gradient: const LinearGradient(
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
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.black.withOpacity(0.64),
            image: DecorationImage(image: AssetImage(item.item.image)),
          ),
          child: Text(
            widget.isItemsSellable 
              ? '' 
              : (item.item.mana?.toStringAsFixed(0) ?? ''), 
            style: TextStyle(
              fontSize: context.sp(10), 
              fontWeight: FontWeight.bold,
              shadows: const [
                BoxShadow(blurRadius: 4),
                BoxShadow(blurRadius: 4),
                BoxShadow(blurRadius: 4),
              ],
            ),
          ).wrapPadding(const EdgeInsets.all(2)).wrapAlign(Alignment.bottomRight),
        ),
      ),
      onTap: () {
        if (widget.isItemsSellable) {
          AppDialogs.showScaleDialog(
            dialogBgColor: const Color(0xFF1C2834),
            content: ItemDescriptionWidget(item: item, isItemSellable: true),
          );
        } else {
          context.read<BossProvider>().onPressedItem(item);
        }
      },
    );
  }
}
