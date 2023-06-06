// ignore_for_file: use_late_for_private_fields_and_variables

import '../utils/formatted_date.dart';
import 'package:flutter/material.dart';
import 'package:snappable_thanos/snappable_thanos.dart';

import '../constants/app_strings.dart';
import '../enums/local_storage_keys.dart';
import '../models/score_models/boss_battle.dart';
import '../models/user_model.dart';
import 'achievement_manager.dart';
import 'app_services.dart';
import '../utils/id_generator.dart';
import '../widgets/game_ui_widget.dart';

class UserManager extends ChangeNotifier {
  UserManager._();
  static UserManager? _instance;
  static UserManager get instance => _instance ??= UserManager._();

  final snappableKey = GlobalKey<SnappableState>();

  UserModel? _userModel;
  UserModel get user => _userModel!;

  void setUser(UserModel user) {
    user.lastPlayed = getFormattedDate();
    _userModel = user;
    notifyListeners();
  }

  /// Initializes the user.
  ///
  /// Retrieves the user from the cache, if available,
  /// and sets it as the current user. If the user is not
  /// found in the cache, a new user is created and set as
  /// the current user. The new user is also saved to the cache.
  ///
  /// Returns: A [Future] that completes when the user is initialized.
  Future<void> initUser() async {
    // Retrieve the user from the cache
    final user = getUserFromCache();
    if (user != null) {
      // If the user is found in the cache, set it as the current user
      setUser(user);
      return;
    }
    // If the user is not found in the cache, create a new user
    final newUser = createUser();
    // Set the new user as the current user and save it to the cache
    setUserAndSaveToCache(newUser);
  }

  UserModel createUser() {
    final newUser = UserModel.guest(username: AppStrings.guest + idGenerator());
    return newUser;
  }

  Future<void> setUserAndSaveToCache(UserModel user) async {
    await _saveUserToCache(user);
    setUser(user);
  }


  //Cache - Local

  UserModel? getUserFromCache() {
    final cache = AppServices.instance.localStorageService.getValue<String>(LocalStorageKey.userRecords);
    if (cache == null) return null;
    return UserModel.fromJson(cache);
  }

  Future<void> _saveUserToCache(UserModel user) async {
    await AppServices.instance.localStorageService.setValue<String>(
      LocalStorageKey.userRecords,
      user.toJson(),
    );
  }


  //Auth

  Future<bool> signUp({required String email, required String password, required String username}) async {
    final bool isSuccess = await AppServices.instance.firebaseAuthService.signUp(
      email: email, 
      password: password, 
      username: username,
    );

    if (isSuccess) {
      final user = createUser();
      user.username = username;
      user.uid = AppServices.instance.firebaseAuthService.currentUser!.uid;
      await setUserAndSaveToCache(user);
      await saveUserToDb(user);
    }

    return isSuccess;
  }

  Future<bool> signIn({required String email, required String password}) async {
    final bool isSuccess = await AppServices.instance.firebaseAuthService.signIn(email: email, password: password);
    if (isSuccess) {
      final user = await getUserFromDb(AppServices.instance.firebaseAuthService.currentUser!.uid);
      if (user == null) return false;
      await setUserAndSaveToCache(user);
    }

    return isSuccess;
  }

  Future<bool> resetPassword({required String email}) async {
    final bool isSuccess = await AppServices.instance.firebaseAuthService.resetPassword(email: email);
    return isSuccess;
  }

  Future<void> signOut() async {
    await AppServices.instance.firebaseAuthService.signOut();
    await AppServices.instance.localStorageService.deleteAllValues();
    await setUserAndSaveToCache(createUser());
  }

  Future<bool> isLoggedIn() async {
    return AppServices.instance.firebaseAuthService.currentUser != null;
  }
  
  
  //Db

  Future<UserModel?> getUserFromDb(String uid) async {
    return AppServices.instance.databaseService.getUserRecords(uid);
  }

  Future<void> saveUserToDb(UserModel user) async {
    await AppServices.instance.databaseService.createOrUpdateUser(user);
  }


  //

  Map<String, dynamic> getBestBossScore(String bossName) {
    return user.bestBossScores?[bossName] as Map<String, dynamic>? ?? {};
  }

  void updateBestBossTimeScore(String bossName, int value, BossBattle model) async {
    user.bestBossScores ??= {}; // null check
    user.bestBossScores!.putIfAbsent(bossName, () => model.toMap());
    
    // Kullanıcının uid değeri boş değilse ve user objesinin bestBossScores özelliği varsa:
    // - bestBossScores objesinde bossName anahtarının varlığını ve bu anahtarın değerinin "Guest" ile başladığını kontrol ediyoruz.
    if (user.uid != null && user.bestBossScores![bossName]['name'].toString().startsWith('Guest')) {
      // Yukarıdaki koşullar sağlandığında, bestBossScores objesindeki bossName anahtarının "name" özelliğini
      // kullanıcının kullanıcı adıyla değiştiriyoruz.
      user.bestBossScores![bossName]['name'] = user.username;
    }
    if ((user.bestBossScores?[bossName]['time'] as int? ?? 0) < value) return;
    if (user.bestBossScores!.containsKey(bossName)) {
      user.bestBossScores![bossName] = model.toMap();
    }
    await setUserAndSaveToCache(user);
  }

  int getBestScore(GameType gameType) {
    switch (gameType) {
      case GameType.Training: return 0;
      case GameType.Challanger: return user.bestChallengerScore;
      case GameType.Timer: return user.bestTimerScore;
      case GameType.Combo: return user.bestComboScore;
    }
  }

  void setBestScore(GameType gameType, int score) async {
    if (getBestScore(gameType) >= score) return;
    switch (gameType) {
      case GameType.Training:
        break;
      case GameType.Challanger:
        user.bestChallengerScore = score;
        break;
      case GameType.Timer:
        user.bestTimerScore = score;
        break;
      case GameType.Combo:
        user.bestComboScore = score;
        break;
    }
    await setUserAndSaveToCache(user);
  }

  ///Game System

  //Level System
  double get nextLevelExp => user.level * 25;
  double get _currentExp => user.exp;
  double get _expMultiplier => user.expMultiplier;
  double expCalc(int exp) => exp * _expMultiplier;
  final int _maxLevel = 30;

  void addExp(int exp) async {
    final currExp = _currentExp + expCalc(exp);
    _levelUp(currExp);
    await setUserAndSaveToCache(user);
  }

  void _levelUp(double exp) {
    if (user.level == _maxLevel) return;

    var currExp = exp;
    while (currExp >= nextLevelExp) {
      currExp -= nextLevelExp;
      user.level++;
      enableTalents();
      if (user.level >= _maxLevel) {
        user.level = _maxLevel;
        user.exp = nextLevelExp;
        return;
      }
    }
    AchievementManager.instance.updateLevel();
    user.exp = currExp;
  }

  //Talent Tree
  final treeLevels = const [10, 15, 20, 25];

  void enableTalents() {
    final level = user.level;

    //Return true if user level is in skill tree level array and talent is not active
    user.talentTree ??= {};
    if (!treeLevels.contains(level)) return;
    user.talentTree!.putIfAbsent(level.toString(), () => false);
    if (user.talentTree?['$level'] == true) return;

    switch (level) {
      case 10: break; ///[maxMana += UserManager.instance.user.level >= 10 ? 400] in BossProvider
      case 15: user.challangerLife = 1; break;
      case 20: user.expMultiplier += 2; break;
      case 25: break; ///[baseDamage *= (UserManager.instance.user.level >= 30 ? 2 : 1)] in BossProvider
      default: break;
    }

    //active current talent
    user.talentTree?['$level'] = true;
  }

  //Sync Data
  DateTime lastSyncedDate = DateTime.now().subtract(const Duration(minutes: 5));
  final waitSyncDuration = const Duration(minutes: 5);
  void updateSyncedDate() {
    lastSyncedDate = DateTime.now();
  }
}