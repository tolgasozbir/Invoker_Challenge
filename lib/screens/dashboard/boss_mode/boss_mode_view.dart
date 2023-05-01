import 'dart:math';

import 'package:dota2_invoker_game/extensions/number_extension.dart';
import 'package:dota2_invoker_game/models/ability.dart';

import '../../../widgets/empty_box.dart';
import 'widgets/info_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:snappable_thanos/snappable_thanos.dart';
import 'package:splash/splash.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../enums/Bosses.dart';
import '../../../enums/elements.dart';
import '../../../enums/spells.dart';
import '../../../extensions/context_extension.dart';
import '../../../extensions/widget_extension.dart';
import '../../../mixins/orb_mixin.dart';
import '../../../providers/boss_provider.dart';
import '../../../services/sound_manager.dart';
import '../../../utils/spell_combination_checker.dart';
import '../../../widgets/app_snackbar.dart';
import '../../../widgets/bouncing_button.dart';
import '../../../widgets/cooldown_animation.dart';
import 'widgets/inventory_hud.dart';
import 'widgets/mana_bar.dart';
import 'widgets/shop_button.dart';
import 'widgets/sky/sky.dart';
import 'widgets/weather/weather.dart';

class BossModeView extends StatefulWidget {
  const BossModeView({super.key});

  @override
  State<BossModeView> createState() => _BossModeViewState();
}

class _BossModeViewState extends State<BossModeView> with OrbMixin {
  late BossProvider provider;
  final circleColor = const Color(0xFFB50DE2);

  final boxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    border: Border.all(strokeAlign: BorderSide.strokeAlignOutside),
    boxShadow: const [BoxShadow(blurRadius: 8)],
  );

  @override
  void initState() {
    provider = context.read<BossProvider>();
    provider.disposeGame();
    super.initState();
  }

  @override
  void dispose() {
    provider.disposeGame();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            if (backButtonFn()) Navigator.pop(context);
          },
        ),
        actions: [
          infoIcon(),
          const EmptyBox.w4(),
          const ShopButton(),
        ],
      ),
      body: WillPopScope(
        child: bodyView(),
        onWillPop: () async => backButtonFn(),
      ),
    );
  }

  bool backButtonFn() {
    final canPop = context.read<BossProvider>().snapIsDone && !context.read<BossProvider>().isHornSoundPlaying;
    if (!canPop) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      AppSnackBar.showSnackBarMessage(
        text: AppStrings.sbWaitAnimation, 
        snackBartype: SnackBarType.info,
      );
    }
    return canPop;
  }

  Widget infoIcon() {
    return IconButton(
      onPressed: () {
        final canClick = !context.read<BossProvider>().started && 
                         context.read<BossProvider>().snapIsDone && 
                        !context.read<BossProvider>().isHornSoundPlaying;
        if(canClick)
          Navigator.push(context, MaterialPageRoute(builder: (context) => const InfoView(),));
        else {
          SoundManager.instance.playMeepMerp();
        }
      },
      icon: const Icon(FontAwesomeIcons.questionCircle),
    );
  }

  Widget bodyView() {
    return Column(
      children: [
        Consumer<BossProvider>(
          builder: (context, provider, child) {
            final skyLight =  provider.currentBossAlive ? SkyLight.dark : SkyLight.light;
            final skyType = provider.roundProgress >= 6 ? SkyType.thunderstorm : SkyType.normal;
            final weatherType = provider.roundProgress >= 10 ? WeatherType.rainy : WeatherType.normal;
            return Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              Sky(skyLight: skyLight, skyType: skyType),
              ...circles(provider),
              bossHeads(provider),
              Weather(weatherType: weatherType),
              dpsText(provider),
              dpsStick(provider),
              attackDamage(provider),
              startBtn(provider),
            ],
          ).wrapExpanded();
          },
        ),
        selectedElementOrbs(),
        skills(),
        const EmptyBox.h12(),
        const ManaBar(),
        const EmptyBox.h8(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const InventoryHud(),
            abilitySlot().wrapExpanded(),
          ],
        ),
        const EmptyBox.h16(),
      ],
    );
  }

  List<Widget> circles(BossProvider provider) {
    return [
      //outer
      CustomPaint(
        painter: ArcPainter(
          progress: provider.healthProgress-1,
          units: provider.healthUnit,
          radius: context.dynamicHeight(0.19),
          gap: 0.22,
          color: circleColor,
          reversedColor: true,
        ),
      ),
      //middle
      CustomPaint(
        painter: ArcPainter(
          progress: provider.roundProgress.toDouble() +1,
          units: provider.roundUnit,
          radius: context.dynamicHeight(0.16),
          gap: 0.24,
          color: circleColor,
        ),
      ),
      //inner
      CustomPaint(
        painter: ArcPainter(
          progress: provider.timeProgress,
          units: provider.timeUnits,
          radius: context.dynamicHeight(0.13),
          gap: 0.2,
          color: circleColor,
        ),
      ),
    ];
  }

  Widget bossHeads(BossProvider provider) {
    return Snappable(
      key: provider.snappableKey,
      onSnapped: () => null,
      duration: const Duration(milliseconds: 3000),
      child: Opacity(
        opacity: provider.currentBossAlive ? 1 : 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: provider.currentBossAlive ? 1 : 2,
              curve: Curves.bounceOut,
              duration: const Duration(milliseconds: 1600),
              child: Image.asset(provider.currentBoss.getImage, height: context.dynamicHeight(0.18),),
            ),
            Text(provider.currentBossHp.numberFormat),
            Text(provider.currentBoss.getName),
          ],
        ).wrapCenter(),
      ),
    );
  }

  Positioned dpsStick(BossProvider provider) {
    return Positioned(
      top: 8,
      left: 8,
      child: SizedBox(
        width: 100,
        height: 4,
        child: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: AppColors.red,
                borderRadius: BorderRadius.horizontal(left: Radius.circular(2)),
              ),
            ).wrapExpanded(flex: provider.physicalPercentage.round()),
            Container(
              decoration: const BoxDecoration(
                color: AppColors.blue,
                borderRadius: BorderRadius.horizontal(right: Radius.circular(2)),
              ),
            ).wrapExpanded(flex: provider.magicalPercentage.round()),
          ],
        ),
      ),
    );
  }

  Positioned dpsText(BossProvider provider) {
    return Positioned(
      top: 16,
      left: 8,
      child: Row(
        children: [
          Text('Dps : ${provider.dps.numberFormat}'),
        ],
      ),
    );
  }
  
  Positioned attackDamage(BossProvider provider) {
    final baseDmg = provider.baseDamage;
    final multiplier = provider.damageMultiplier;
    final bonusDmg = provider.bonusDamage;
    return Positioned(
      top: 8,
      right: 8,
      child: Row(
        children: [
          Text((baseDmg + (baseDmg * multiplier)).numberFormat),
          if (provider.bonusDamage > 0)
            Text(
              '+${(bonusDmg + (bonusDmg * multiplier)).numberFormat}', 
              style: const TextStyle(color: AppColors.green),
            ),
          const EmptyBox.w4(),
          Image.asset(ImagePaths.icSword),
        ],
      ),
    );
  }

  InkWell startBtn(BossProvider provider) {
    final bool isStarted = provider.started;
    final bool snapIsDone = provider.snapIsDone;
    final bool isHornPlaying = provider.isHornSoundPlaying;
    final bool isWkReincarnated = provider.isWraithKingReincarnated;
    final bool status = isStarted || !snapIsDone || isWkReincarnated;
    return InkWell(
      splashFactory: WaveSplash.splashFactory,
      highlightColor: Colors.transparent,
      onTap: () {
        if (status) return;
        provider.startGame();
      },
      child: SizedBox.expand(
        child: AnimatedSwitcher(
          duration: const Duration(seconds: 1),
          child: status ? const EmptyBox() : isHornPlaying ? const Text('Starting') : const Text('Start'),
        ),
      ),
    );
  }

  Widget selectedElementOrbs() {
    return Consumer<BossProvider>(
      builder: (context, provider, child) => SizedBox(
        width: context.dynamicWidth(0.25),
        height: context.dynamicHeight(0.08),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: selectedOrbs,
        ),
      ),
    );
  }

  //QWER Ability Hud
  Row skills() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        Elements.values.length, 
        (index) => skill(Elements.values[index]).wrapPadding(const EdgeInsets.symmetric(horizontal: 8)),
      ),
    );
  }

  BouncingButton skill(Elements element) {
    return BouncingButton(
      child: Stack(
        children: [
          DecoratedBox(
            decoration: qwerAbilityDecoration(element.getColor),
            child: Image.asset(
              element.getImage,
              width: context.dynamicWidth(0.18),
            ),
          ),
          Text(
            element.getKey.toUpperCase(),
            style: TextStyle(
              color: element.getColor,
              fontSize: context.sp(16),
              fontWeight: FontWeight.w500,
              shadows: List.generate(3, (index) => const Shadow(blurRadius: 8)),
            ),
          ).wrapPadding(const EdgeInsets.only(left: 2)),
        ],
      ),
      onPressed: () {
        switch (element) {
          case Elements.quas:
          case Elements.wex:
          case Elements.exort:
            return switchOrb(element);
          case Elements.invoke:
            SoundManager.instance.playInvoke();
            Spells? castedSpell;
            for(final spell in Spells.values) {
              if (SpellCombinationChecker.checkEquality(spell.combine, currentCombination)) {
                castedSpell = spell;
                break;
              }
            }
            if (castedSpell == null) {
              SoundManager.instance.failCombinationSound();
              return;
            }
            final index = Spells.values.indexOf(castedSpell);
            final spell = context.read<BossProvider>().spellCooldowns[index];
            context.read<BossProvider>().switchAbility(spell);
        }
      },
    );
  }

  Widget abilitySlot() {
    return Consumer<BossProvider>(
      builder: (context, provider, child) {
        final castedAbilities = provider.castedAbility;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(2, (index) => castedAbilities.length < index + 1 ? emptyAbilitySlot() : DecoratedBox(
              decoration: boxDecoration,
              child: abilityButton(castedAbilities[index]),
            ),
          ).toList(),
        );
      },
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
        final provider = context.read<BossProvider>();
        provider.onPressedAbility(ability.spell);
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

class ArcPainter extends CustomPainter {
  final double progress;
  final int units;
  final double gap;
  final Color color;
  final double radius;
  final bool reversedColor;

  ArcPainter({
    required this.progress,
    required this.units,
    required this.radius,
    required this.gap,
    required this.color,
    this.reversedColor = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);
    const maskFiler = MaskFilter.blur(BlurStyle.solid, 2);

    // final gradient = new SweepGradient(
    //   startAngle: -pi / 2,
    //   endAngle: (-pi / 2) + (pi * 2),
    //   tileMode: TileMode.repeated,
    //   colors: this._gradient,
    // );

    final paintFilled = Paint()
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..maskFilter = maskFiler
      ..color = reversedColor ? color.withOpacity(0.2) : color;
    //..shader = gradient.createShader(rect);

    final paintEmpty = Paint()
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..maskFilter = maskFiler
      ..color = reversedColor ? color : color.withOpacity(0.2);

    for (var i = 0; i < units; i++) {
      final unit = 2 * pi / units;
      final start = unit * i;
      final to = ((2 * pi) / units) + unit;
      canvas.drawArc(
        rect, 
        -pi / 2 + start, 
        to * 2 * gap, 
        false,
        i < progress ? paintFilled : paintEmpty,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
