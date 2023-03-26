import 'package:dota2_invoker_game/constants/app_colors.dart';
import 'package:dota2_invoker_game/constants/app_strings.dart';
import 'package:dota2_invoker_game/enums/items.dart';
import 'package:dota2_invoker_game/extensions/context_extension.dart';
import 'package:dota2_invoker_game/extensions/widget_extension.dart';
import 'package:dota2_invoker_game/screens/dashboard/boss_mode/widgets/inventory_hud.dart';
import 'package:flutter/material.dart';

class ShopView extends StatefulWidget {
  const ShopView({super.key});

  @override
  State<ShopView> createState() => _ShopViewState();
}

class _ShopViewState extends State<ShopView> {
  Items? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            children: [
              Text(
                "128", 
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
              Image.asset(ImagePaths.gold),
            ],
          ),
        ],
      ),
      body: _bodyView(),
    );
  }

  Widget _bodyView() {
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          itemCount: Items.values.length,
          itemBuilder: (BuildContext context, int index) {
            var item = Items.values[index];
            return Tooltip(
              message: item.Description,
              triggerMode: TooltipTriggerMode.tap,
              showDuration: Duration(seconds: 5),
              onTriggered: () {
                selectedItem = item;
                setState(() {
                  
                });
              },
              child: Card(
                color: Colors.black.withOpacity(0.32),
                child: Image.asset(item.image)
              ),
            );
          },
        ).wrapPadding(EdgeInsets.all(8)),
        Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InventoryHud(),
              EmptyBox().wrapExpanded(),
            ],
          ),
        EmptyBox.h16(),
      ],
    );
  }
}