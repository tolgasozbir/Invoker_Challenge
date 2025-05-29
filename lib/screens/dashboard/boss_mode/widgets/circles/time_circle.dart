import 'package:dota2_invoker_game/constants/app_colors.dart';
import 'package:dota2_invoker_game/enums/local_storage_keys.dart';
import 'package:dota2_invoker_game/extensions/color_extension.dart';
import 'package:dota2_invoker_game/extensions/context_extension.dart';
import 'package:dota2_invoker_game/services/app_services.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../../../../providers/boss_battle_provider.dart';

class TimeCircle extends StatefulWidget {
  const TimeCircle({super.key});

  @override
  State<TimeCircle> createState() => _TimeCircleState();
}

class _TimeCircleState extends State<TimeCircle> {
  late final Color _colorPrimary;
  late final Color _colorSecondary;

  @override
  void initState() {
    super.initState();
    _loadColors();
  }

  void _loadColors() {
    final cache = AppServices.instance.localStorageService;
    final defaultColorValue = AppColors.circleColor.toARGB32(); 
    final cachedColorValue = cache.getValue<int>(LocalStorageKey.innerColor) ?? defaultColorValue;
    _colorPrimary = Color(cachedColorValue);
    _colorSecondary = _colorPrimary.darkerColor();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<BossBattleProvider, Tuple2<double, int>>(
      selector: (_, provider) => Tuple2(provider.timeProgress, provider.timeUnits),
      builder: (_, value, __) => CircularPercentIndicator(
        percent: (value.item1 / value.item2).clamp(0.0, 1.0),
        radius: context.dynamicHeight(0.13),
        lineWidth: 4,
        progressColor: _colorPrimary,
        backgroundColor: _colorSecondary,
        circularStrokeCap: CircularStrokeCap.butt,
      ),
    );
  }
}
