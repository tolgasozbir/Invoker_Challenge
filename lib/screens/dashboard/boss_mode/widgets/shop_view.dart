import 'package:dota2_invoker_game/utils/ads_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_strings.dart';
import '../../../../enums/items.dart';
import '../../../../extensions/context_extension.dart';
import '../../../../extensions/widget_extension.dart';
import '../../../../models/Item.dart';
import '../../../../providers/boss_provider.dart';
import 'inventory_hud.dart';
import '../../../../services/sound_manager.dart';
import '../../../../widgets/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'item_description_widget.dart';

class ShopView extends StatefulWidget {
  const ShopView({super.key});

  @override
  State<ShopView> createState() => _ShopViewState();
}

class _ShopViewState extends State<ShopView> {

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
          GoldWidget(gold: context.watch<BossProvider>().userGold)
        ],
      ),
      body: _bodyView(),
    );
  }

  Widget _bodyView() {
    return Column(
      children: [
        AdBanner(adSize: AdSize.fullBanner),
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
          ),
          itemCount: Items.values.length,
          itemBuilder: (BuildContext context, int index) {
            var item = Items.values[index];
            return InkWell(
              child: Container(
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.32),
                  border: Border.all(color: AppColors.amber.withOpacity(0.72)),
                  borderRadius: BorderRadius.all(Radius.circular(6))
                ),
                child: Image.asset(item.image)
              ),
              onTap: () {
                AppDialogs.showScaleDialog(
                  dialogBgColor: Color(0xFF1C2834),
                  content: ItemDescriptionWidget(item: Item(item: item)),
                );
              },
            );
          },
        ).wrapPadding(EdgeInsets.all(8)),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InventoryHud(isItemsSellable: true),
            EmptyBox().wrapExpanded(),
          ],
        ),
        EmptyBox.h16(),
      ],
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
            shadows: [
              BoxShadow(color: AppColors.goldColor, blurRadius: 12),
              BoxShadow(color: AppColors.black, blurRadius: 8),
            ]
          ),
        ),
        Image.asset(ImagePaths.gold, height: iconHeight),
      ],
    );
  }
}