import 'dart:async';
import 'package:dota2_invoker/components/invokerCombinedSkill.dart';
import 'package:dota2_invoker/components/trueFalseWidget.dart';
import 'package:dota2_invoker/providerModels/timerModel.dart';
import 'package:dota2_invoker/entities/sounds.dart';
import 'package:dota2_invoker/models/spell.dart';
import 'package:dota2_invoker/entities/spells.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../widgets/spells_helper_widget.dart';

class TrainingScreen extends StatefulWidget {

  @override
  _TrainingScreenState createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> with TickerProviderStateMixin  {

  bool isStart=false;
  Sounds _sounds =Sounds();
  int trueCounterValue=0;
  int totalTabs=0;
  int totalCast=0;
  bool showSpellsVisible=false;
  double startButtonOpacity=1.0;

  Timer? timer;
 
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
    if (timer!=null) {
      timer!.cancel();
    }
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
    spellList=spells.getSpellImagePaths;
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
          showSpellWidget(),
          trueFalseIcons(),
          invokerCombinedSkillWidget(),
          selectedElements(),
          invokerMainElements(),
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

  SpellsHelperWidget showSpellWidget() {
    return SpellsHelperWidget(height: 21.h,);
  }

  Padding trueFalseIcons() {
    return Padding(
      padding: showSpellsVisible==false? EdgeInsets.only(top: 12.h) : EdgeInsets.only(top: 8.h),
      child: TrueFalseWidget(
        // animTranslateTrue: animTranslateTrue, 
        // animAlphaTrue: animAlphaTrue, 
        // animTranslateFalse: animTranslateFalse, 
        // animAlphaFalse: animAlphaFalse
      ),
    );
  }

  InvokerCombinedSkillsWidget invokerCombinedSkillWidget() {
    return InvokerCombinedSkillsWidget(image: randomSpellImg,w: 28.w,);
  }

  Padding selectedElements() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Container(
        width: 25.w,
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

  Row invokerMainElements() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        invokerElement("images/invoker_quas.png"),
        invokerElement("images/invoker_wex.png"),
        invokerElement("images/invoker_exort.png"),
        invokerElement("images/invoker_invoke.png"),
      ],
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
        return Text("${timerModel.getTimeValue()} seconds passed", style: TextStyle(fontSize: 4.w,),);
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

  Widget invokerSelectedElements(String image) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [ BoxShadow(color: Colors.black54, blurRadius: 12, spreadRadius: 4), ],
      ),
      child: Image.asset(image,width: 7.w,)
    );
  }




  
}









     /*    circle image       Card(child: Image.asset("images/invoker_quas.png",width: 20.w,),elevation: 10, shadowColor: Colors.amber, shape: CircleBorder(),
    clipBehavior: Clip.antiAlias,),*/