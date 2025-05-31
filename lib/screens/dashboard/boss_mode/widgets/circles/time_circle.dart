import 'package:dota2_invoker_game/extensions/context_extension.dart';
import 'package:dota2_invoker_game/providers/color_settings_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../../../../providers/boss_battle_provider.dart';

class TimeCircle extends StatelessWidget {
  const TimeCircle({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<ColorSettingsProvider>();
    final radius = context.dynamicHeight(0.13);

    return Selector<BossBattleProvider, Tuple2<double, int>>(
      selector: (_, provider) => Tuple2(provider.timeProgress, provider.timeUnits),
      builder: (_, value, __) => CircularPercentIndicator(
        percent: (value.item1 / value.item2).clamp(0.0, 1.0),
        radius: radius,
        lineWidth: 4,
        progressColor: colors.timeProgressColor,
        backgroundColor: colors.timeBackgroundColor,
        circularStrokeCap: CircularStrokeCap.butt,
      ),
    );
  }
}
