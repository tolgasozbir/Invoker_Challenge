import 'package:dota2_invoker_game/enums/spells.dart';
import 'package:dota2_invoker_game/extensions/context_extension.dart';
import 'package:dota2_invoker_game/extensions/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../../../models/ability.dart';
import '../../../../providers/boss_battle_provider.dart';
import '../../../../widgets/bouncing_button.dart';
import '../../../../widgets/cooldown_animation.dart';

class AbilitySlot extends StatefulWidget {
  const AbilitySlot({super.key});

  @override
  State<AbilitySlot> createState() => _AbilitySlotState();
}

class _AbilitySlotState extends State<AbilitySlot> {
  @override
  Widget build(BuildContext context) {
    return Selector<BossBattleProvider, Tuple3<List<Ability>, bool, bool>>(
      selector: (_, provider) => Tuple3(provider.castedAbility, provider.abilitySwitch, provider.triggerView),
      builder: (_, value, __) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(2, (index) => value.item1.length < index + 1 ? emptyAbilitySlot() : DecoratedBox(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(strokeAlign: BorderSide.strokeAlignOutside),
                boxShadow: const [BoxShadow(blurRadius: 8)],
              ),
            child: abilityButton(value.item1[index]),
          ),
        ).toList(),
      ),
    );
  }

  BouncingButton abilityButton(Ability ability) {
    return BouncingButton(
      child: CooldownAnimation(
        key: ObjectKey(ability.spell),
        duration: Duration(seconds: ability.spell.cooldown.toInt()),
        remainingCd: ability.getRemainingCooldownTime,
        size: context.dynamicWidth(0.2),
        child: Stack(
          children: [
            Image.asset(
              ability.spell.image, 
              width: context.dynamicWidth(0.2),
            ).wrapClipRRect(BorderRadius.circular(8)),
            Positioned(
              bottom: 0,
              right: 0,
              child: Text(
                ability.spell.mana.toStringAsFixed(0),
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: context.sp(16),
                  fontWeight: FontWeight.w500,
                  shadows: List.generate(6, (index) => const Shadow(blurRadius: 8)),
                ),
              ).wrapPadding(const EdgeInsets.only(right: 4)),
            ),
          ],
        ),
      ),
      onPressed: () {
        final provider = context.read<BossBattleProvider>();
        provider.onPressedAbility(ability.spell);
        setState(() {});
      },
    );
  }


  Widget emptyAbilitySlot() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        gradient: LinearGradient(
          colors: [Color(0xFF37596D), Color(0xFF244048), Color(0xFF2B5167)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SizedBox(
        width: context.dynamicWidth(0.2),
        height: context.dynamicWidth(0.2),
        child: const DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            gradient: LinearGradient(
              colors: [Color(0xFF1A222B), Color(0xFF1F2B37)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
    );
  }












}
