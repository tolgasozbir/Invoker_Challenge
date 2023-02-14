import 'package:dota2_invoker/services/database/IDatabaseService.dart';
import 'package:dota2_invoker/services/firebase_auth_service.dart';
import 'package:dota2_invoker/services/local_storage/ILocalStorageService.dart';

class AppServices {
  AppServices._();

  static AppServices? _instance;
  static AppServices get instance => _instance ??= AppServices._();

  IDatabaseService? _databaseService;
  ILocalStorageService? _localStorageService;
  FirebaseAuthService? _firebaseAuthService;

  IDatabaseService get databaseService => _databaseService!;
  ILocalStorageService get localStorageService => _localStorageService!;
  FirebaseAuthService get firebaseAuthService => _firebaseAuthService!;

  Future<void> initServices({
    required IDatabaseService databaseService, 
    required ILocalStorageService localStorageService,
    required FirebaseAuthService firebaseAuthService
  }) async {
    this._databaseService = databaseService;
    this._localStorageService = localStorageService;
    this._firebaseAuthService = firebaseAuthService;

    _localStorageService!.init();
  }
}