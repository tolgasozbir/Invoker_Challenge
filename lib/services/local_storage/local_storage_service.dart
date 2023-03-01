import 'package:shared_preferences/shared_preferences.dart';

import '../../enums/local_storage_keys.dart';
import 'ILocalStorageService.dart';

class LocalStorageService implements ILocalStorageService {
  LocalStorageService._();

  static LocalStorageService? _instance;
  static LocalStorageService get instance => _instance ??= LocalStorageService._();
  SharedPreferences? _prefs;

  ///init SharedPreferences
  @override
  Future<void> init() async {
    if (_prefs != null) return;  
    _prefs = await SharedPreferences.getInstance();
  }

  //Setters
  @override
  Future<void> setStringValue(LocalStorageKey key, String value) async {
    await _prefs?.setString(key.name, value);
  }

  @override
  Future<void> setIntValue(LocalStorageKey key, int value) async {
    await _prefs?.setInt(key.name, value);
  }

  @override
  Future<void> setBoolValue(LocalStorageKey key, bool value) async {
    await _prefs?.setBool(key.name, value);
  }

  //Getters
  @override
  String? getStringValue(LocalStorageKey key) {
    return _prefs?.getString(key.name);
  }

  @override
  int? getIntValue(LocalStorageKey key) {
    return _prefs?.getInt(key.name);
  }

  @override
  bool? getBoolValue(LocalStorageKey key) {
    return _prefs?.getBool(key.name);
  }

  //Delete values
  @override
  Future<void> removeValue(LocalStorageKey key) async {
    await _prefs?.remove(key.name);
  }
  
}
