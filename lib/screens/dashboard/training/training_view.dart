import 'dart:async';

import 'package:dota2_invoker/extensions/context_extension.dart';
import 'package:dota2_invoker/providerModels/timer_provider.dart';
import 'package:dota2_invoker/screens/dashboard/training/training_view_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../widgets/big_spell_picture.dart';
import '../../../widgets/spells_helper_widget.dart';
import '../../../components/trueFalseWidget.dart';
import '../../../models/spell.dart';

class TrainingView extends StatefulWidget {
  const TrainingView({Key? key}) : super(key: key);

  @override
  State<TrainingView> createState() => _TrainingViewState();
}

class _TrainingViewState extends TrainingViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
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
            BigSpellPicture(image: randomSpellImg),
            selectedElements(),
            invokerMainElements(),
            startButton(),
          ],
        ),
      ),
    );
  }

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
        style: TextStyle(fontSize: context.sp(36), color: Colors.green,),
      )
    );
  }

  Positioned timerCounter() {
    return Positioned(
      right: context.dynamicWidth(0.02),
      top: context.dynamicWidth(0.02),
      child: Text(
        "${context.watch<TimerProvider>().getTimeValue} seconds passed", 
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
          child: Icon(FontAwesomeIcons.questionCircle,color: Colors.amberAccent)
        ),
        onTap: (){
          showAllSpells == true 
            ? showAllSpells = false
            : showAllSpells = true;
          setState(() { });
        },
      ),
    );
  }

  Positioned clickPerSecond() {
    return Positioned(
      left: context.dynamicWidth(0.02),
      top: context.dynamicWidth(0.02),
      child: Tooltip(
        message: "Click per seconds average by elapsed time.",
        child: Text(
          context.watch<TimerProvider>().calculateCps(totalTabs).toStringAsFixed(1) + " Cps",
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
        message: "Skill cast per seconds average by elapsed time.",
        child: Text(
          context.watch<TimerProvider>().calculateScps(totalCast).toStringAsFixed(1) + " SCps",
          style: TextStyle(fontSize: context.sp(12),),
        ),
      ),
    );
  }


  //

  Padding trueFalseIcons() {
    return Padding(
      padding: showAllSpells == false 
        ? EdgeInsets.only(top: context.dynamicHeight(0.12)) 
        : EdgeInsets.zero,
      child: TrueFalseWidget(key: globalAnimKey), 
    );
  }

  Container selectedElements() {
    return Container(
      width: context.dynamicWidth(0.25),
      height: context.dynamicHeight(0.10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          selectedElement[0],
          selectedElement[1],
          selectedElement[2],
        ],
      ),
    );
  }

  Padding invokerMainElements() {
    return Padding(
      padding: EdgeInsets.only(top: context.dynamicHeight(0.03)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          invokerElement("images/invoker_quas.png"),
          invokerElement("images/invoker_wex.png"),
          invokerElement("images/invoker_exort.png"),
          invokerElement("images/invoker_invoke.png"),
        ],
      ),
    );
  }

  GestureDetector invokerElement(String image) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [ BoxShadow(color: Colors.black54, blurRadius: 12, spreadRadius: 4), ],
        ),
        child: Image.asset(image,width: context.dynamicWidth(0.20))
      ),
      onTap: () {
        if(image=="images/invoker_quas.png"){
          switchElements("images/invoker_quas.png","q");
          totalTabs++;
        }
        else if(image=="images/invoker_wex.png"){
          switchElements("images/invoker_wex.png","w");
          totalTabs++;
        }
        else if(image=="images/invoker_exort.png"){
          switchElements("images/invoker_exort.png","e");
          totalTabs++;
        }
        else{
          if(isStart){          
            if (currentCombination.toString()==trueCombination.toString()) {
              print("true");
              trueCounterValue++;
              totalCast++;
              sounds.trueCombinationSound(trueCombination);
              globalAnimKey.currentState?.trueAnimationForward();
            }else{
              print("false");
              sounds.failCombinationSound();
              globalAnimKey.currentState?.falseAnimationForward();
            }
            Spell nextSpell=spells.getRandomSpell;
            randomSpellImg=nextSpell.image;
            trueCombination=nextSpell.combine;
            totalTabs++;
            setState(() { });
            print(trueCombination);
          }
        }
      },
    );
  }

  Widget startButton() {
    return !isStart 
      ? Padding(
        padding: EdgeInsets.only(top: context.dynamicHeight(0.04)),
        child: SizedBox(
          width: context.dynamicWidth(0.36),
          height: context.dynamicHeight(0.06),
          child: Consumer<TimerProvider>(
            builder: (context,timerModel,child){
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF545454),
                ),
                child: Text("Start",style: TextStyle(fontSize: context.sp(12)),),
                onPressed: () {
                  isStart=true;
                  timer=Timer.periodic(Duration(seconds: 1), (timer) { 
                      timerModel.timeIncrease();
                  });
                  Spell nextSpell = spells.getRandomSpell;
                  randomSpellImg = nextSpell.image;
                  trueCombination = nextSpell.combine;
                  startButtonOpacity=0.0;
                  setState(() {});
                },
              );
            },
          )
        ),
      )
      : SizedBox.shrink();
  }

}