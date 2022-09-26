import 'dart:math';
import 'package:dota2_invoker/screens/dashboard/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'splash_view.dart';

abstract class SplashViewModel extends State<SplashView> {

  Duration _duration = Duration(milliseconds: 3000);
  Random rnd = Random();

  List<String> splashImages = [
    'images/1.gif',
    'images/2.jpg',
    'images/3.jpg',
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