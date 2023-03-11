import 'dart:math';
import 'package:dota2_invoker_game/screens/dashboard/boss_mode/components/animated_dps_text.dart';

import '../../../constants/app_colors.dart';
import '../../../extensions/context_extension.dart';
import '../../../extensions/widget_extension.dart';
import '../../../models/spell.dart';
import '../../../providers/boss_provider.dart';
import '../../../providers/spell_provider.dart';
import 'components/shop_button.dart';
import 'components/weather/weather.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splash/splash.dart';

import '../../../enums/elements.dart';
import '../../../mixins/orb_mixin.dart';
import '../../../services/sound_manager.dart';
import '../../../widgets/bouncing_button.dart';
import 'components/sky/sky.dart';

class BossModeView extends StatefulWidget {
  const BossModeView({super.key});

  @override
  State<BossModeView> createState() => _BossModeViewState();
}

class _BossModeViewState extends State<BossModeView> with OrbMixin {
  late BossProvider provider;
  var gradient2 = [const Color(0xFFE20D17), const Color(0xFFB50DE2)];
  List<Spell> spellList = [];
  AnimationController? dpsController;

  @override
  void initState() {
    provider = context.read<BossProvider>();
    spellList = context.read<SpellProvider>().getSpellList;
    super.initState();
  }

  @override
  void dispose() {
    provider.disposeTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appscaffold action parametresi alcak
      appBar: AppBar(
        actions: [
          ShopButton(),
        ],
      ),
      body: bodyView(),
    );
  }

  Widget bodyView() {
    var skyLight = SkyLight.light;
    var skyType = SkyType.normal;
    var weatherType = WeatherType.normal;
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          EmptyBox(),
          Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              Sky(skyLight: skyLight, skyType: skyType),
              ...circles(constraints),
              Weather(weatherType: weatherType),
              startBtn(context, constraints),
          AnimatedDPSText(controller: (contoller) => dpsController = contoller,),
            ],
          ).wrapExpanded(),
          selectedElementOrbs(),
          skills(),
          EmptyBox.h12(),
          manaBar(),
          EmptyBox.h8(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              inventoryHud(),
              ability().wrapExpanded(),
            ],
          ),
          EmptyBox.h16(),
        ],
      );
    });
  }

  InkWell startBtn(BuildContext context, BoxConstraints constraints) {
    return InkWell(
      splashFactory: WaveSplash.splashFactory,
      highlightColor: Colors.transparent,
      onTap: () {
        context.read<BossProvider>().startGame();
        context.read<BossProvider>().setDpsController(dpsController!);
        //dpsController?.repeat();
      },
      child: SizedBox(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: Text("Start").wrapCenter(),
      ),
    );
  }

  List<Widget> circles(BoxConstraints constraints) {
    return [
      //outer
      CustomPaint(
        painter: ArcPainter(
          progress: context.watch<BossProvider>().healthProgress,
          units: context.read<BossProvider>().healthUnit,
          radius: constraints.maxHeight * 0.21,
          gap: 0.22,
          gradient: gradient2,
          reversedColor: true,
        ),
      ),
      //middle
      CustomPaint(
        painter: ArcPainter(
          progress: context.watch<BossProvider>().roundProgress,
          units: context.read<BossProvider>().roundUnit,
          radius: constraints.maxHeight * 0.18,
          gap: 0.24,
          gradient: gradient2,
        ),
      ),
      //inner
      CustomPaint(
        painter: ArcPainter(
          progress: context.watch<BossProvider>().timeProgress,
          units: context.read<BossProvider>().timeUnits,
          radius: constraints.maxHeight * 0.15,
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
            SoundManager.instance.trueCombinationSound(currentCombination);
            var castedSpell = spellList.firstWhere((element) => element.combine.toString() == currentCombination.toString(), orElse: () => const Spell("", []));
            if (castedSpell.combine.isEmpty) return;
            context.read<BossProvider>().switchAbility(castedSpell);

          //context.watch<BossProvider>().castedAbility.add();
        }
        print(element.name);
      },
    );
  }

  Widget manaBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      padding: EdgeInsets.symmetric(horizontal: 8),
      width: double.infinity,
      height: context.dynamicHeight(0.048),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: LinearGradient(
          colors: [
          Color.fromARGB(255, 30, 136, 222),
          Color.fromARGB(255, 54, 104, 190)
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Spacer(),
          Text("1007/1007", style: TextStyle(fontSize: context.sp(12), fontWeight: FontWeight.bold)).wrapCenter().wrapExpanded(),
          Text("+6.3", style: TextStyle(fontSize: context.sp(12), fontWeight: FontWeight.bold)).wrapAlign(Alignment.centerRight).wrapExpanded(),
        ],
      ),
    );
  }

  Widget ability() {
    var castedAbility = context.watch<BossProvider>().castedAbility;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(2,(index) => BouncingButton(
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border:
                Border.all(strokeAlign: BorderSide.strokeAlignOutside),
            boxShadow: [
              BoxShadow(
                color: AppColors.black,
                blurRadius: 8,
              ),
            ],
          ),
          child: castedAbility.length < index + 1
              ? emptyAbilitySlot()
              : Image.asset(castedAbility[index].image,
                      width: context.dynamicWidth(0.2))
                  .wrapClipRRect(BorderRadius.circular(8)),
        ),
        onPressed: () {
          print("aa");
          print(castedAbility[index].combine);
        },
      )).toList(),
    );
  }

  Widget inventoryHud() {
    return Container(
      margin: EdgeInsets.only(left: 24),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [Color(0xFF37596D), Color(0xFF244048), Color(0xFF2B5167)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              emptySlot(),
              EmptyBox.w4(),
              emptySlot(),
              EmptyBox.w4(),
              emptySlot(),
            ],
          ),
          EmptyBox.h4(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              emptySlot(),
              EmptyBox.w4(),
              emptySlot(),
              EmptyBox.w4(),
              emptySlot(),
            ],
          ),
        ],
      ),
    );
  }

  Container emptySlot() {
    return Container(
      width: context.dynamicWidth(0.12),
      height: context.dynamicWidth(0.12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        gradient: LinearGradient(
          colors: [Color(0xFF1A222B), Color(0xFF1F2B37)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget emptyAbilitySlot() {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [Color(0xFF37596D), Color(0xFF244048), Color(0xFF2B5167)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Container(
        width: context.dynamicWidth(0.2),
        height: context.dynamicWidth(0.2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          gradient: LinearGradient(
            colors: [Color(0xFF1A222B), Color(0xFF1F2B37)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
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
