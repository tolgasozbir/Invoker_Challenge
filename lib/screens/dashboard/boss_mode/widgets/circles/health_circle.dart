import 'package:dota2_invoker_game/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../providers/boss_battle_provider.dart';
import 'dashed_circle.dart';

class HealthCircle extends StatelessWidget {
  const HealthCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BossBattleProvider>(
      builder: (context, provider, child) => DashedCircle(
        dashProgress: provider.healthProgress-1,
        dashUnits: provider.healthUnit,
        circleRadius: context.dynamicHeight(0.19),
        dashGap: 0.22,
        //circleColor: const Color(0xFFB50DE2),
        reversedColor: true,
      ),
    );
  }
}
