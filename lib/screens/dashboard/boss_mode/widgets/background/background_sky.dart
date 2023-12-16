import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../../../../providers/boss_battle_provider.dart';
import 'sky/sky.dart';

class BackgroundSky extends StatelessWidget {
  const BackgroundSky({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<BossBattleProvider, Tuple2<bool, int>>(
      selector: (_, provider) => Tuple2(provider.currentBossAlive, provider.roundProgress),
      builder: (_, value, __) => Sky(
        skyLight: value.item1 ? SkyLight.dark : SkyLight.light, 
        skyType: value.item2 >= 6 ? SkyType.thunderstorm : SkyType.normal,
      ),
    );
  }
}
