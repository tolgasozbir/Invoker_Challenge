import 'package:dota2_invoker/constants/app_colors.dart';
import 'package:dota2_invoker/constants/app_strings.dart';
import 'package:dota2_invoker/entities/sounds.dart';
import 'package:dota2_invoker/entities/spells.dart';
import 'package:dota2_invoker/extensions/context_extension.dart';
import 'package:dota2_invoker/providerModels/timer_provider.dart';
import 'package:dota2_invoker/screens/dashboard/training/training_view_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../widgets/big_spell_picture.dart';
import '../../../widgets/spells_helper_widget.dart';
import '../../../components/trueFalseWidget.dart';

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
            BigSpellPicture(image: nextSpellImg),
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
          trueCounter(),
          timerCounter(),
          showSpells(),
          clickPerSecond(),
          skillCastPerSecond(),
        ],
      ),
    );
  }

  Center trueCounter() {
    return Center(
      child: Text(
        trueCounterValue.toString(),
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
          context.watch<TimerProvider>().calculateCps(totalTabs).toStringAsFixed(1) + '${AppStrings.cps}',
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
          context.watch<TimerProvider>().calculateScps(totalCast).toStringAsFixed(1) + '${AppStrings.scps}',
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
          skill(MainSkills.quas),
          skill(MainSkills.wex),
          skill(MainSkills.exort),
          skill(MainSkills.invoke),
        ],
      ),
    );
  }

  InkWell skill(MainSkills mainSkills) {
    return InkWell(
      child: DecoratedBox(
        decoration: skillBlackShadowDec,
        child: Image.asset(mainSkills.getImage,width: context.dynamicWidth(0.20))
      ),
      onTap: () => skillOnTapFN(mainSkills),
    );
  }

  void skillOnTapFN(MainSkills mainSkills){
    switch (mainSkills) {
      case MainSkills.quas:
        return switchOrb(mainSkills.getImage, 'q');
      case MainSkills.wex:
        return switchOrb(mainSkills.getImage, 'w');
      case MainSkills.exort:
        return switchOrb(mainSkills.getImage, 'e');
      case MainSkills.invoke:
        if(!isStart) return;
        if (currentCombination.toString()==trueCombination.toString()) {
          trueCounterValue++;
          totalCast++;
          Sounds.instance.trueCombinationSound(trueCombination);
          globalAnimKey.currentState?.trueAnimationForward();
        }else{
          Sounds.instance.failCombinationSound();
          globalAnimKey.currentState?.falseAnimationForward();
        }
        totalTabs++;
        nextSpell();
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
                isStart=true;
                context.read<TimerProvider>().startTimer();
                startButtonOpacity=0.0;
                nextSpell();
              },
            ),
          )
        )
      : SizedBox.shrink();
  }

}