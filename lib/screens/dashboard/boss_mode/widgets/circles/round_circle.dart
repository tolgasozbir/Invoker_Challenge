import 'package:dota2_invoker_game/constants/app_colors.dart';
import 'package:dota2_invoker_game/enums/local_storage_keys.dart';
import 'package:dota2_invoker_game/extensions/color_extension.dart';
import 'package:dota2_invoker_game/extensions/context_extension.dart';
import 'package:dota2_invoker_game/services/app_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../../../../providers/boss_battle_provider.dart';
import 'dashed_circle.dart';

class RoundCircle extends StatefulWidget {
  const RoundCircle({super.key});

  @override
  State<RoundCircle> createState() => _RoundCircleState();
}

class _RoundCircleState extends State<RoundCircle> {
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
    final cachedColorValue = cache.getValue<int>(LocalStorageKey.middleColor) ?? defaultColorValue;
    _colorPrimary = Color(cachedColorValue);
    _colorSecondary = _colorPrimary.darkerColor();
  }
  
  @override
  Widget build(BuildContext context) {
    return Selector<BossBattleProvider, Tuple2<double, int>>(
      selector: (_, provider) => Tuple2(provider.roundProgress.toDouble() +1, provider.roundUnit),
      builder: (_, value, __) => DashedCircle(
        dashProgress: value.item1,
        dashUnits: value.item2,
        circleRadius: context.dynamicHeight(0.16),
        dashGap: 0.24,
        circleColor: _colorPrimary,
        circleColorSecondary: _colorSecondary,
        reversedColor: false,
      ),
    );
  }
}
