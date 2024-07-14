import 'package:dota2_invoker_game/constants/locale_keys.g.dart';
import 'package:dota2_invoker_game/extensions/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_image_paths.dart';
import '../../../../../enums/items.dart';
import '../../../../../extensions/context_extension.dart';
import '../../../../../extensions/widget_extension.dart';
import '../../../../../models/Item.dart';
import '../../../../../providers/boss_battle_provider.dart';
import '../../../../../services/sound_manager.dart';
import '../../../../../utils/ads_helper.dart';
import '../../../../../widgets/app_dialogs.dart';
import '../../../../../widgets/empty_box.dart';
import '../inventory_hud.dart';
import '../item_description_widget.dart';

class ShopView extends StatefulWidget {
  const ShopView({super.key});

  @override
  State<ShopView> createState() => _ShopViewState();
}

class _ShopViewState extends State<ShopView> {

  static final _items = Items.values.where((element) => element.isVisibleInShop).toList();
  final advancedItems = _items.where((element) => element.itemType == ItemType.Advanced).toList();
  final basicItems = _items.where((element) => element.itemType == ItemType.Basic).toList();
  int selectedTabIndex = 1;
  final selectedColor = const Color(0xFF114C7C);
  final unSelectedColor = const Color(0xFF1C2834);

  List<Items> get getSelectedItems => selectedTabIndex == 0 ? basicItems : advancedItems;

  @override
  void initState() {
    SoundManager.instance.playWelcomeShopSound();
    super.initState();
  }

  @override
  void dispose() {
    SoundManager.instance.playLeaveShopSound();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GoldWidget(gold: context.watch<BossBattleProvider>().userGold),
        ],
      ),
      body: _bodyView(),
    );
  }

  Widget _bodyView() {
    return Column(
      children: [
        const AdBanner(adSize: AdSize.fullBanner),
        tabContainer(),
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
          ),
          itemCount: getSelectedItems.length,
          itemBuilder: (BuildContext context, int index) {
            final item = getSelectedItems[index];
            return InkWell(
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.32),
                  border: Border.all(color: AppColors.amber.withOpacity(0.72)),
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                ),
                child: Image.asset(item.image),
              ),
              onTap: () {
                AppDialogs.showScaleDialog(
                  dialogBgColor: const Color(0xFF1C2834),
                  content: ItemDescriptionWidget(item: Item(item: item)),
                );
              },
            );
          },
        ).wrapPadding(const EdgeInsets.all(8)).wrapExpanded(),
        //const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                consumableItems(),
                const InventoryHud(isItemsSellable: true),
              ],
            ),
            const Spacer(),
          ],
        ),
        const EmptyBox.h16(),
      ],
    );
  }

  Widget tabContainer() {
    return Container(
      // padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(left: 10, right: 10, top: 8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        border: Border.all(
          color: AppColors.amber,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            buildTabItem(0, LocaleKeys.Item_basic.locale),
            const VerticalDivider(color: AppColors.amber, width: 2, thickness: 1,),
            buildTabItem(1, LocaleKeys.Item_advanced.locale),
          ],
        ),
      ),
    );
  }

  Widget buildTabItem(int index, String text) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTabIndex = index),
        child: AnimatedContainer(
          duration: Durations.medium2,
          padding: const EdgeInsets.all(8),
          color: selectedTabIndex == index ? selectedColor : unSelectedColor,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: context.sp(11),
                fontWeight: selectedTabIndex == index ? FontWeight.bold : null,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding consumableItems() {
    return Padding(
      padding: const EdgeInsets.only(left: 24),
      child: Row(
        children: List.generate(context.watch<BossBattleProvider>().consumableItems.length, (index) {
          final item = context.watch<BossBattleProvider>().consumableItems[index].item.image;
          return Image.asset(item, width: context.dynamicWidth(0.1),);
        }),
      ),
    );
  }
}

class GoldWidget extends StatelessWidget {
  const GoldWidget({super.key, required this.gold, this.iconHeight = 32, this.discount});

  final int gold;
  final int? discount;
  final double iconHeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (discount != null)
          AnimatedNumber(begin: gold, end: gold-(discount ?? 0))
        else 
          Text(
            gold.toString(), 
            style: TextStyle(
              fontSize: context.sp(11), 
              fontWeight: FontWeight.bold,
              color: AppColors.goldColor,
              shadows: const [
                BoxShadow(color: AppColors.goldColor, blurRadius: 12),
                BoxShadow(blurRadius: 8),
              ],
            ),
          ),
        Image.asset(ImagePaths.gold, height: iconHeight),
      ],
    );
  }
}

class AnimatedNumber extends StatelessWidget {
  final int begin;
  final int end;

  const AnimatedNumber({super.key, required this.begin, required this.end});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: begin, end: end),
      duration: const Duration(milliseconds: 1200),
      builder: (context, value, child) {
        return Text(
          value.toString(), 
          style: TextStyle(
            fontSize: context.sp(11), 
            fontWeight: FontWeight.bold,
            color: AppColors.goldColor,
            shadows: const [
              BoxShadow(color: AppColors.goldColor, blurRadius: 12),
              BoxShadow(blurRadius: 8),
            ],
          ),
        );
      },
    );
  }
}
