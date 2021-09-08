import 'dart:async';
import 'dart:math';

import 'package:dota2_invoker/mainMenu.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Random rnd=Random();

  List<AssetImage> imageList=[
    AssetImage("images/1.gif"),
    AssetImage("images/2.jpg"),
    AssetImage("images/3.jpg"),
  ];

  @override
  void initState() {
    Timer(Duration(milliseconds: 3000), ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MainMenu())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          body: buildBody(),
        );
      },
    );
  }

  Widget buildBody() {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: imageList[rnd.nextInt(imageList.length)], fit: BoxFit.cover),
        ),
      ),
    );
  }
}