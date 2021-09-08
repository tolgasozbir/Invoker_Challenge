import 'dart:async';

import 'package:dota2_invoker/spell.dart';
import 'package:dota2_invoker/spells.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

class OnlySkillsScreen extends StatefulWidget {

  @override
  _OnlySkillsScreenState createState() => _OnlySkillsScreenState();
}

class _OnlySkillsScreenState extends State<OnlySkillsScreen> with TickerProviderStateMixin  {

  double StartButtonOpacity=1.0;

  Spells spells=Spells();
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
  void initState() {
    super.initState();
    animControlTrue=AnimationController(vsync: this,duration: Duration(milliseconds: 500));
    animTranslateTrue=Tween(begin: 18.0.sp,end: -30.0.sp).animate(animControlTrue)..addListener(() {setState(() { });});
    animAlphaTrue=Tween(begin: 1.0,end: 0.0).animate(animControlTrue)..addListener(() {setState(() { });});

    animControlFalse=AnimationController(vsync: this,duration: Duration(milliseconds: 500));
    animTranslateFalse=Tween(begin: 18.0.sp,end: -30.0.sp).animate(animControlFalse)..addListener(() {setState(() { });});
    animAlphaFalse=Tween(begin: 1.0,end: 0.0).animate(animControlFalse)..addListener(() {setState(() { });});

  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: Scaffold(
          body: buildBody(),
        ),
      );
    });
  }

  Widget buildBody() {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          trueFalseIcons(),
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
      width: 26.w,
      height: 16.h,
      decoration: BoxDecoration(
        boxShadow: [ BoxShadow(color: Colors.white30, blurRadius: 12, spreadRadius: 4), ],
      ),
      child: Image.asset(image,width: 24.w,)
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
        }
        else if(image=="images/invoker_wex.png"){
          switchElements("images/invoker_wex.png","w");
        }
        else if(image=="images/invoker_exort.png"){
          switchElements("images/invoker_exort.png","e");
        }
        else{
          if (currentCombination.toString()==trueCombination.toString()) {
            print("true");
            animControlTrue.forward();
            Timer(Duration(milliseconds: 450), (){animControlTrue.reset();});
          }else{
            print("false");
            animControlFalse.forward();
            Timer(Duration(milliseconds: 450), (){animControlFalse.reset();});
          }
          Spell nextSpell=spells.getRandomSpell();
          randomSpellImg=nextSpell.image;
          trueCombination=nextSpell.combine;
          setState(() { });
          print(trueCombination);
          
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
        opacity: StartButtonOpacity,
        child: SizedBox(
          width: 36.w,
          height: 6.h,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF545454),
            ),
            child: Text("Start",style: TextStyle(fontSize: 12.sp),),
            onPressed: () {
              Spell nextSpell = spells.getRandomSpell();
              randomSpellImg = nextSpell.image;
              trueCombination = nextSpell.combine;
              StartButtonOpacity=0.0;
              setState(() {});
            },
          ),
        ),
      ),
    );
  }
  
}



     /*    circle        Card(child: Image.asset("images/invoker_quas.png",width: 20.w,),elevation: 10, shadowColor: Colors.amber, shape: CircleBorder(),
    clipBehavior: Clip.antiAlias,),*/