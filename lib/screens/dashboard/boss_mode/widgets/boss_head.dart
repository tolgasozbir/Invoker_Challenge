import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:snappable_thanos/snappable_thanos.dart';
import 'package:tuple/tuple.dart';

import '../../../../enums/Bosses.dart';
import '../../../../extensions/context_extension.dart';
import '../../../../extensions/number_extension.dart';
import '../../../../providers/boss_battle_provider.dart';

class BossHead extends StatelessWidget {
  const BossHead({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<BossBattleProvider, Tuple3<GlobalKey<SnappableState>, bool, Bosses>>(
      selector: (_, provider) => Tuple3(provider.snappableKey, provider.currentBossAlive, provider.currentBoss),
      builder: (_, value, __) => Snappable(
        key: value.item1,
        onSnapped: () => null,
        duration: const Duration(milliseconds: 3000),
        child: Opacity(
          opacity: value.item2 ? 1 : 0,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Boss Head Image
                AnimatedScale(
                  scale:  value.item2 ? 1 : 2,
                  curve: Curves.bounceOut,
                  duration: const Duration(milliseconds: 1600),
                  child: Image.asset(value.item3.getImage, height: context.dynamicHeight(0.18),),
                ),
                //Boss Hp
                Consumer<BossBattleProvider>(
                  builder: (context, provider1, child) => Text(provider1.currentBossHp.numberFormat),
                ),
                //Boss Name
                Text(value.item3.getReadableName),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
