import 'package:flutter/material.dart';
import 'package:snappable_thanos/snappable_thanos.dart';

import '../constants/app_strings.dart';
import '../enums/local_storage_keys.dart';
import '../models/user_model.dart';
import '../services/app_services.dart';
import '../utils/id_generator.dart';
import '../widgets/game_ui_widget.dart';

class UserManager extends ChangeNotifier {
  UserManager._();
  static UserManager? _instance;
  static UserManager get instance => _instance ??= UserManager._();

  final snappableKey = GlobalKey<SnappableState>();

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
    var guest = UserModel.guest(username: AppStrings.guest+idGenerator());
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
      //I can't change the initial const values (achievement & talentTree) ​​so I create the User model from scratch
      var savedUser = UserModel.fromJson(getUserFromLocal()!);
      await setAndSaveUserToLocale(savedUser);
      return savedUser;
    }
  }

  int getBestScore(GameType gameType) {
    switch (gameType) {
      case GameType.Training: return 0;
      case GameType.Challanger: return user.bestChallengerScore;
      case GameType.Timer: return user.bestTimerScore;
    }
  }  
  
  void setBestScore(GameType gameType, int score) async {
    if (getBestScore(gameType) >= score) return;
    switch (gameType) {
      case GameType.Training: break;
      case GameType.Challanger: 
        user.bestChallengerScore = score;
        break;
      case GameType.Timer:
        user.bestTimerScore = score;
        break;
    }
    await setAndSaveUserToLocale(user);
  }

  ///Game System

  //Level System
  double get getNextLevelExp => user.level < 10 ? (user.level * 20) : (user.level * 25);
  double get _getCurrentExp   => user.exp;
  double get _expMultiplier   => user.expMultiplier;
  double expCalc(int exp) => (exp * _expMultiplier) + exp;
  int _maxLevel = 30;

  void addExp(int exp) async {
    var currExp = _getCurrentExp + expCalc(exp);
    _levelUp(currExp);
    await setAndSaveUserToLocale(user);
  }

  void _levelUp(double exp) {
    if (user.level == _maxLevel) return;
    
    var currExp = exp;
    while (currExp >= getNextLevelExp) {
      currExp -= getNextLevelExp;
      user.level++;
      enableTalents();
      if (user.level >= _maxLevel) {
        user.level = _maxLevel;
        user.exp = getNextLevelExp;
        return;
      }
    }
    user.exp = currExp;
  }

  //Talent Tree
  final _treeLevels = const [10, 15, 20, 25];
  List<int> get treeLevels => _treeLevels;

  void enableTalents() {
    var level = user.level;

    //Return true if user level is in skill tree level array and talent is not active
    var reachedTalent = !(user.talentTree?['$level'] ?? true) && treeLevels.contains(level);
    if (!reachedTalent) return;

    //TODO: Talents
    switch (level) {
      case 10: user.isBossModeEnabled = true; break;
      case 15: user.challangerLife = 1; break;
      case 20: user.expMultiplier += 2; break;
      case 25: break;
      default: break;
    }
    
    //active current talent
    user.talentTree?['$level'] = true;
  }

}
