import 'package:dota2_invoker_game/extensions/context_extension.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../../../providers/boss_battle_provider.dart';
import 'dashed_circle.dart';

class TimeCircle extends StatelessWidget {
  const TimeCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BossBattleProvider>(
      builder: (context, provider, child) => DashedCircle(
        dashProgress: provider.timeProgress,
        dashUnits: provider.timeUnits,
        circleRadius: context.dynamicHeight(0.13),
        dashGap: 0.2,
        circleColor: const Color(0xFFB50DE2),
        reversedColor: false,
      ),
    );
  }
}
