import 'package:dota2_invoker_game/extensions/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/locale_keys.g.dart';
import '../../../../enums/items.dart';
import '../../../../extensions/context_extension.dart';
import '../../../../extensions/widget_extension.dart';
import '../../../../models/Item.dart';
import '../../../../providers/boss_battle_provider.dart';
import '../../../../services/sound_manager.dart';
import '../../../../widgets/app_snackbar.dart';
import '../../../../widgets/empty_box.dart';
import 'shop_view.dart';

class ItemDescriptionWidget extends StatelessWidget {
  const ItemDescriptionWidget({super.key, required this.item, this.isItemSellable = false});

  final Item item;

  ///This variable is used to determine whether an item can be sold. 
  ///If the value is "true", the item is sellable, and if the value is "false", the item cannot be sold. 
  final bool isItemSellable;

  double get containerSize => 20;
  EdgeInsets get margin => const EdgeInsets.only(right: 8);
  BorderRadius get borderRadius => const BorderRadius.all(Radius.circular(4));
  LinearGradient get manaGradient => const LinearGradient(
    colors: [
      Color(0xFF009BCF), 
      Color(0xFF00688A),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  SweepGradient get cooldownGradient => const SweepGradient(
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
          if (item.item.activeTranslation.isNotNullOrNoEmpty) 
            itemActiveField(context),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
              children: [
                if (item.item.activeProps.cooldown != null)
                  cooldownfield(context),
                const EmptyBox.w12(),
                if (item.item.activeProps.manaCost != null)
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
        const EmptyBox.w8(),
        Text(item.item.getName, style: TextStyle(fontSize: context.sp(14), fontWeight: FontWeight.bold),),
        const EmptyBox.h12(),
      ],
    );
  }

  Widget itemCostField(BuildContext context) {
    return Row(
      children: [
        Text(
          isItemSellable ? LocaleKeys.Item_sellPrice.locale : LocaleKeys.Item_cost.locale, 
          style: TextStyle(fontSize: context.sp(13), fontWeight: FontWeight.w500,),
        ),
        GoldWidget(gold: isItemSellable ? (item.item.cost * 0.75).toInt() : item.item.cost),
      ],
    ).wrapPadding(const EdgeInsets.only(bottom: 8));
  }

  Text bonusField(BuildContext context) {
    return Text(
      '${LocaleKeys.Item_bonus.locale} ${item.item.bonusTranslation}', 
      style: TextStyle(fontSize: context.sp(13), fontWeight: FontWeight.w500,),
    );
  }

  Widget itemActiveField(BuildContext context) {
    return Text(
      '${LocaleKeys.Item_active.locale} ${item.item.activeTranslation}', 
      style: TextStyle(fontSize: context.sp(13), fontWeight: FontWeight.w500,),
    ).wrapPadding(const EdgeInsets.symmetric(vertical: 8));
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
          item.item.activeProps.cooldown!.toStringAsFixed(0),
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
          item.item.activeProps.manaCost!.toStringAsFixed(0),
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
      label: const Icon(Icons.sell_outlined), 
      icon: Text(isItemSellable ? LocaleKeys.Item_sell.locale : LocaleKeys.Item_buy.locale, style: TextStyle(fontSize: context.sp(14), fontWeight: FontWeight.bold,),),
      onPressed: isItemSellable
       ? () => sellFn(context)
       : () => buyFn(context),
    );
  }

  void buyFn(BuildContext context) {
    Navigator.pop(context);
    final provider = context.read<BossBattleProvider>();
    if (item.item.cost > provider.userGold) {
      AppSnackBar.showSnackBarMessage(
        text: LocaleKeys.snackbarMessages_sbNotEnoughGold.locale,
        snackBartype: SnackBarType.error,
      );
      SoundManager.instance.playMeepMerp();
      return;
    }
    if (item.item.consumable && provider.consumableItems.any((element) => element.item == item.item)) {
      AppSnackBar.showSnackBarMessage(
        text: LocaleKeys.snackbarMessages_sbAlreadyAvailable.locale,
        snackBartype: SnackBarType.error,
      );
      SoundManager.instance.playMeepMerp();
      return;
    }
    if (provider.inventory.length == 6 && !item.item.consumable) {
      AppSnackBar.showSnackBarMessage(
        text: LocaleKeys.snackbarMessages_sbInventoryFull.locale, 
        snackBartype: SnackBarType.error,
      );
      SoundManager.instance.playMeepMerp();
      return;
    }
    provider.addItemToInventory(item);
  }

  void sellFn(BuildContext context) {
    context.read<BossBattleProvider>().removeItemToInventory(item);
    Navigator.pop(context);
  }

}
