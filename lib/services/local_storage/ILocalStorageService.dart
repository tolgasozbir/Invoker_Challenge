import '../../enums/local_storage_keys.dart';

abstract class ILocalStorageService {
  Future<void> init();
  Future<void> setValue<T>(LocalStorageKey key, T value);
  T? getValue<T>(LocalStorageKey key);
  Future<void> removeValue(LocalStorageKey key);
  Future<void> deleteAllValues();
}
