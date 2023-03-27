import 'package:dota2_invoker_game/extensions/context_extension.dart';
import 'package:dota2_invoker_game/models/Item.dart';
import 'package:dota2_invoker_game/screens/dashboard/boss_mode/widgets/shop_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../constants/app_colors.dart';
import '../../../../enums/items.dart';
import '../../../../extensions/widget_extension.dart';
import '../../../../providers/boss_provider.dart';
import '../../../../services/sound_manager.dart';

class ItemDescriptionWidget extends StatelessWidget {
  const ItemDescriptionWidget({super.key, required this.item, this.isItemSellable = false});

  final Item item;

  ///This variable is used to determine whether an item can be sold. 
  ///If the value is "true", the item is sellable, and if the value is "false", the item cannot be sold. 
  final bool isItemSellable;

  final double containerSize = 20;
  final margin = const EdgeInsets.only(right: 8);
  final borderRadius = const BorderRadius.all(Radius.circular(4));
  final manaGradient = const LinearGradient(
    colors: [
      Color(0xFF009BCF), 
      Color(0xFF00688A),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  final cooldownGradient = const SweepGradient(
    colors: [
      Colors.grey, 
      Colors.grey, 
      Colors.black
    ],
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.dynamicHeight(0.6)-48,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          itemImageAndTitle(context),
          itemCostField(context),
          bonusField(context),
          if (item.item.active != null) 
            itemActiveField(context),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
              children: [
                if (item.item.cooldown != null)
                  cooldownfield(context),
                EmptyBox.w12(),
                if (item.item.mana != null)
                  manafield(context),
                ],
              ),
              button(context),
            ],
          )
        ],
      ),
    );
  }

  Row itemImageAndTitle(BuildContext context) {
    return Row(
      children: [
        Image.asset(item.item.image, height: context.dynamicHeight(0.12)),
        EmptyBox.w8(),
        Text(item.item.getName, style: TextStyle(fontSize: context.sp(14), fontWeight: FontWeight.bold),),
        EmptyBox.h12(),
      ],
    );
  }

  Widget itemCostField(BuildContext context) {
    return Row(
      children: [
        Text(
          "Cost: ", 
          style: TextStyle(fontSize: context.sp(13), fontWeight: FontWeight.w500,),
        ),
        GoldWidget(gold: item.item.cost),
      ],
    ).wrapPadding(EdgeInsets.only(bottom: 8));
  }

  Text bonusField(BuildContext context) {
    return Text(
      "Bonus: ${item.item.bonus}", 
      style: TextStyle(fontSize: context.sp(13), fontWeight: FontWeight.w500,),
    );
  }

  Widget itemActiveField(BuildContext context) {
    return Text(
      "Active: ${item.item.active}", 
      style: TextStyle(fontSize: context.sp(13), fontWeight: FontWeight.w500,),
    ).wrapPadding(EdgeInsets.symmetric(vertical: 8));
  }

  Row cooldownfield(BuildContext context) {
    return Row(
      children: [
        Container(
          width: containerSize,
          height: containerSize,
          margin: margin,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: cooldownGradient,
          ),
        ),
        Text(
          item.item.cooldown!.toStringAsFixed(0),
          style: TextStyle(fontSize: context.sp(13), fontWeight: FontWeight.w500,),
        ),
      ],
    );
  }

  Row manafield(BuildContext context) {
    return Row(
      children: [
        Container(
          width: containerSize,
          height: containerSize,
          margin: margin,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: manaGradient,
          ),
        ),
        Text(
          item.item.mana!.toStringAsFixed(0),
          style: TextStyle(fontSize: context.sp(13), fontWeight: FontWeight.w500,),
        ),
      ],
    );
  }

  ElevatedButton button(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: isItemSellable ? AppColors.red : AppColors.amber,
        foregroundColor: AppColors.black,
      ),
      label: Icon(Icons.sell_outlined), 
      icon: Text(isItemSellable ? "Sell" : "Buy", style: TextStyle(fontSize: context.sp(14), fontWeight: FontWeight.bold,),),
      onPressed: isItemSellable
       ? () => sellFn(context)
       : () => buyFn(context),
    );
  }

  void buyFn(BuildContext context) {
    bool purchasable = true;
    if (purchasable) {
      context.read<BossProvider>().addItemToInventory(item);
      Navigator.pop(context);
    } else {
      SoundManager.instance.playMeepMerp();
    }
  }

  void sellFn(BuildContext context) {
    context.read<BossProvider>().removeItemToInventory(item);
    Navigator.pop(context);
  }

}