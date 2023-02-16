import 'package:dota2_invoker/models/user_model.dart';
import 'package:dota2_invoker/widgets/game_ui_widget.dart';

import '../constants/app_strings.dart';
import '../enums/local_storage_keys.dart';
import 'app_services.dart';
import '../utils/id_generator.dart';

class UserManager {
  UserManager._();
  static UserManager? _instance;
  static UserManager get instance => _instance ??= UserManager._();

  UserModel? _userModel;

  UserModel? get user => _userModel;

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
  }

  Future<UserModel> fetchOrCreateUser() async {
    final localData = getUserFromLocal();
    if (localData != null) {
      setUser(UserModel.fromJson(localData));
      return this.user!;
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
      case GameType.Challanger: return user?.maxChallengerScore ?? 0;
      case GameType.Timer: return user?.maxTimerScore ?? 0;
    }
  }
}