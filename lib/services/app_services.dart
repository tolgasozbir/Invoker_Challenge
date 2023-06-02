import 'auth/firebase_auth_service.dart';
import 'database/IDatabaseService.dart';
import 'local_storage/ILocalStorageService.dart';

class AppServices {
  AppServices._();

  static AppServices? _instance;
  static AppServices get instance => _instance ??= AppServices._();

  late IDatabaseService? _databaseService;
  late ILocalStorageService? _localStorageService;
  late FirebaseAuthService? _firebaseAuthService;

  IDatabaseService get databaseService => _databaseService!;
  ILocalStorageService get localStorageService => _localStorageService!;
  FirebaseAuthService get firebaseAuthService => _firebaseAuthService!;

  Future<void> initServices({
    required IDatabaseService databaseService, 
    required ILocalStorageService localStorageService,
    required FirebaseAuthService firebaseAuthService,
  }) async {
    this._databaseService = databaseService;
    this._localStorageService = localStorageService;
    this._firebaseAuthService = firebaseAuthService;

    await _localStorageService!.init();
  }
}
