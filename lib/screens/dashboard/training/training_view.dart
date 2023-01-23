import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../extensions/context_extension.dart';
import '../../../providers/timer_provider.dart';
import '../../../widgets/game_ui_widget.dart';
import '../../../widgets/spells_helper_widget.dart';

class TrainingView extends StatefulWidget {
  const TrainingView({Key? key}) : super(key: key);

  @override
  State<TrainingView> createState() => _TrainingViewState();
}

class _TrainingViewState extends State<TrainingView> {

  bool showAllSpells = false;

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
            showAllSpells ? SpellsHelperWidget() : SizedBox(height: context.dynamicHeight(0.08),),
            GameUIWidget(
              gameType: GameType.Training,
              timerWidget: null,
            )
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
        style: TextStyle(fontSize: context.sp(36), color: AppColors.correctCounterColor,),
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

}