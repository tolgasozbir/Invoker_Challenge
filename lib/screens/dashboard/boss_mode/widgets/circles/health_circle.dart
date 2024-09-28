import 'package:dota2_invoker_game/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../../../../providers/boss_battle_provider.dart';
import 'dashed_circle.dart';

class HealthCircle extends StatelessWidget {
  const HealthCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<BossBattleProvider, Tuple2<double, int>>(
      selector: (_, provider) => Tuple2(provider.healthProgress -1, provider.healthUnit),
      builder: (_, value, __) => DashedCircle(
        dashProgress: value.item1,  //provider.healthProgress-1,
        dashUnits: value.item2,       //provider.healthUnit,
        circleRadius: context.dynamicHeight(0.19),
        dashGap: 0.22,
        //circleColor: const Color(0xFFB50DE2),
        reversedColor: true,
      ),
    );
  }
}
