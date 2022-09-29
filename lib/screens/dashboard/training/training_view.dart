import 'package:dota2_invoker/constants/app_colors.dart';
import 'package:dota2_invoker/constants/app_strings.dart';
import 'package:dota2_invoker/services/sound_service.dart';
import 'package:dota2_invoker/extensions/context_extension.dart';
import 'package:dota2_invoker/providers/spell_provider.dart';
import 'package:dota2_invoker/providers/timer_provider.dart';
import 'package:dota2_invoker/screens/dashboard/training/training_view_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../enums/elements.dart';
import '../../../widgets/big_spell_picture.dart';
import '../../../widgets/spells_helper_widget.dart';
import '../../../widgets/trueFalseWidget.dart';

class TrainingView extends StatefulWidget {
  const TrainingView({Key? key}) : super(key: key);

  @override
  State<TrainingView> createState() => _TrainingViewState();
}

class _TrainingViewState extends TrainingViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyView(),
    );
  }

  Widget _bodyView() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            counters(),
            showAllSpells ? SpellsHelperWidget() : SizedBox.shrink(),
            trueFalseIcons(),
            BigSpellPicture(image: isStart ? context.watch<SpellProvider>().getNextSpellImage : ImagePaths.spellImage),
            selectedElementOrbs(),
            skills(),
            startButton(),
          ],
        ),
      ),
    );
  }

  //Counters

  SizedBox counters(){
    return SizedBox(
      width: double.infinity,
      height: context.dynamicHeight(0.12),
      child: Stack(
        children: [
          correctCounter(),
          timerCounter(),
          showSpells(),
          clickPerSecond(),
          skillCastPerSecond(),
        ],
      ),
    );
  }

  Center correctCounter() {
    return Center(
      child: Text(
        context.watch<TimerProvider>().getCorrectCombinationCount.toString(),
        style: TextStyle(fontSize: context.sp(36), color: AppColors.trainingCounterColor,),
      )
    );
  }

  Positioned timerCounter() {
    return Positioned(
      right: context.dynamicWidth(0.02),
      top: context.dynamicWidth(0.02),
      child: Text(
        '${context.watch<TimerProvider>().getTimeValue} ${AppStrings.secPassed}', 
        style: TextStyle(fontSize: context.sp(12),)
      ),
    );
  }

  Positioned showSpells() {
    return Positioned(
      right: context.dynamicWidth(0.02), 
      top: context.dynamicWidth(0.08), 
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: SizedBox.square(
          dimension: context.dynamicWidth(0.08),
          child: Icon(FontAwesomeIcons.questionCircle,color: AppColors.questionMarkColor)
        ),
        onTap: ()=> setState(()=> showAllSpells = !showAllSpells),
      ),
    );
  }

  Positioned clickPerSecond() {
    return Positioned(
      left: context.dynamicWidth(0.02),
      top: context.dynamicWidth(0.02),
      child: Tooltip(
        message: '${AppStrings.toolTipCPS}',
        child: Text(
          context.watch<TimerProvider>().calculateCps.toStringAsFixed(1) + '${AppStrings.cps}',
          style: TextStyle(fontSize: context.sp(12),)
        ),
      ),
    );
  }

  Positioned skillCastPerSecond() {
    return Positioned(
      left: context.dynamicWidth(0.02),
      top: context.dynamicWidth(0.08),
      child: Tooltip(
        message: '${AppStrings.toolTipSCPS}',
        child: Text(
          context.watch<TimerProvider>().calculateScps.toStringAsFixed(1) + '${AppStrings.scps}',
          style: TextStyle(fontSize: context.sp(12),),
        ),
      ),
    );
  }


  Padding trueFalseIcons() {
    return Padding(
      padding: showAllSpells == false 
        ? EdgeInsets.only(top: context.dynamicHeight(0.12)) 
        : EdgeInsets.zero,
      child: TrueFalseWidget(key: globalAnimKey), 
    );
  }

  // Orbs

  SizedBox selectedElementOrbs() {
    return SizedBox(
      width: context.dynamicWidth(0.25),
      height: context.dynamicHeight(0.10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: selectedOrbs,
      ),
    );
  }

  // Skill cast

  Padding skills() {
    return Padding(
      padding: EdgeInsets.only(top: context.dynamicHeight(0.03)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          skill(Elements.quas),
          skill(Elements.wex),
          skill(Elements.exort),
          skill(Elements.invoke),
        ],
      ),
    );
  }

  InkWell skill(Elements element) {
    return InkWell(
      child: DecoratedBox(
        decoration: skillBlackShadowDec,
        child: Image.asset(element.getImage,width: context.dynamicWidth(0.20))
      ),
      onTap: () => skillOnTapFN(element),
    );
  }

  void skillOnTapFN(Elements element){
    var spellProvider = context.read<SpellProvider>();
    var timerProvider = context.read<TimerProvider>();
    switch (element) {
      case Elements.quas:
      case Elements.wex:
      case Elements.exort:
        return switchOrb(element);
      case Elements.invoke:
        if(!isStart) return;
        if (currentCombination.toString() == spellProvider.getNextCombination.toString()) {
          timerProvider.increaseCorrectCounter();
          timerProvider.increaseTotalCast();
          SoundService.instance.trueCombinationSound(spellProvider.getNextCombination);
          globalAnimKey.currentState?.trueAnimationForward();
        }else{
          SoundService.instance.failCombinationSound();
          globalAnimKey.currentState?.falseAnimationForward();
        }
        timerProvider.increaseTotalTabs();
        spellProvider.getRandomSpell();
    }
  }
  

  Widget startButton() {
    return !isStart 
      ? Padding(
          padding: EdgeInsets.only(top: context.dynamicHeight(0.04)),
          child: SizedBox(
            width: context.dynamicWidth(0.36),
            height: context.dynamicHeight(0.06),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF545454),
              ),
              child: Text(AppStrings.start, style: TextStyle(fontSize: context.sp(12)),),
              onPressed: () {
                setState(() => isStart=true);
                context.read<TimerProvider>().startTimer();
                context.read<SpellProvider>().getRandomSpell();
              },
            ),
          )
        )
      : SizedBox.shrink();
  }

}