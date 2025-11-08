import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../../../../extensions/context_extension.dart';
import '../../../../../providers/boss_battle_provider.dart';
import '../../../../../providers/color_settings_provider.dart';
import 'dashed_circle.dart';

class RoundCircle extends StatelessWidget {
  const RoundCircle({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<ColorSettingsProvider>();
    final radius = context.dynamicHeight(0.16);

    return Selector<BossBattleProvider, Tuple2<double, int>>(
      selector: (_, provider) => Tuple2(provider.roundProgress.toDouble() +1, provider.roundUnit),
      builder: (_, value, __) => DashedCircle(
        dashProgress: value.item1,
        dashUnits: value.item2,
        circleRadius: radius,
        dashGap: 0.24,
        circleColor: colors.roundProgressColor,
        circleColorSecondary: colors.roundBackgroundColor,
        reversedColor: false,
      ),
    );
  }
}
