import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../widgets/game_ui_widget.dart';

import '../constants/app_strings.dart';
import '../enums/local_storage_keys.dart';
import '../services/app_services.dart';
import '../utils/id_generator.dart';

class UserManager extends ChangeNotifier {
  UserManager._();
  static UserManager? _instance;
  static UserManager get instance => _instance ??= UserManager._();

  UserModel? _userModel;

  UserModel get user => _userModel!;

  void setUser(UserModel user){
    _userModel = user;
  }

  bool isLoggedIn() {
    var user = AppServices.instance.firebaseAuthService.getCurrentUser;
    return user == null ? false : true;
  }

  UserModel createUser() {
    var guest = UserModel.guest(nickname: AppStrings.guest+idGenerator());
    return guest;
  }

  String? getUserFromLocal() {
    return AppServices.instance.localStorageService.getStringValue(LocalStorageKey.userRecords);
  }

  Future<UserModel?> getUserFromDb(String uid) async {
    return await AppServices.instance.databaseService.getUserRecords(uid);
  }

  Future<void> setAndSaveUserToLocale(UserModel user) async {
    await AppServices.instance.localStorageService.setStringValue(
      LocalStorageKey.userRecords, 
      user.toJson(),
    );
    setUser(user);
    notifyListeners();
  }

  Future<UserModel> fetchOrCreateUser() async {
    final localData = getUserFromLocal();
    if (localData != null) {
      setUser(UserModel.fromJson(localData));
      return this.user;
    } 
    else {
      //create new userModel and save to locale
      var createdUser = createUser();
      await setAndSaveUserToLocale(createdUser);
      setUser(createdUser);
      return createdUser;
    }
  }

  int getBestScore(GameType gameType) {
    switch (gameType) {
      case GameType.Training: return 0;
      case GameType.Challanger: return user.maxChallengerScore;
      case GameType.Timer: return user.maxTimerScore;
    }
  }  
  
  void setBestScore(GameType gameType, int score) async {
    if (getBestScore(gameType) >= score) return;
    switch (gameType) {
      case GameType.Training: break;
      case GameType.Challanger: 
        user.maxChallengerScore = score;
        print("new best challenger score : " + user.maxChallengerScore.toString());
        break;
      case GameType.Timer:
        user.maxTimerScore = score;
        print("new best timer score : " + user.maxTimerScore.toString());
        break;
    }
    await setAndSaveUserToLocale(user);
  }

  ///Game System

  //Level System
  double get _getNextLevelExp => user.level * 25;
  double get _getCurrentExp   => user.exp;
  double get _expMultiplier   => user.expMultiplier;
  int _maxLevel = 30;

  void addExp(int exp) async {
    var currExp = _getCurrentExp + (exp * _expMultiplier);
    _levelUp(currExp);
    await setAndSaveUserToLocale(user);
    print("Current Exp : " + user.exp.toString());
    print("Current Level : " + user.level.toString());
  }

  void _levelUp(double exp) {
    if (user.level == _maxLevel) return;
    
    var currExp = exp;
    while (currExp >= _getNextLevelExp) {
      currExp -= _getNextLevelExp;
      user.level++;
      if (user.level >= _maxLevel) {
        user.level = _maxLevel;
        user.exp = _getNextLevelExp;
        return;
      }
    }
    user.exp = currExp;
  }

}
