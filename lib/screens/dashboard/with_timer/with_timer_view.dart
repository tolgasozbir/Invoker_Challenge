import 'package:dota2_invoker/extensions/context_extension.dart';
import 'package:dota2_invoker/widgets/custom_animated_dialog.dart';
import 'package:dota2_invoker/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../components/dbResultWidget.dart';
import '../../../constants/app_strings.dart';
import '../../../enums/elements.dart';
import '../../../providers/spell_provider.dart';
import '../../../providers/timer_provider.dart';
import '../../../services/sound_service.dart';
import '../../../widgets/big_spell_picture.dart';
import '../../../widgets/trueFalseWidget.dart';
import 'with_timer_view_model.dart';

class WithTimerView extends StatefulWidget {
  const WithTimerView({Key? key}) : super(key: key);

  @override
  State<WithTimerView> createState() => _WithTimerViewState();
}

class _WithTimerViewState extends WithTimerViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyView(),
    );
  }

  Widget _bodyView() {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          trueCounter(),
          timerCounter(),
          trueFalseIcons(),
          BigSpellPicture(image: isStart ? context.watch<SpellProvider>().getNextSpellImage : ImagePaths.spellImage),
          selectedElementOrbs(),
          skills(),
          startButton(),
          showLeaderBoardButton(),
        ],
      ),
    );
  }

  Widget trueCounter(){
    return Container(
      width: double.infinity,
      height: context.dynamicHeight(0.12),
      child: Center(
        child: Text(
          context.watch<TimerProvider>().getCorrectCombinationCount.toString(),
          style: TextStyle(fontSize: context.sp(36), color: Colors.green,),
        ),
      ),
    );
  }

  Widget timerCounter() {
    var countdownValue = context.watch<TimerProvider>().getCountdownValue;
    return Card(
      color: Color(0xFF303030),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.square(
            dimension: context.dynamicWidth(0.14),
            child: CircularProgressIndicator(
              color: Colors.amber,
              backgroundColor: Colors.blue,
              valueColor: countdownValue <=10 
                ? AlwaysStoppedAnimation<Color>(Colors.red) 
                : AlwaysStoppedAnimation<Color>(Colors.amber),
              value: countdownValue / 60,
              strokeWidth: 4,
            ),
          ),
          Text(countdownValue.toString(), style: TextStyle(fontSize: context.sp(24)),),
        ],
      ),
    );
  }

  Widget trueFalseIcons() {
    return Padding(
      padding: EdgeInsets.only(top: context.dynamicHeight(0.04)),
      child: TrueFalseWidget(),
    );
  }

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
      ? CustomButton(
          text: AppStrings.start, 
          padding: EdgeInsets.only(top: context.dynamicHeight(0.04)),
          onTap: () {
            setState(() => isStart=true);
            context.read<TimerProvider>().startTimer();
            context.read<SpellProvider>().getRandomSpell();
          },
        )
      : SizedBox.shrink();
  }

  Widget showLeaderBoardButton() {
    return !isStart 
      ? CustomButton(
          text: AppStrings.leaderboard, 
          padding: EdgeInsets.only(top: context.dynamicHeight(0.02)),
          onTap: () => CustomAnimatedDialog.showCustomDialog(
            context: context,
            content: SizedBox(),
          ),
        )
      : SizedBox.shrink();
  }


  Widget myLeaderboardAlertDialog(){
   return AlertDialog(
      title: Text("Results",style: TextStyle(color: Color(0xFFEEEEEE),)),
      content: SizedBox(
        width: context.dynamicWidth(0.65),
        height: context.dynamicHeight(0.35),
        child: Card(
          color:Color(0xFF666666) , 
          child: DbResultWidget() //TODO WHAT İS THİS
        )
      ),
      backgroundColor: Color(0xFF444444),
      actions: [
        TextButton(
          child: Text("Back"),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ],
    );
 }

  // oyun bitimi için

  void resultDiaglog(){
    showDialog(
      context: context,
      builder: (_) => myAlertDialog(),
      barrierDismissible: false,
    );
  }

 Widget myAlertDialog(){
   return AlertDialog(
      title: Text("Results",style: TextStyle(color: Color(0xFFEEEEEE),)),
      content: Container(
        width: double.infinity,
        height: context.dynamicHeight(0.275),
        child: Column(
          children: [
            Text("True Combinations\n\n5",style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFFEEEEEE), fontSize: 18),textAlign: TextAlign.center,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                maxLength: 14,
                decoration: InputDecoration(
                  fillColor: Colors.white24,
                  filled: true,
                  border: OutlineInputBorder(),
                  hintText: "Name",
                  labelText: "Name",
                  labelStyle: TextStyle(color: Colors.amber, fontSize: 18,fontWeight: FontWeight.w600)
                ),
                onChanged: (value){
                  if (value.length<=0) {
                    textfieldValue="Unnamed";
                  }
                  else{
                    textfieldValue=value;
                  }
                },
              ),
            )
          ],
        )
      ),
      backgroundColor: Color(0xFF444444),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              child: Text("Back"),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("Send"),
              onPressed: (){
                if (textfieldValue.length<=0) {
                    textfieldValue="Unnamed";
                }
                //dbAccesLayer.addDbValue(textfieldValue,result);
                textfieldValue="";
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    );
 }




}