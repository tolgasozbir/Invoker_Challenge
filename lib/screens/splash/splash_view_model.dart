import 'dart:math';

import 'package:flutter/material.dart';

import '../../constants/app_strings.dart';
import '../dashboard/dashboard_view.dart';
import 'splash_view.dart';

abstract class SplashViewModel extends State<SplashView> {

  Duration _duration = Duration(milliseconds: 3000);
  Random _rnd = Random();

  List<String> _splashImages = [
    ImagePaths.splashImage1,
    ImagePaths.splashImage2,
    ImagePaths.splashImage3,
  ];

  @override
  void initState(){
    init();
    super.initState();
  }

  void init() async {
    goToMainMenu();
  }

  void goToMainMenu() async {
    await Future.delayed(_duration, (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardView()));
    });
  }

  String get getRandomSplahImage => _splashImages[_rnd.nextInt(_splashImages.length)];
}