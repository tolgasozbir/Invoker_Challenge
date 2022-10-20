import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';

enum DatabaseTable { withTimer, challenger }

class DatabaseService {

  static DatabaseService? _instance;
  static DatabaseService get instance {
    if (_instance != null) {
      return _instance!;
    }
    _instance = DatabaseService._();
    return _instance!;
  }

  DatabaseService._();

  var _timerRef = FirebaseDatabase.instance.reference().child(DatabaseTable.withTimer.name);
  var _challangerRef = FirebaseDatabase.instance.reference().child(DatabaseTable.challenger.name);

  Future<void> addScore({required DatabaseTable table, required String name, required int score, int? time}) async {
    Map<String,dynamic> data = {
      "name" : name,
      "time" : time ?? 0,
      "score" : score
    };

    try {
      switch (table) {
        case DatabaseTable.withTimer:
          return await _timerRef.push().set(data);
        case DatabaseTable.challenger:
          return await _challangerRef.push().set(data);
      }
    } catch (e) {
      log(e.toString());
    }
  }
}