import 'dart:math';
import 'package:dota2_invoker/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import '../../constants/app_strings.dart';
import '../dashboard/dashboard_view.dart';
import 'splash_view.dart';

abstract class SplashViewModel extends State<SplashView> {

  final Duration _duration = const Duration(milliseconds: 3000);
  final Random _rnd = Random();

  final List<String> _splashImages = const [
    ImagePaths.splashImage1,
    ImagePaths.splashImage2,
    ImagePaths.splashImage3,
  ];

  String get getRandomSplahImage => _splashImages[_rnd.nextInt(_splashImages.length)];

  @override
  void initState(){
    init();
    super.initState();
  }

  Future<void> init() async {
    await goToMainMenu();
  }

  //TODO:
  
  // Future<void> getUserValues() async {
  //   var user = FirebaseAuthService.instance.getCurrentUser;
  //   if (user != null) {
  //     UserRecords.userModel = null;
  //   }
  // }

  // Future<void> getUserValuesFromDb() async {
  //   //context.services.databaseService.
  // }

  // Future<void> getUserValuesFromLocal() async {
  //   //context.read<ServicesProvider>().localStorageService.;
  // }

  Future<void> goToMainMenu() async {
    await Future.delayed(_duration, (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardView()));
    });
  }

}
