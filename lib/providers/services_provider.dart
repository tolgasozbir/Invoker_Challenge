import 'package:dota2_invoker/services/local_storage/ILocalStorageService.dart';
import 'package:flutter/material.dart';

import '../services/database/IDatabaseService.dart';

class ServicesProvider extends ChangeNotifier {
  ServicesProvider({required IDatabaseService databaseService, required ILocalStorageService localStorageService}) {
    this._databaseService = databaseService;
    this._localStorageService = localStorageService;
  }

  late final IDatabaseService _databaseService;
  late final ILocalStorageService _localStorageService;

  IDatabaseService get databaseService => _databaseService;
  ILocalStorageService get localStorageService => _localStorageService;

  Future<void> initServices() async {
    await localStorageService.init();
  }
}