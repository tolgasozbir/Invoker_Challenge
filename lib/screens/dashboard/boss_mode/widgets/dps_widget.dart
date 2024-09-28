import 'package:dota2_invoker_game/extensions/number_extension.dart';
import 'package:dota2_invoker_game/extensions/string_extension.dart';
import 'package:dota2_invoker_game/widgets/empty_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

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
      child: Selector<BossBattleProvider, Tuple3<double, double, double>>(
        selector: (_, provider) => Tuple3(provider.physicalPercentage, provider.magicalPercentage, provider.dps),
        builder: (_, value, __) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Dps Bar
            SizedBox(
              width: 100,
              height: 4,
              child: Row(
                children: [
                  Expanded(
                    flex: value.item1.round(),//provider.physicalPercentage.round(),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.horizontal(left: Radius.circular(2)),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: value.item2.round(),//provider.magicalPercentage.round(),
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
            Text('${LocaleKeys.bossBattleInfo_dps.locale.toLowerCase().capitalize()} : ${value.item3.numberFormat}'), //${provider.dps.numberFormat}'
          ],
        ),
      ),
    );
  }
}
