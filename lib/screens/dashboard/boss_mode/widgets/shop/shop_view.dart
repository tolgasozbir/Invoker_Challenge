import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:dota2_invoker_game/constants/locale_keys.g.dart';
import 'package:dota2_invoker_game/extensions/string_extension.dart';
import 'package:dota2_invoker_game/mixins/screen_state_mixin.dart';
import 'package:dota2_invoker_game/widgets/crownfall_button.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid/reorderable_grid.dart';

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

class _ShopViewState extends State<ShopView> with ScreenStateMixin {

  static final _items = Items.values.where((element) => element.isVisibleInShop).toList();
  final advancedItems = _items.where((element) => element.itemType == ItemType.Advanced).toList();
  final basicItems = _items.where((element) => element.itemType == ItemType.Basic).toList();
  int selectedTabIndex = 1;
  final selectedColor = const Color(0xFF114C7C);
  final unSelectedColor = const Color(0xFF1C2834);

  List<Items> get getSelectedItems => selectedTabIndex == 0 ? basicItems : advancedItems;

  @override
  void initState() {
    SoundManager.instance.playShopEnterSound();
    super.initState();
  }

  @override
  void dispose() {
    SoundManager.instance.playShopExitSound();
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
                  color: Colors.black.withValues(alpha: 0.32),
                  border: Border.all(color: AppColors.amber.withValues(alpha: 0.72)),
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
                GestureDetector(
                  onLongPress: () {
                    if (context.read<BossBattleProvider>().inventory.length < 2) return;
                    showDialog<void>(
                      context: context, 
                      builder: (context) => const Dialog(
                        child: InventoryReorderDialog(),
                      ),
                    );
                  },
                  child: const InventoryHud(isItemsSellable: true),
                ),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTapDown: (details) {
            // Determine which side of the container was tapped
            if (details.localPosition.dx > constraints.biggest.width / 2) {
              setState(() => selectedTabIndex = 1);
            } else {
              setState(() => selectedTabIndex = 0);
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
            child: CustomPaint(
              foregroundPainter: TabPainter(),
              child: ClipPath(
                clipper: TabClipper(),
                child: Container(
                  height: context.dynamicWidth(0.125)+4,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff252a48),
                        Color(0xff161b23),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          buildTabBgText(0, LocaleKeys.Item_basic.locale),
                          buildTabBgText(1, LocaleKeys.Item_advanced.locale),
                        ],
                      ),
                      buildTabButton(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildTabButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AnimatedAlign(
            duration: Durations.medium2,
            alignment: selectedTabIndex == 0 ? Alignment.centerLeft : Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 6),
              child: CrownfallButton.normal(
                width: context.dynamicWidth(0.5),
                child: Text(
                  selectedTabIndex == 0 ? LocaleKeys.Item_basic.locale : LocaleKeys.Item_advanced.locale,
                  style: TextStyle(
                    fontSize: context.sp(11),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTabBgText(int index, String text) {
    return Expanded(
      child: Center(
        child: AnimatedOpacity(
          opacity: selectedTabIndex == index ? 0 : 1,
          duration: Durations.medium2,
          child: Text(
            text,
            style: TextStyle(
              fontSize: context.sp(11),
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
        TweenAnimationBuilder<int>(
          tween: IntTween(begin: gold, end: gold-(discount ?? 0)),
          duration: Durations.short1,
          builder: (context, value, child) {
            return AnimatedFlipCounter(
              duration: Durations.extralong2,
              value: value,
              textStyle: TextStyle(
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
        ),
        Image.asset(ImagePaths.gold, height: iconHeight),
      ],
    );
  }
}

class TabClipper extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    final double w = size.width;
    final double h = size.height;

    final tabPath = Path()
      ..moveTo((w * 0.05)+4, 0)
      ..lineTo(0, h / 2)
      ..lineTo((w * 0.05)+4, h)
      ..lineTo((w * 0.95)-4, h)
      ..lineTo(w, h / 2)
      ..lineTo((w * 0.95)-4, 0)
      ..close();

    return tabPath;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TabPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = TabClipper().getClip(size);
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..shader = ui.Gradient.linear(
        Offset(size.width / 2, 0),
        Offset(size.width / 2, size.height),
        [const Color(0xffe8e3d5), const Color(0xffad7f30)],
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class InventoryReorderDialog extends StatefulWidget {
  const InventoryReorderDialog({super.key});

  @override
  State<InventoryReorderDialog> createState() => _InventoryReorderDialogState();
}

class _InventoryReorderDialogState extends State<InventoryReorderDialog> with ScreenStateMixin {

  List<Item> items = [];
  @override
  void initState() {
    items = context.read<BossBattleProvider>().inventory;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableGridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      onReorder: (oldIndex, newIndex) {
        final item = items.removeAt(oldIndex);
        items.insert(newIndex, item);
        context.read<BossBattleProvider>().updateView();
        updateScreen();
      },
      childAspectRatio: 1,
      children: items.map((item) {
        return Padding(
          key: ValueKey(item),
          padding: const EdgeInsets.all(8),
          child: Image.asset(
            item.item.image,
            height: context.dynamicHeight(0.2),
          ),
        );
      }).toList(),
    );
  }
}
