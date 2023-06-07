import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../constants/app_image_paths.dart';
import '../../enums/local_storage_keys.dart';
import '../../services/user_manager.dart';
import '../../services/app_services.dart';
import '../../services/sound_manager.dart';
import '../../utils/ads_helper.dart';
import '../dashboard/dashboard_view.dart';
import 'splash_view.dart';

abstract class SplashViewModel extends State<SplashView> {

  final Duration _duration = const Duration(milliseconds: 3000);
  final math.Random _rnd = math.Random();

  String get getRandomSplahImage => ImagePaths.splashImages[_rnd.nextInt(ImagePaths.splashImages.length)];

  @override
  void initState(){
    init();
    super.initState();
  }

  Future<void> init() async {
    await initHive();
    await loadAds();
    await getUserRecords();
    getSettingsValues();
    await goToMainMenu();
  }

  Future<void> initHive() async {
    await Hive.initFlutter();
    await UserManager.instance.userHiveManager.init();
  }

  Future<void> loadAds() async {
    await AdsHelper.instance.rewardedInterstitialAdLoad();
    await AdsHelper.instance.interstitialAdLoad();
    await AdsHelper.instance.appOpenAdLoad();
  }

  Future<void> getUserRecords() async {
    await UserManager.instance.initUser(); //cache'de varsa çek yoksa oluştur cache'e kaydet
    final hasConnection = await InternetConnectionChecker().hasConnection;
    final user = UserManager.instance.user;

    if (hasConnection && user.uid != null) {
      await UserManager.instance.saveUserToDb(user);
    }

    log(UserManager.instance.user.uid ?? 'uid: null');
    log(UserManager.instance.user.username);
  }

  void getSettingsValues() {
    SoundManager.instance.setVolume(
      AppServices.instance.localStorageService.getValue<int>(LocalStorageKey.volume)?.toDouble() ?? 80,
    );
  }

  Future<void> goToMainMenu() async {
    await Future.delayed(_duration, (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardView()));
    });
  }

}
