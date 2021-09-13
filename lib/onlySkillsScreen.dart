import 'dart:async';

import 'package:dota2_invoker/providerModels/timerModel.dart';
import 'package:dota2_invoker/sounds.dart';
import 'package:dota2_invoker/spell.dart';
import 'package:dota2_invoker/spells.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'showSpellsWidget.dart';

class OnlySkillsScreen extends StatefulWidget {

  @override
  _OnlySkillsScreenState createState() => _OnlySkillsScreenState();
}

class _OnlySkillsScreenState extends State<OnlySkillsScreen> with TickerProviderStateMixin  {

  bool isStart=false;

  Sounds _sounds =Sounds();

  int trueCounterValue=0;

  int totalTabs=0;

  int totalCast=0;

  bool showSpellsVisible=false;

  double startButtonOpacity=1.0;

  late Timer timer;
 

  Spells spells=Spells();
  List<String> spellList=[];
  
  String randomSpellImg="images/quas-wex-exort.jpg";
  List<String> trueCombination=[];
  List<String> currentCombination=["q","w","e"];

  late List<dynamic> selectedElement=[
    invokerSelectedElements("images/invoker_quas.png"),
    invokerSelectedElements("images/invoker_wex.png"),
    invokerSelectedElements("images/invoker_exort.png"),
  ];

  void switchElements(String image,String key) {
    selectedElement.removeAt(0);
    currentCombination.removeAt(0);
    currentCombination.add(key);
    selectedElement.add(invokerSelectedElements(image));
    setState(() {});
  }

  late AnimationController animControlTrue;
  late Animation<double> animTranslateTrue;
  late Animation<double> animAlphaTrue;

  late AnimationController animControlFalse;
  late Animation<double> animTranslateFalse;
  late Animation<double> animAlphaFalse;

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animControlTrue=AnimationController(vsync: this,duration: Duration(milliseconds: 600));
    animTranslateTrue=Tween(begin: 8.0.h,end: -12.0.h).animate(animControlTrue)..addListener(() {setState(() { });});
    animAlphaTrue=Tween(begin: 1.0,end: 0.0).animate(animControlTrue)..addListener(() {setState(() { });});

    animControlFalse=AnimationController(vsync: this,duration: Duration(milliseconds: 600));
    animTranslateFalse=Tween(begin: 8.0.h,end: -12.0.h).animate(animControlFalse)..addListener(() {setState(() { });});
    animAlphaFalse=Tween(begin: 1.0,end: 0.0).animate(animControlFalse)..addListener(() {setState(() { });});
        //30 sp -50 sp
    spellList=spells.getSpells();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => TimerModel()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark(),
          home: Scaffold(
            body: buildBody(),
          ),
        ),
      );
    });
  }

  Widget buildBody() {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          trueCounter(),
          ShowSpellsWidget(showSpellsVisible: showSpellsVisible, spellList: spellList,height: 21.h,width: 100.w,),
          Padding(
            padding: showSpellsVisible==false? EdgeInsets.only(top: 12.h) : EdgeInsets.only(top: 8.h),
            child: trueFalseIcons(),
          ),
          invokerCombinedSkills(randomSpellImg),
          selectedElements(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              invokerElement("images/invoker_quas.png"),
              invokerElement("images/invoker_wex.png"),
              invokerElement("images/invoker_exort.png"),
              invokerElement("images/invoker_invoke.png"),
            ],
          ),
          startButton(),
        ],
      ),
    );
  }

  Widget trueCounter(){
    return Container(
      width: double.infinity,
      height: 12.h,
      child: Stack(
        children: [
          Center(child: Text(trueCounterValue.toString(),style: TextStyle(fontSize: 12.w,color: Colors.green,),)),
          timerCounter(),
          showSpells(),
          clickPerSecond(),
          skillCastPerSecond(),
        ],
      ),
    );
  }

  Positioned skillCastPerSecond() {
    return Positioned(
        left: 2.w,
        top: 8.w,
        child: Tooltip(
          message: "Skill cast per seconds average by elapsed time.",
          child: Consumer<TimerModel>(builder: (context, timerModel, child){
            return Text((timerModel.calculateScps(totalCast)).toStringAsFixed(1) + " SCps",style: TextStyle(fontSize: 4.w,),);
          }),
      ),
    );
  }

  Positioned clickPerSecond() {
    return Positioned(
        left: 2.w,
        top: 2.w,
        child: Tooltip(
          message: "Click per seconds average by elapsed time.",
          child: Consumer<TimerModel>(builder: (context, timerModel, child){
            return Text((timerModel.calculateCps(totalTabs)).toStringAsFixed(1) + " Cps",style: TextStyle(fontSize: 4.w,),);
          }),
      ),
    );
  }

  Positioned timerCounter() {
    return Positioned(
      right: 2.w,
      top: 2.w,
      child: Consumer<TimerModel>(builder: (context, timerModel, child) {
        return Text(
          "${timerModel.getTimeValue()} seconds passed",
          style: TextStyle(
            fontSize: 4.w,
          ),
        );
      }),
    );
  }

  Positioned showSpells() {
    return Positioned(right: 2.w, top: 8.w, child: GestureDetector(
          child: Container(width: 8.w, height: 8.w, child: Icon(FontAwesomeIcons.questionCircle,color: Colors.amberAccent)),
          onTap: (){
            showSpellsVisible==true?showSpellsVisible=false:showSpellsVisible=true;
            setState(() {  });
          },
          ),
        );
  }

  Stack trueFalseIcons() {
    return Stack(
      children: [
        Transform.translate(offset: Offset(0.0,animTranslateTrue.value),
          child: Opacity(
            opacity: animAlphaTrue.value,
            child: Icon(
              FontAwesomeIcons.check,color: Color(0xFF33CC33),
            ),
          ),
        ),
      Transform.translate(offset: Offset(0.0,animTranslateFalse.value),
          child: Opacity(
            opacity: animAlphaFalse.value,
            child: Icon(
              FontAwesomeIcons.times,color: Color(0xFFCC3333),
            ),
          ),
        ),
      ],
    );
  }

  Widget invokerCombinedSkills(String image) {      //onpres ile bilgi verirsin
    return Container(
      width: 28.w,
      height: 28.w,//14.h
      decoration: BoxDecoration(
        boxShadow: [ BoxShadow(color: Colors.white30, blurRadius: 12, spreadRadius: 4), ],
      ),
      child: Image.asset(image)
    );
  }

  Padding selectedElements() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Container(
        width: 24.w,
        height: 10.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            selectedElement[0],
            selectedElement[1],
            selectedElement[2],
          ],
        ),
      ),
    );
  }

  GestureDetector invokerElement(String image) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [ BoxShadow(color: Colors.black54, blurRadius: 12, spreadRadius: 4), ],
        ),
        child: Image.asset(image,width: 20.w,)
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
              _sounds.trueCombinationSound(trueCombination);
              animControlTrue.forward();
              Timer(Duration(milliseconds: 600), (){animControlTrue.reset();});
            }else{
              print("false");
              _sounds.failCombinationSound();
              animControlFalse.forward();
              Timer(Duration(milliseconds: 600), (){animControlFalse.reset();});
            }
            Spell nextSpell=spells.getRandomSpell();
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

  Widget invokerSelectedElements(String image) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [ BoxShadow(color: Colors.black54, blurRadius: 12, spreadRadius: 4), ],
      ),
      child: Image.asset(image,width: 7.w,)
    );
  }

  Widget startButton() {
    return Transform.translate(offset: Offset(0.0,64.0),
      child: Opacity(
        opacity: startButtonOpacity,
        child: SizedBox(
          width: 36.w,
          height: 6.h,
          child: Consumer<TimerModel>(
            builder: (context,timerModel,child){
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF545454),
                ),
                child: Text("Start",style: TextStyle(fontSize: 12.sp),),
                onPressed: () {
                  isStart=true;
                  timer=Timer.periodic(Duration(seconds: 1), (timer) { 
                      timerModel.timeIncrease();
                  });
                  Spell nextSpell = spells.getRandomSpell();
                  randomSpellImg = nextSpell.image;
                  trueCombination = nextSpell.combine;
                  startButtonOpacity=0.0;
                  setState(() {});
                },
              );
            },
          )
        ),
      ),
    );
  }


  
}





     /*    circle        Card(child: Image.asset("images/invoker_quas.png",width: 20.w,),elevation: 10, shadowColor: Colors.amber, shape: CircleBorder(),
    clipBehavior: Clip.antiAlias,),*/