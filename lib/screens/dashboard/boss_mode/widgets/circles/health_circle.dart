import 'package:dota2_invoker_game/extensions/context_extension.dart';
import 'package:dota2_invoker_game/providers/color_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../../../../providers/boss_battle_provider.dart';

class HealthCircle extends StatelessWidget {
  const HealthCircle({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<ColorSettingsProvider>();
    final radius = context.dynamicHeight(0.19);

    return Selector<BossBattleProvider, Tuple2<double, int>>(
      selector: (_, provider) => Tuple2(provider.healthProgress, provider.healthUnit),
      builder: (_, value, __) => CircularPercentIndicator(
        percent: (value.item1 / value.item2).clamp(0.0, 1.0),
        radius: radius,
        lineWidth: 4,
        progressColor: colors.healthBackgroundColor,
        backgroundColor: colors.healthProgressColor,
        circularStrokeCap: CircularStrokeCap.butt,
      ),
    );
  }
}
