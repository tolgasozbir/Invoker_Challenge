import 'dart:math';
import 'package:dota2_invoker/constants/app_strings.dart';
import 'package:dota2_invoker/screens/dashboard/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'splash_view.dart';

abstract class SplashViewModel extends State<SplashView> {

  Duration _duration = Duration(milliseconds: 3000);
  Random rnd = Random();

  List<String> splashImages = [
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
}