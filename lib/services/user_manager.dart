import 'package:dota2_invoker/models/user_model.dart';

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
}