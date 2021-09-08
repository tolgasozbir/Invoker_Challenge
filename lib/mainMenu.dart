import 'dart:async';
import 'package:dota2_invoker/loadingScreen.dart';
import 'package:dota2_invoker/onlySkillsScreen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({ Key? key }) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {

  double currentOpacity=0;

  @override
  void initState() {
    Timer(
      Duration(milliseconds: 500), 
      ()=>setState(() { currentOpacity=1; })
    );
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
            onlySkills(),
            onlySkillsWithTimer(),
            skillsWithItems(),
          ],
        ),
      )
    );
  }


  Widget onlySkills() {
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
              Navigator.push(context, MaterialPageRoute(builder: (context)=>LoadingScreen(OnlySkillsScreen())));
            },
          ),
        ),
      ),
    );
  }

    Widget onlySkillsWithTimer() {
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

  Widget skillsWithItems() {
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


}


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