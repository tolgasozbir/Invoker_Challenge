import 'package:dota2_invoker_game/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../../../../providers/boss_battle_provider.dart';
import 'dashed_circle.dart';

class RoundCircle extends StatelessWidget {
  const RoundCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<BossBattleProvider, Tuple2<double, int>>(
      selector: (_, provider) => Tuple2(provider.roundProgress.toDouble() +1, provider.roundUnit),
      builder: (_, value, __) => DashedCircle(
        dashProgress: value.item1,
        dashUnits: value.item2,
        circleRadius: context.dynamicHeight(0.16),
        dashGap: 0.24,
        //circleColor: const Color(0xFFB50DE2),
        reversedColor: false,
      ),
    );
  }
}
