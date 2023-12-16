import 'package:dota2_invoker_game/extensions/number_extension.dart';
import 'package:dota2_invoker_game/extensions/string_extension.dart';
import 'package:dota2_invoker_game/widgets/empty_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/locale_keys.g.dart';
import '../../../../providers/boss_battle_provider.dart';

class DpsWidget extends StatelessWidget {
  const DpsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8,
      left: 8,
      child: Consumer<BossBattleProvider>(
        builder: (context, provider, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Dps Bar
            SizedBox(
              width: 100,
              height: 4,
              child: Row(
                children: [
                  Expanded(
                    flex: provider.physicalPercentage.round(),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.horizontal(left: Radius.circular(2)),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: provider.magicalPercentage.round(),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.blue,
                        borderRadius: BorderRadius.horizontal(right: Radius.circular(2)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const EmptyBox.h4(),
            //Dps Text
            Text('${LocaleKeys.bossBattleInfo_dps.locale.toLowerCase().capitalize()} : ${provider.dps.numberFormat}'),
          ],
        ),
      ),
    );
  }
}
