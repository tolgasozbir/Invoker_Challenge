import 'dart:developer';
import 'dart:math' as math;
import 'package:dota2_invoker/enums/local_storage_keys.dart';
import 'package:dota2_invoker/models/user_model.dart';
import 'package:dota2_invoker/services/app_services.dart';
import 'package:dota2_invoker/utils/id_generator.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../constants/app_strings.dart';
import '../../services/firebase_auth_service.dart';
import '../../utils/user_records.dart';
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
    await getUserRecords();
    await goToMainMenu();
  }

  Future<void> getUserRecords() async {
    var user = FirebaseAuthService.instance.getCurrentUser;
    var hasConnection = await InternetConnectionChecker().hasConnection;
    //fetch user records from local
    UserRecords.user = await getUserRecordsFromLocal();
    print(UserRecords.user?.uid ?? "uid null amk");
    //Saving local data to db if user is logged in and has internet connection
    if (user != null && hasConnection) {
      await AppServices.instance.databaseService.createOrUpdateUser(UserRecords.user!);
    } 
    log(UserRecords.user?.uid ?? "uid: null");
    log(UserRecords.user?.nickname ?? "nickname: null");
  }

  Future<UserModel> getUserRecordsFromLocal() async {
    final localData = AppServices.instance.localStorageService.getStringValue(LocalStorageKey.UserRecords);
    if (localData != null) {
      return UserModel.fromJson(localData);
    } 
    else {
      //create new userModel and save to locale
      var newUser = UserModel.guest(nickname: AppStrings.guest+idGenerator());
      await AppServices.instance.localStorageService.setStringValue(
        LocalStorageKey.UserRecords, 
        newUser.toJson(),
      );
      return newUser;
    }
  }

  Future<void> goToMainMenu() async {
    await Future.delayed(_duration, (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardView()));
    });
  }

}
