import 'package:dota2_invoker_game/constants/app_strings.dart';
import 'package:dota2_invoker_game/extensions/widget_extension.dart';
import 'package:dota2_invoker_game/providers/boss_battle_provider.dart';
import 'package:dota2_invoker_game/utils/game_save_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../enums/Bosses.dart';
import '../../enums/items.dart';
import '../../models/Item.dart';
import '../app_outlined_button.dart';
import '../empty_box.dart';

class LoadGameDialogContent extends StatelessWidget {
  const LoadGameDialogContent({super.key, required this.savedGame});

  final SaveProps savedGame;

  @override
  Widget build(BuildContext context) {
    final items = savedGame.inventoryItems.map((e) => Items.values.byName(e)).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        nextBossImage(),
        itemImages(items),
        if (items.isEmpty) const EmptyBox.h32(),
        buttons(context),
      ],
    );
  }

  Row nextBossImage() {
    return Row(
      children: [
        const Text('${AppStrings.nextBoss} : ', style: TextStyle(fontWeight: FontWeight.w500)),
        Image.asset(Bosses.values[savedGame.roundProgress+1].getImage, height: 48,),
      ],
    );
  }

  Row itemImages(List<Items> items) {
    return Row(
      children: [
        const Text('${AppStrings.items} : ', style: TextStyle(fontWeight: FontWeight.w500),),
        for (var i = 0; i < 6; i++)
          i < items.length ? Image.asset(items[i].image, height: 48).wrapExpanded() : const EmptyBox().wrapExpanded(),
      ],
    );
  }

  Row buttons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        loadSaveButton(context).wrapExpanded(),
        const EmptyBox.w16(),
        backButton(context).wrapExpanded(),
      ],
    );
  }

  AppOutlinedButton loadSaveButton(BuildContext context) {
    return AppOutlinedButton(
      title: AppStrings.loadGame, 
      onPressed: () {
        final provider = context.read<BossBattleProvider>();
        provider.roundProgress = savedGame.roundProgress;
        provider.userGold = savedGame.userGold;
        for (final e in savedGame.inventoryItems) {
          final item = Items.values.byName(e);
          provider.addItemToInventory(Item(item: item));
        }
        Navigator.pop(context);
      },
    );
  }

  AppOutlinedButton backButton(BuildContext context) {
    return AppOutlinedButton(
      title: '${AppStrings.back} (${AppStrings.delete})', 
      onPressed: () {
        GameSaveHandler.instance.deleteSavedGame();
        Navigator.pop(context);
      },
    );
  }
}
