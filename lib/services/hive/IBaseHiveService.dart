import 'package:hive_flutter/hive_flutter.dart';

enum HiveBoxNames { user }

class HiveTypeIds {
  static const userTypeId = 0;
}

class IBaseHiveService<T> {
  IBaseHiveService({required this.boxName, required this.adapter});

  final HiveBoxNames boxName;
  final TypeAdapter<T>? adapter;
  Box<T>? box;

  Future<void> init() async {
    registerAdapters();
    await openBox();
  }

  void registerAdapters() {
    if (!Hive.isAdapterRegistered(boxName.index) && adapter != null) {
      Hive.registerAdapter(adapter!);
    }
  }

  Future<void> openBox() async {
    if (!(box?.isOpen ?? false)) {
      box = await Hive.openBox(boxName.name);
    }
  }

  Future<void> closeBox() async {
    await box?.close();
  }

  T? getItem(String key) {
    return box?.get(key);
  }

  Future<void> putItem(String key, T item) async {
    await box?.put(key, item);
  }

  Future<void> removeItem(String key) async {
    await box?.delete(key);
  }

  Future<void> clearAll() async {
    await box?.clear();
  }

}
