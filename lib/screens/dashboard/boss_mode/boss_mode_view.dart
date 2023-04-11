import 'dart:math';
import '../../../constants/app_strings.dart';
import '../../../enums/Bosses.dart';
import '../../../enums/spells.dart';
import 'widgets/inventory_hud.dart';
import 'widgets/mana_bar.dart';
import '../../../utils/number_formatter.dart';
import '../../../widgets/app_snackbar.dart';
import 'package:snappable_thanos/snappable_thanos.dart';

import '../../../models/ability_cooldown.dart';
import '../../../widgets/cooldown_animation.dart';
import 'widgets/shop_button.dart';
import 'widgets/weather/weather.dart';

import '../../../constants/app_colors.dart';
import '../../../extensions/context_extension.dart';
import '../../../extensions/widget_extension.dart';
import '../../../providers/boss_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splash/splash.dart';

import '../../../enums/elements.dart';
import '../../../mixins/orb_mixin.dart';
import '../../../services/sound_manager.dart';
import '../../../widgets/bouncing_button.dart';
import 'widgets/sky/sky.dart';

class BossModeView extends StatefulWidget {
  const BossModeView({super.key});

  @override
  State<BossModeView> createState() => _BossModeViewState();
}

class _BossModeViewState extends State<BossModeView> with OrbMixin {
  late BossProvider provider;
  var gradient2 = [const Color(0xFFE20D17), const Color(0xFFB50DE2)];

  final boxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    border: Border.all(strokeAlign: BorderSide.strokeAlignOutside),
    boxShadow: [
      BoxShadow(
        color: AppColors.black,
        blurRadius: 8,
      ),
    ],
  );

  @override
  void initState() {
    provider = context.read<BossProvider>();
    //provider.disposeGame();
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
          if(!context.watch<BossProvider>().started && context.watch<BossProvider>().snapIsDone && !context.watch<BossProvider>().isHornSoundPlaying) ShopButton(),
        ],
      ),
      body: WillPopScope(
        child: bodyView(),
        onWillPop: () async => backButtonFn(),
      ),
    );
  }

  bool backButtonFn() {
    var canPop = context.read<BossProvider>().snapIsDone && !context.read<BossProvider>().isHornSoundPlaying;
    if (!canPop) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      AppSnackBar.showSnackBarMessage(
        text: AppStrings.sbWaitAnimation, 
        snackBartype: SnackBarType.info
      );
    }
    return canPop;
  }

  Widget bodyView() {
    var skyLight = context.watch<BossProvider>().currentBossAlive ? SkyLight.dark : SkyLight.light;
    var skyType = SkyType.normal; // normal ile başlıcak sunny olcak sonlara doğru thunder
    var weatherType = WeatherType.normal; // son 2 3 round rainy olcak
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Sky(skyLight: skyLight, skyType: skyType),
            ...circles(),
            bossHeads(),
            Weather(weatherType: weatherType),
            dpsText(),
            dpsStick(),
            startBtn(),
          ],
        ).wrapExpanded(),
        selectedElementOrbs(),
        skills(),
        EmptyBox.h12(),
        ManaBar(),
        EmptyBox.h8(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InventoryHud(),
            abilitySlot().wrapExpanded(),
          ],
        ),
        EmptyBox.h16(),
      ],
    );
  }

  Positioned dpsStick() {
    return Positioned(
      top: 8,
      left: 8,
      child: SizedBox(
        width: 100,
        height: 4,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.red,
                borderRadius: BorderRadius.horizontal(left: Radius.circular(2))
              ),
            ).wrapExpanded(flex: context.watch<BossProvider>().physicalPercentage.round()),
            Container(
              decoration: BoxDecoration(
                color: AppColors.blue,
                borderRadius: BorderRadius.horizontal(right: Radius.circular(2))
              ),
            ).wrapExpanded(flex: context.watch<BossProvider>().magicalPercentage.round()),
          ],
        ),
      ),
    );
  }

  Positioned dpsText() {
    return Positioned(
      top: 16,
      left: 8,
      child: Row(
        children: [
          Text("Dps : " + priceString(context.watch<BossProvider>().dps)),
        ],
      )
    );
  }

  InkWell startBtn() {
    bool isStarted = context.watch<BossProvider>().started;
    bool snapIsDone = context.watch<BossProvider>().snapIsDone;
    bool isHornPlaying = context.watch<BossProvider>().isHornSoundPlaying;
    bool status = isStarted || !snapIsDone;
    return InkWell(
      splashFactory: WaveSplash.splashFactory,
      highlightColor: Colors.transparent,
      onTap: () {
        if (status) return;
        context.read<BossProvider>().startGame();
      },
      child: SizedBox.expand(
        child: AnimatedSwitcher(
          duration: Duration(seconds: 1),
          child: status ? EmptyBox() : isHornPlaying ? Text("Starting") : Text("Start"),
        ),
      ),
    );
  }

  Widget bossHeads() {
    var provider = context.watch<BossProvider>();
    return Snappable(
      key: provider.snappableKey,
      onSnapped: () => null,
      duration: Duration(milliseconds: 3000),
      child: Opacity(
        opacity: provider.currentBossAlive ? 1 : 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: provider.currentBossAlive ? 1 : 2,
              curve: Curves.bounceOut,
              duration: Duration(milliseconds: 1600),
              child: Image.asset(provider.currentBoss.getImage, height: context.dynamicHeight(0.18),)
            ),
            Text(priceString(provider.currentBossHp)),
            Text(provider.currentBoss.getName),
          ],
        ).wrapCenter(),
      ),
    );
  }

  List<Widget> circles() {
    return [
      //outer
      CustomPaint(
        painter: ArcPainter(
          progress: context.watch<BossProvider>().healthProgress-1,
          units: context.read<BossProvider>().healthUnit,
          radius: context.dynamicHeight(0.19),
          gap: 0.22,
          gradient: gradient2,
          reversedColor: true,
        ),
      ),
      //middle
      CustomPaint(
        painter: ArcPainter(
          progress: context.watch<BossProvider>().roundProgress.toDouble() +1,
          units: context.read<BossProvider>().roundUnit,
          radius: context.dynamicHeight(0.16),
          gap: 0.24,
          gradient: gradient2,
        ),
      ),
      //inner
      CustomPaint(
        painter: ArcPainter(
          progress: context.watch<BossProvider>().timeProgress,
          units: context.read<BossProvider>().timeUnits,
          radius: context.dynamicHeight(0.13),
          gap: 0.2,
          gradient: gradient2,
        ),
      ),
    ];
  }

  SizedBox selectedElementOrbs() {
    return SizedBox(
      width: context.dynamicWidth(0.25),
      height: context.dynamicHeight(0.08),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: selectedOrbs,
      ),
    );
  }

  //QWER Ability Hud
  Row skills() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(Elements.values.length, (index) => skill(Elements.values[index]).wrapPadding(EdgeInsets.symmetric(horizontal: 8)),
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
              shadows: List.generate(3, (index) => Shadow(blurRadius: 8)),
            ),
          ).wrapPadding(EdgeInsets.only(left: 2)),
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
            var castedSpell = null;
            for(Spells spell in Spells.values) {
              if (spell.combine == currentCombination) {
                castedSpell = spell;
                break;
              }
            }
            if (castedSpell == null) {
              SoundManager.instance.failCombinationSound();
              return;
            }
            var index = Spells.values.indexOf(castedSpell);
            var spell = context.read<BossProvider>().SpellCooldowns[index];
            context.read<BossProvider>().switchAbility(spell);
        }
      },
    );
  }

  Widget abilitySlot() {
    var castedAbilities = context.watch<BossProvider>().castedAbility;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(2, (index) => castedAbilities.length < index + 1 ? emptyAbilitySlot() : DecoratedBox(
          decoration: boxDecoration,
          child: abilityButton(castedAbilities[index]),
        ),
      ).toList(),
    );
  }

  BouncingButton abilityButton(AbilityCooldown abilityCooldown) {
    return BouncingButton(
      child: CooldownAnimation(
        key: ObjectKey(abilityCooldown.spell),
        duration: Duration(seconds: abilityCooldown.spell.cooldown.toInt()),
        remainingCd: abilityCooldown.cooldownLeft,
        size: context.dynamicWidth(0.2),
        child: Stack(
          children: [
            Image.asset(
              abilityCooldown.spell.image, 
              width: context.dynamicWidth(0.2)
            ).wrapClipRRect(BorderRadius.circular(8)),
            Positioned(
              bottom: 0,
              right: 0,
              child: Text(
                abilityCooldown.spell.mana.toStringAsFixed(0),
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: context.sp(16),
                  fontWeight: FontWeight.w500,
                  shadows: List.generate(6, (index) => Shadow(blurRadius: 8)),
                ),
              ).wrapPadding(EdgeInsets.only(right: 4)),
            ),
          ],
        ),
      ),
      onPressed: () {
        var provider = context.read<BossProvider>();
        provider.onPressedAbility(abilityCooldown.spell);
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
        child: DecoratedBox(
          decoration: const BoxDecoration(
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
  final List<Color> gradient;
  final double radius;
  final bool reversedColor;

  ArcPainter({
    required this.progress,
    required this.units,
    required this.radius,
    required this.gap,
    required this.gradient,
    this.reversedColor = false
  });

  @override
  void paint(Canvas canvas, Size size) {
    var center = Offset(size.width / 2, size.height / 2);
    var rect = Rect.fromCircle(center: center, radius: radius);
    final maskFiler = MaskFilter.blur(BlurStyle.solid, 2);

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
      ..color = reversedColor ? gradient.last.withOpacity(0.2) : gradient.last;
    //..shader = gradient.createShader(rect);

    final paintEmpty = Paint()
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..maskFilter = maskFiler
      ..color = reversedColor ? gradient.last : gradient.last.withOpacity(0.2);

    for (var i = 0; i < units; i++) {
      final double unit = 2 * pi / units;
      double start = unit * i;
      double to = (((2 * pi) / units) + unit);
      canvas.drawArc(
        rect, 
        (-pi / 2 + start), 
        (to * 2 * gap), 
        false,
        i < progress ? paintFilled : paintEmpty
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
