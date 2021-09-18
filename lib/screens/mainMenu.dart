import 'dart:async';
import 'package:dota2_invoker/screens/challangerScreen.dart';
import 'package:dota2_invoker/screens/loadingScreen.dart';
import 'package:dota2_invoker/screens/trainingScreen.dart';
import 'package:dota2_invoker/screens/withTimerScreen.dart';
import 'package:dota2_invoker/entities/sounds.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({ Key? key }) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {

  Sounds _sounds = Sounds();
  double currentOpacity=0;

  @override
  void initState() {
    Timer(Duration(milliseconds: 500), ()=>setState(() { currentOpacity=1; })); 
    super.initState();
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
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            menuButton(Duration(seconds: 1), Colors.blue, Colors.lightBlue, "images/quasGif.gif", "Training", TrainingScreen()),
            menuButton(Duration(seconds: 2), Colors.pink.shade200, Colors.pink.shade200, "images/wexGif.gif", "With Timer", WithTimerScreen()),
            menuButton(Duration(seconds: 3), Colors.amber, Colors.amber, "images/exortGif.gif", "Challanger", ChallangerScreen()),
          ],
        ),
      )
    );
  }

  Widget menuButton(Duration animDuration,Color colorSide, Color colorshadow, String imageString,String menuName,dynamic screen) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: AnimatedOpacity(
        duration: animDuration,
        opacity: currentOpacity,
        child: SizedBox(
          width: 80.w,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF545454),
              elevation: 10,
              shadowColor: colorSide,
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                side: BorderSide(color: colorshadow),
              )
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 10.h,
                  width: 12.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: AssetImage(imageString),
                    fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text("$menuName  ",style: TextStyle(fontSize: 16.sp),),
              ],
            ),
            onPressed: () {
              _sounds.playSoundBegining();
              Navigator.push(context, MaterialPageRoute(builder: (context)=>LoadingScreen(screen)));
            },
          ),
        ),
      ),
    );
  }

}
