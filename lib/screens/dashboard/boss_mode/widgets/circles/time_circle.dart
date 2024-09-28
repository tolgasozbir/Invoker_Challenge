import 'package:dota2_invoker_game/constants/app_colors.dart';
import 'package:dota2_invoker_game/extensions/context_extension.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../../../../providers/boss_battle_provider.dart';

class TimeCircle extends StatelessWidget {
  const TimeCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<BossBattleProvider, Tuple2<double, int>>(
      selector: (_, provider) => Tuple2(provider.timeProgress, provider.timeUnits),
      builder: (_, value, __) => CircularPercentIndicator(
        percent: value.item1 / value.item2,
        radius: context.dynamicHeight(0.13),
        lineWidth: 4,
        progressColor: AppColors.circleColor,
        backgroundColor: AppColors.circleColorSecondary,
        circularStrokeCap: CircularStrokeCap.butt,
      ),
      // builder: (_, value, __) => DashedCircle(
      //   dashProgress: value.item1,
      //   dashUnits: value.item2,
      //   circleRadius: context.dynamicHeight(0.13),
      //   dashGap: 0.2,
      //   //circleColor: const Color(0xFFB50DE2),
      //   reversedColor: false,
      // ),
    );
  }
}
