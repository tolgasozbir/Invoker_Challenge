import 'package:dota2_invoker_game/extensions/string_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/locale_keys.g.dart';
import '../../../../enums/items.dart';
import '../../../../extensions/context_extension.dart';
import '../../../../models/Item.dart';
import '../../../../providers/boss_battle_provider.dart';
import '../../../../services/sound_manager.dart';
import '../../../../widgets/app_snackbar.dart';
import '../../../../widgets/empty_box.dart';
import 'shop/shop_view.dart';

class ItemDescriptionWidget extends StatefulWidget {
  const ItemDescriptionWidget({super.key, required this.item, this.isItemSellable = false});

  final Item item;

  ///This variable is used to determine whether an item can be sold. 
  ///If the value is "true", the item is sellable, and if the value is "false", the item cannot be sold. 
  final bool isItemSellable;

  @override
  State<ItemDescriptionWidget> createState() => _ItemDescriptionWidgetState();
}

class _ItemDescriptionWidgetState extends State<ItemDescriptionWidget> {

  final List<Items> onceBuyableItems = const [Items.Dagon, Items.Ethereal_blade];

  Map<String, Items>? upgradableItem;
  static const _upgradableItems = [
    {
      'from' : Items.Void_stone,
      'to' : Items.Aether_lens,
    },
    {
      'from' : Items.Aether_lens,
      'to' : Items.Ethereal_blade,
    },
    {
      'from' : Items.Kaya,
      'to' : Items.Meteor_hammer,
    },
    {
      'from' : Items.Crystalys,
      'to' : Items.Daedalus,
    },
    {
      'from' : Items.Orchid,
      'to' : Items.Bloodthorn,
    },
  ];
  Map<String, Items>? getUpgradableItem() {
    for (final upgradableItem in _upgradableItems) {
      if (upgradableItem['from']?.name == widget.item.item.name) {
        return upgradableItem;
      }
    }
    return null;
  }
    

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
      Colors.black,
    ],
  );

  final existingItems = <Item>[];
  int totalItemDiscount = 0;

  void checkRequiredItemsHasInInventory() {
    final provider = context.read<BossBattleProvider>();
    final requiredItems = widget.item.item.requiredItems ?? [];
    
    for (final requiredItem in requiredItems) {
      if (isItemInInventory(provider, requiredItem)) {
        existingItems.add(Item(item: requiredItem));
        totalItemDiscount += requiredItem.cost;
      }
    }
  }

  @override
  void initState() {
    upgradableItem = getUpgradableItem();
    checkRequiredItemsHasInInventory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.item.item == Items.Dagon) 
      return const DagonDescriptionView();
    
    return SizedBox(
      height: context.dynamicHeight(0.6)-48,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildItemDetails(),
          const EmptyBox.h8(),
          bonusField(),
          if (widget.item.item.activeTranslation.isNotNullOrNoEmpty) 
            itemActiveField(),
          const Spacer(),
          upgradeInfo(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
              children: [
                if (widget.item.item.activeProps.cooldown != null)
                  cooldownfield(),
                const EmptyBox.w12(),
                if (widget.item.item.activeProps.manaCost != null)
                  manafield(),
                ],
              ),
              button(),
            ],
          ),
        ],
      ),
    );
  }

  Row upgradeInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (existingItems.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: existingItems.map((e) {
              return Image.asset(e.item.image, height: 48);
            }).toList(),
          ),
          const Icon(Icons.double_arrow_rounded),
          Image.asset(widget.item.item.image, height: 48),
        ],
      ],
    );
  }

  Widget buildItemDetails() {
    return Row(
      children: [
        //item image
        Image.asset(widget.item.item.image, height: context.dynamicHeight(0.08)),
        const EmptyBox.w8(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //item name
            Text(
              widget.item.item.getName, 
              style: TextStyle(fontSize: context.sp(12), fontWeight: FontWeight.bold),
            ),
            //item cost with icon
            Row(
              children: [
                Text(
                  widget.isItemSellable ? LocaleKeys.Item_sellPrice.locale : LocaleKeys.Item_cost.locale, 
                  style: TextStyle(fontSize: context.sp(11), fontWeight: FontWeight.w500,),
                ),
                GoldWidget(
                  gold: widget.isItemSellable ? (widget.item.item.cost * 0.75).toInt() : (widget.item.item.cost),
                  discount: widget.isItemSellable ? null : totalItemDiscount,
                ),
              ],
            ),
          ],
        ),
        const Spacer(),
        if (upgradableItem != null)
          Row(
            children: [
              const Icon(Icons.keyboard_double_arrow_right_outlined),
              Image.asset(upgradableItem!['to']!.image,  height: context.dynamicHeight(0.06)),
            ],
          ),
      ],
    );
  }

  Widget bonusField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.Item_bonus.locale, 
          style: TextStyle(fontSize: context.sp(11), fontWeight: FontWeight.w500,),
        ),
        Text(
          widget.item.item.bonusTranslation, 
          style: TextStyle(fontSize: context.sp(11), fontWeight: FontWeight.w500,),
        ),
      ],
    );
  }

  Widget itemActiveField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const EmptyBox.h8(),
        Text(
          LocaleKeys.Item_active.locale, 
          style: TextStyle(fontSize: context.sp(11), fontWeight: FontWeight.w500,),
        ),
        Text(
          widget.item.item.activeTranslation, 
          style: TextStyle(fontSize: context.sp(11), fontWeight: FontWeight.w500,),
        ),
        const EmptyBox.h8(),
      ],
    );
  }

  Row cooldownfield() {
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
          widget.item.item.activeProps.cooldown!.toStringAsFixed(0),
          style: TextStyle(fontSize: context.sp(10), fontWeight: FontWeight.w500,),
        ),
      ],
    );
  }

  Row manafield() {
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
          widget.item.item.activeProps.manaCost!.toStringAsFixed(0),
          style: TextStyle(fontSize: context.sp(10), fontWeight: FontWeight.w500,),
        ),
      ],
    );
  }

  ElevatedButton button() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.isItemSellable ? AppColors.red : AppColors.amber,
        foregroundColor: AppColors.black,
      ),
      label: const Icon(Icons.sell_outlined), 
      icon: Text(
        widget.isItemSellable 
          ? LocaleKeys.Item_sell.locale 
          : existingItems.isNotEmpty 
            ? LocaleKeys.Item_upgrade.locale
            : LocaleKeys.Item_buy.locale, 
        style: TextStyle(
          fontSize: context.sp(12), 
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: widget.isItemSellable
       ? () => sellFn(context)
       : () => buyFn(context),
    );
  }

  void buyFn(BuildContext context) {
    Navigator.pop(context);
    final itemCost =  widget.item.item.cost - totalItemDiscount;
    final provider = context.read<BossBattleProvider>();
    if (itemCost > provider.userGold) {
      showSnackBarAndPlaySound(message: LocaleKeys.snackbarMessages_sbNotEnoughGold.locale);
      return;
    }
    if (existingItems.isEmpty && provider.inventory.length == 6 && !widget.item.item.consumable) {
      showSnackBarAndPlaySound(message: LocaleKeys.snackbarMessages_sbInventoryFull.locale);
      return;
    }
    if (widget.item.item.consumable && provider.consumableItems.any((element) => element.item == widget.item.item)) {
      showSnackBarAndPlaySound(
        message: LocaleKeys.snackbarMessages_sbAlreadyAvailable.locale,
        snackBarType: SnackBarType.info,
      );
      return;
    }
    if (onceBuyableItems.contains(widget.item.item)) {
      if (isItemInInventory(provider, widget.item.item)) {
        showSnackBarAndPlaySound(message: LocaleKeys.snackbarMessages_sbSinglePurchase.locale);
        return;
      }
    }
    if (existingItems.isNotEmpty) {
      provider.upgradeItem(widget.item, widget.item.item.cost - totalItemDiscount, existingItems);
    } else {
      provider.addItemToInventory(widget.item);
    }
  }

  void sellFn(BuildContext context) {
    context.read<BossBattleProvider>().removeItemToInventory(widget.item);
    Navigator.pop(context);
  }

  void showSnackBarAndPlaySound({required String message, SnackBarType? snackBarType}) {
    AppSnackBar.showSnackBarMessage(
      text: message,
      snackBartype: snackBarType ?? SnackBarType.error,
    );
    SoundManager.instance.playMeepMerp();
  }

  bool isItemInInventory(BossBattleProvider provider, Items item) {
    return provider.inventory.any((element) => element.item == item);
  }

}


///////////---Dagon View---\\\\\\\\\\\

class DagonDescriptionView extends StatefulWidget {
  const DagonDescriptionView({super.key});

  @override
  State<DagonDescriptionView> createState() => _DagonDescriptionViewState();
}

class _DagonDescriptionViewState extends State<DagonDescriptionView> {
  PageController dagonPageController = PageController();
  int currentDagonLevel = 0;
  Items? currentDagon;
  final List<Items> dagonLevels = [
    Items.Dagon1,
    Items.Dagon2,
    Items.Dagon3,
    Items.Dagon4,
    Items.Dagon5,
  ];
  int selectedDagonIndex = 0;

  @override
  void initState() {
    super.initState();
    _detectDagonLevel();
  }

  void _detectDagonLevel() {
    final inventory = context.read<BossBattleProvider>().inventory;

    for (final item in inventory) {
      if (item.item.name.contains(Items.Dagon.name)) {
        currentDagon = item.item;
        break;
      }
    }

    if (currentDagon == null) {
      print('Dagon not found in inventory.');
      return;
    }

    // Extract the last character from the Dagon item name and determine its level
    final dagonLevelString = currentDagon!.name.substring(currentDagon!.name.length - 1);
    currentDagonLevel = int.tryParse(dagonLevelString) ?? 0;
    dagonPageController = PageController(initialPage: currentDagonLevel);
    selectedDagonIndex = currentDagonLevel == 5 ? currentDagonLevel-1 : currentDagonLevel;
  }

  @override
  Widget build(BuildContext context) {
    final selectedDagon = dagonLevels[selectedDagonIndex];
    return SizedBox(
      height: context.dynamicHeight(0.6) - 48,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildItemDetails(selectedDagon),
          const SizedBox(height: 8),
          _buildBonusField(selectedDagon),
          _buildItemActiveField(selectedDagon),
          _buildDagonPageView(),
          _buildBottomRow(),
        ],
      ),
    );
  }

  Widget _buildItemDetails(Items currentItem) {
    return Row(
      children: [
        Image.asset(Items.Dagon.image, height: context.dynamicHeight(0.08)),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              currentItem.getName,
              style: TextStyle(fontSize: context.sp(12), fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text(
                  LocaleKeys.Item_cost.locale,
                  style: TextStyle(fontSize: context.sp(11), fontWeight: FontWeight.w500),
                ),
                GoldWidget(
                  gold: (currentItem.cost - (currentDagon?.cost ?? 0)).clamp(0, currentItem.cost),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBonusField(Items currentItem) {
    return Text(
      '${LocaleKeys.Item_bonus.locale} ${currentItem.bonusTranslation}',
      style: TextStyle(fontSize: context.sp(11), fontWeight: FontWeight.w500),
    );
  }

  Widget _buildItemActiveField(Items currentItem) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        '${LocaleKeys.Item_active.locale} ${currentItem.activeTranslation}',
        style: TextStyle(fontSize: context.sp(11), fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildDagonPageView() {
    return Expanded(
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (selectedDagonIndex == 0) return;
              dagonPageController.animateToPage(
                selectedDagonIndex-1, 
                duration: Durations.medium2, 
                curve: Curves.linear,
              );
            },
            child: Container(
              height: double.maxFinite,
              width: context.dynamicWidth(0.1),
              color: Colors.transparent,
              child: const Icon(CupertinoIcons.left_chevron),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    itemCount: dagonLevels.length,
                    controller: dagonPageController,
                    onPageChanged: (index) => setState(() => selectedDagonIndex = index),
                    itemBuilder: (context, index) => Image.asset(dagonLevels[index].image),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() => selectedDagonIndex = index);
                        dagonPageController.animateToPage(index, duration: Durations.medium4, curve: Curves.linear);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: selectedDagonIndex == index ? 24 : 20,
                        height: selectedDagonIndex == index ? 24 : 20,
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: currentDagonLevel > index ? Colors.grey : Colors.amber,
                          shape: BoxShape.circle,
                          border: selectedDagonIndex != index
                              ? null
                              : Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (selectedDagonIndex == dagonLevels.length-1) return;
              dagonPageController.animateToPage(
                selectedDagonIndex+1, 
                duration: Durations.medium2, 
                curve: Curves.linear,
              );
            },
            child: Container(
              height: double.maxFinite,
              width: context.dynamicWidth(0.1),
              color: Colors.transparent,
              child: const Icon(CupertinoIcons.right_chevron),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _buildCooldownField(),
            const SizedBox(width: 12),
            _buildManaField(),
          ],
        ),
        _buildActionButton(dagonLevels[selectedDagonIndex]),
      ],
    );
  }

  Widget _buildCooldownField() {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.only(right: 8),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            gradient: SweepGradient(colors: [Colors.grey, Colors.grey, Colors.black]),
          ),
        ),
        Text(
          Items.Dagon.activeProps.cooldown!.toStringAsFixed(0),
          style: TextStyle(fontSize: context.sp(10), fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildManaField() {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.only(right: 8),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            gradient: LinearGradient(
              colors: [Color(0xFF009BCF), Color(0xFF00688A)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Text(
          Items.Dagon.activeProps.manaCost!.toStringAsFixed(0),
          style: TextStyle(fontSize: context.sp(10), fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildActionButton(Items currentItem) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.amber,
        foregroundColor: AppColors.black,
      ),
      icon: const Icon(Icons.sell_outlined),
      label: Text(
        currentDagon == Items.Dagon5 
          ? LocaleKeys.Item_buy.locale
          : currentDagon != null 
            ? LocaleKeys.Item_upgrade.locale
            : LocaleKeys.Item_buy.locale,
        style: TextStyle(fontSize: context.sp(12), fontWeight: FontWeight.bold),
      ),
      onPressed: () => _handleBuyOrUpgrade(currentItem),
    );
  }

  void _handleBuyOrUpgrade(Items currentItem) {
    final provider = context.read<BossBattleProvider>();
    final itemCost = currentItem.cost - (currentDagon?.cost ?? 0);

    if (itemCost > provider.userGold) {
      _showSnackBarAndPlaySound(message: LocaleKeys.snackbarMessages_sbNotEnoughGold.locale);
      return;
    }

    // If inventory is full and there is no Dagon, don't allow purchase
    if (provider.inventory.length == 6 && currentDagon == null) {
      _showSnackBarAndPlaySound(message: LocaleKeys.snackbarMessages_sbInventoryFull.locale);
      return;
    }
    
    // If trying to purchase a Dagon while already owning a Dagon 5
    if (_isItemInInventory(provider)) {
      _showSnackBarAndPlaySound(message: LocaleKeys.snackbarMessages_sbSinglePurchase.locale);
      return;
    }

    // If trying to purchase a lower level Dagon than currently owned
    if (currentDagon != null && currentItem.getLevel <= currentDagonLevel) {
      _showSnackBarAndPlaySound(message: "Bu seviyedeki veya daha düşük seviyedeki bir Dagon'u satın alamazsınız. Mevcut seviyeyi yükseltin.");
      return;
    }

    if (currentDagon != null && currentDagonLevel != 5) {
      provider.upgradeItem(Item(item: currentItem), itemCost, [Item(item: currentDagon!)]);
    } else {
      provider.addItemToInventory(Item(item: currentItem));
    }

    Navigator.pop(context);
  }

  void _showSnackBarAndPlaySound({required String message, SnackBarType? snackBarType}) {
    AppSnackBar.showSnackBarMessage(
      text: message,
      snackBartype: snackBarType ?? SnackBarType.error,
    );
    SoundManager.instance.playMeepMerp();
  }

  bool _isItemInInventory(BossBattleProvider provider) {
    return provider.inventory.any((element) => element.item.name == Items.Dagon5.name);
  }
}

extension on Items {
  int get getLevel {
    final levelString = this.name.substring(this.name.length - 1);
    return int.tryParse(levelString) ?? 0;
  }
}
