import 'package:shared_preferences/shared_preferences.dart';

import '../../enums/local_storage_keys.dart';
import 'ILocalStorageService.dart';

class LocalStorageService implements ILocalStorageService {
  LocalStorageService._();

  static final LocalStorageService _instance = LocalStorageService._();
  static LocalStorageService get instance => _instance;
  
  late SharedPreferences _prefs;

  @override
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<void> setValue<T>(LocalStorageKey key, T value) async {
    await removeValue(key);
    if (value is String) {
      await _prefs.setString(key.name, value);
    } else if (value is int) {
      await _prefs.setInt(key.name, value);
    } else if (value is bool) {
      await _prefs.setBool(key.name, value);
    } else {
      throw ArgumentError('Unsupported value type');
    }
  }

  @override
  T? getValue<T>(LocalStorageKey key) {
    if (T == String) {
      return _prefs.getString(key.name) as T?;
    } else if (T == int) {
      return _prefs.getInt(key.name) as T?;
    } else if (T == bool) {
      return _prefs.getBool(key.name) as T?;
    }
    return null;
  }

  @override
  Future<void> removeValue(LocalStorageKey key) async {
    await _prefs.remove(key.name);
  }

   @override 
  Future<void> deleteAllValues() async {
    await _prefs.clear();
  }
  
}
