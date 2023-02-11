import 'package:dota2_invoker/services/database/IDatabaseService.dart';
import 'package:dota2_invoker/services/local_storage/ILocalStorageService.dart';

class AppServices {
  AppServices._();

  static AppServices? _instance;
  static AppServices get instance => _instance ??= AppServices._();

  IDatabaseService? _databaseService;
  ILocalStorageService? _localStorageService;

  IDatabaseService get databaseService => _databaseService!;
  ILocalStorageService get localStorageService => _localStorageService!;

  Future<void> initServices({
    required IDatabaseService databaseService, 
    required ILocalStorageService localStorageService
  }) async {
    this._databaseService = databaseService;
    this._localStorageService = localStorageService;

    _localStorageService!.init();
  }
}