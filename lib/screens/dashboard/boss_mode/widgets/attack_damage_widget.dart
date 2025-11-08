import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_image_paths.dart';
import '../../../../extensions/number_extension.dart';
import '../../../../providers/boss_battle_provider.dart';
import '../../../../widgets/empty_box.dart';

class AttackDamageWidget extends StatelessWidget {
  const AttackDamageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8,
      right: 8,
      child: Selector<BossBattleProvider, Tuple3<int,double,double>>(
        selector: (_, provider) => Tuple3(provider.baseDamage, provider.damageMultiplier, provider.bonusDamage),
        builder: (_, value, __) => Row(
          children: [
            Text((value.item1 + (value.item1 * value.item2)).numberFormat),
            if (value.item3 > 0)
              Text(
                '+${(value.item3 + (value.item3 * value.item2)).numberFormat}', 
                style: const TextStyle(color: AppColors.green),
              ),
            const EmptyBox.w4(),
            const Image(image: AssetImage(ImagePaths.icSword)),
          ],
        ),
      ),
    );
  }
}
