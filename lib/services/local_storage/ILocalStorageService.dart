import '../../enums/local_storage_keys.dart';

abstract class ILocalStorageService {
  Future<void> init();
  Future<void> setStringValue(LocalStorageKey key, String value);  
  Future<void> setIntValue(LocalStorageKey key, int value);
  Future<void> setBoolValue(LocalStorageKey key, bool value);
  String? getStringValue(LocalStorageKey key);
  int? getIntValue(LocalStorageKey key);
  bool? getBoolValue(LocalStorageKey key);
  Future<void> removeValue(LocalStorageKey key);
}