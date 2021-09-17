import 'dart:async';
import 'dart:math';
import 'package:dota2_invoker/providerModels/invokerNameModel.dart';
import 'package:dota2_invoker/screens/challangerScreen.dart';
import 'package:dota2_invoker/screens/loadingScreen.dart';
import 'package:dota2_invoker/screens/trainingScreen.dart';
import 'package:dota2_invoker/screens/withTimerScreen.dart';
import 'package:dota2_invoker/entities/sounds.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({ Key? key }) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {

  Sounds _sounds = Sounds();
  double currentOpacity=0;
  String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  String name="INVOKER";
  Timer? timer;
  String generateRandomString() {
    Random rnd=Random();
    name="";
    for (var i = 0; i < 7; i++) {
      name+=chars[rnd.nextInt(chars.length)];
    }
    return name;
  }

  @override
  void dispose() {
    if (timer!=null) {
      timer!.cancel();
    }
    super.dispose();
  }

  @override
  void initState() {
    Timer(Duration(milliseconds: 500), ()=>setState(() { currentOpacity=1; }));
    timer=Timer.periodic(Duration(milliseconds: 10000), (timer) { 
      name=generateRandomString();
      setState(() {
        
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => InvokerNameModel()),
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
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("$name",style: TextStyle(fontSize: 32),),
/*          trainingButton(),
            withTimerButton(),
            challangerButton(),*/
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


/*


  Widget trainingButton() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: AnimatedOpacity(
        duration: Duration(seconds: 1),
        opacity: currentOpacity,
        child: SizedBox(
          width: 80.w,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF545454),
              elevation: 10,
              shadowColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                side: BorderSide(color: Colors.lightBlue),
              )
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 10.h,
                  width: 12.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: AssetImage("images/quasGif.gif"),
                    fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text("Training  ",style: TextStyle(fontSize: 16.sp),),
              ],
            ),
            onPressed: () {
              _sounds.playSoundBegining();
              Navigator.push(context, MaterialPageRoute(builder: (context)=>LoadingScreen(TrainingScreen())));
            },
          ),
        ),
      ),
    );
  }

  Widget withTimerButton() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: AnimatedOpacity(
        duration: Duration(seconds: 2),
        opacity: currentOpacity,
        child: SizedBox(
          width: 80.w,  //50w
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF545454),
              elevation: 10,
              shadowColor: Colors.pink.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                side: BorderSide(color: Colors.pink.shade200),
              )
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 10.h,  //40
                  width: 12.w,   //24
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: AssetImage("images/wexGif.gif"),
                    fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text("With Timer  ",style: TextStyle(fontSize: 16.sp),),
              ],
            ),
            onPressed: () {},
          ),
        ),
      ),
    );
  }

  Widget challangerButton() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: AnimatedOpacity(
        duration: Duration(seconds: 3),
        opacity: currentOpacity,
        child: SizedBox(
          width: 80.w,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF545454),
              elevation: 10,
              shadowColor: Colors.amber,
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                side: BorderSide(color: Colors.amber),
              )
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 10.h,
                  width: 12.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: AssetImage("images/exortGif.gif"),
                    fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text("Challanger  ",style: TextStyle(fontSize: 16.sp),),
              ],
            ),
            onPressed: () {},
          ),
        ),
      ),
    );
  }


*/

/////////////////////////////



/*
    Widget onlySkillsWithTimer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimatedOpacity(
        duration: Duration(seconds: 2),
        opacity: currentOpacity,
        child: SizedBox(
          width: 36.w,  //50w
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(const Color(0xFF545454)),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 6.h,  //40
                  width: 8.w,   //24
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: AssetImage("images/wexGif.gif"),
                    fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text("With Timer"),
              ],
            ),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
  */