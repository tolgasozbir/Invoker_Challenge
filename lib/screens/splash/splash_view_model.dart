import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../constants/app_strings.dart';
import '../../enums/local_storage_keys.dart';
import '../../providers/user_manager.dart';
import '../../services/app_services.dart';
import '../../services/sound_manager.dart';
import '../../utils/ads_helper.dart';
import '../dashboard/dashboard_view.dart';
import 'splash_view.dart';

abstract class SplashViewModel extends State<SplashView> {

  final Duration _duration = const Duration(milliseconds: 3000);
  final math.Random _rnd = math.Random();

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
    await loadAds();
    await getUserRecords();
    getSettingsValues();
    await goToMainMenu();
  }

  Future<void> loadAds() async {
    await AdsHelper.instance.rewardedInterstitialAdLoad();
    await AdsHelper.instance.interstitialAdLoad();
    await AdsHelper.instance.appOpenAdLoad();
  }

  Future<void> getUserRecords() async {
    // await AppServices.instance.localStorageService.removeValue(LocalStorageKey.userRecords);
    // await AppServices.instance.firebaseAuthService.signOut();
    final isLoggedIn = UserManager.instance.isLoggedIn();
    final hasConnection = await InternetConnectionChecker().hasConnection;
    //fetch or create user record and set data
    UserManager.instance.setUser(await UserManager.instance.fetchOrCreateUser());
    //Saving local data to db if user is logged in and has internet connection
    if (isLoggedIn && hasConnection) {
      await AppServices.instance.databaseService.createOrUpdateUser(UserManager.instance.user);
    } 
    log(UserManager.instance.user.uid ?? 'uid: null');
    log(UserManager.instance.user.username);
  }

  void getSettingsValues() {
    SoundManager.instance.setVolume(
      AppServices.instance.localStorageService.getIntValue(LocalStorageKey.volume)?.toDouble() ?? 80,
    );
  }

  Future<void> goToMainMenu() async {
    await Future.delayed(_duration, (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardView()));
    });
  }

}
