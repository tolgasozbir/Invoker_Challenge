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

  final items = Items.values.where((element) => element.isVisibleInShop).toList();

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
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
          ),
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            final item = items[index];
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
        ).wrapPadding(const EdgeInsets.all(8)),
        const Spacer(),
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
  const GoldWidget({super.key, required this.gold, this.iconHeight = 56});

  final int gold;
  final double iconHeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          gold.toString(), 
          style: TextStyle(
            fontSize: context.sp(14), 
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
