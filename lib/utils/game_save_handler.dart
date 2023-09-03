import 'dart:convert';

import '../enums/local_storage_keys.dart';
import '../services/app_services.dart';

class GameSaveHandler {
  GameSaveHandler._();
  
  static GameSaveHandler? _instance;
  static GameSaveHandler get instance => _instance ??= GameSaveHandler._();

  Future<void> saveGame(SaveProps props) async {
    await AppServices.instance.localStorageService.setValue<String>(
      LocalStorageKey.savedGame, 
      props.toJson(),
    );
  }

  Future<SaveProps?> loadGame() async {
    final records = AppServices.instance.localStorageService.getValue<String>(LocalStorageKey.savedGame);
    if (records == null) {
      return null;
    }
    return SaveProps.fromJson(records);
  }

  Future<void> deleteSavedGame() async {
    await AppServices.instance.localStorageService.removeValue(LocalStorageKey.savedGame);
  }

}

class SaveProps {
  //Boss Battle Props
  final int roundProgress;
  final int userGold;
  final List<String> inventoryItems;
  final List<String>? consumableItems;

  SaveProps(
    this.roundProgress,
    this.userGold,
    this.inventoryItems,
    this.consumableItems,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'roundProgress': roundProgress,
      'userGold': userGold,
      'inventoryItems': inventoryItems,
      'consumableItems': consumableItems ?? [],
    };
  }

  factory SaveProps.fromMap(Map<String, dynamic> map) {
    return SaveProps(
      map['roundProgress'] as int,
      map['userGold'] as int,
      List<String>.from(map['inventoryItems'] as List<dynamic>),
      List<String>.from(map['consumableItems'] as List<dynamic>? ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory SaveProps.fromJson(String source) => SaveProps.fromMap(json.decode(source) as Map<String, dynamic>);
}
