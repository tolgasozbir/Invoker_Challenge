import 'dart:developer';

import 'package:dota2_invoker_game/enums/sound_players.dart';
import 'package:dota2_invoker_game/models/invoker.dart';
import 'package:dota2_invoker_game/services/iap/revenuecat_service.dart';
import 'package:dota2_invoker_game/services/sound_player/audioplayer_wrapper.dart';
import 'package:dota2_invoker_game/services/sound_player/soloud_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../enums/local_storage_keys.dart';
import '../../services/user_manager.dart';
import '../../services/app_services.dart';
import '../../services/sound_manager.dart';
import '../../utils/ads_helper.dart';
import '../dashboard/dashboard_view.dart';
import 'splash_view.dart';

abstract class SplashViewModel extends State<SplashView> {

  final Duration _duration = const Duration(milliseconds: 2400);

  @override
  void initState(){
    init();
    super.initState();
  }

  Future<void> init() async {
    await initHive();
    await getUserRecords();
    await loadRevenueCatData();
    await loadAds();
    getSettingsValues();
    loadInvokerSet();
    await goToMainMenu();
  }

  Future<void> initHive() async {
    await Hive.initFlutter();
    await UserManager.instance.userHiveManager.init();
  }

  Future<void> loadAds() async {
    await AdsHelper.instance.appOpenAdLoad();
    await AdsHelper.instance.interstitialAdLoad();
    await AdsHelper.instance.rewardedAdLoad();
  }

  Future<void> loadRevenueCatData() async {
    if (UserManager.instance.user.uid == null) {
      return;
    }
    await RevenueCatService.instance.tryRestoreOnFirstLaunch();
    await RevenueCatService.instance.loadDataWithRetry();
  }
 
  Future<void> getUserRecords() async {
    // Retrieve user records from cache if available, otherwise create a new user and save it to the cache
    await UserManager.instance.initUser();
    final hasConnection = await InternetConnectionChecker().hasConnection;
    final user = UserManager.instance.user;

    if (hasConnection && user.uid != null) {
      final dbUser = await UserManager.instance.getUserFromDb(user.uid!);

      // Use dbUser model for Hive database migration and to handle inconsistencies during version transitions in SharedPrefs
      final bool useDbModel =
        dbUser != null &&
        (dbUser.level > user.level || (dbUser.level == user.level && dbUser.exp >= user.exp));

      if (useDbModel) {
        await UserManager.instance.setUserAndSaveToCache(dbUser);
      } else {
        await UserManager.instance.saveUserToDb(user);
      }
    }

    log(UserManager.instance.user.uid ?? 'uid: null');
    log(UserManager.instance.user.username);
  }

  void getSettingsValues() {
    final storage = AppServices.instance.localStorageService;

    final savedVolume = storage.getValue<int>(LocalStorageKey.volume)?.toDouble() ?? 80;
    SoundManager.instance.setVolume(savedVolume);

    final soundPlayer = storage.getValue<String>(LocalStorageKey.soundPlayer) ?? SoundPlayers.SoLoud.name;
    final isSoLoud = soundPlayer == SoundPlayers.SoLoud.name;
    final player = isSoLoud ? SoLoudWrapper.instance : AudioPlayerWrapper.instance;

    SoundManager.instance.switchPlayer(player);
  }

  void loadInvokerSet() {
    final cachedInvokerSet = AppServices.instance.localStorageService.getValue<String>(LocalStorageKey.invokerForm);
    if (cachedInvokerSet != null) {
      final set = InvokerSet.values.firstWhere(
        (e) => e.name == cachedInvokerSet,
        orElse: () => InvokerSet.defaultSet,
      );
      UserManager.instance.changeInvokerType(set);
    }
  }

  Future<void> goToMainMenu() async {
    await Future.delayed(_duration, (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardView()));
    });
  }

}
