import 'dart:convert';

import 'package:dota2_invoker_game/models/base_model.dart';

class UserModel extends IBaseModel<UserModel> {
  String? uid;
  String username;
  int challangerLife;
  int bestChallengerScore;
  int bestTimerScore;
  int bestComboScore;
  int level;
  double exp;
  double expMultiplier;
  Map<String,dynamic>? talentTree;
  Map<String,dynamic>? achievements;
  Map<String,dynamic>? bestBossScores;
  String? lastPlayed;

  UserModel({
    required this.uid,
    required this.username,
    required this.challangerLife,
    required this.bestChallengerScore,
    required this.bestTimerScore,
    required this.bestComboScore,
    required this.level,
    required this.exp,
    required this.expMultiplier,
    required this.talentTree,
    required this.achievements,
    required this.bestBossScores,
    required this.lastPlayed,
  });

  UserModel.guest({
    this.uid,
    required this.username,
    this.challangerLife = 0,
    this.bestChallengerScore = 0,
    this.bestTimerScore = 0,
    this.bestComboScore = 0,
    this.level = 1,
    this.exp = 0,
    this.expMultiplier = 3,
    this.talentTree,
    this.achievements,
    this.bestBossScores,
    this.lastPlayed,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String?,
      username: map['username'] as String,
      challangerLife: map['challangerLife'] as int,
      bestChallengerScore: map['bestChallengerScore'] as int,
      bestTimerScore: map['bestTimerScore'] as int,
      bestComboScore: map['bestComboScore'] ?? 0,
      level: map['level'] as int,
      exp: double.tryParse(map['exp'].toString()) ?? 0, 
      expMultiplier: double.tryParse(map['expMultiplier'].toString()) ?? 0,
      talentTree: map['talentTree'] != null ? Map<String,dynamic>.from(map['talentTree'] as Map<String,dynamic>) : null,
      achievements: map['achievements'] != null ? Map<String,dynamic>.from(map['achievements'] as Map<String,dynamic>) : null,
      bestBossScores: map['bestBossScores'] != null ? Map<String,dynamic>.from(map['bestBossScores'] as Map<String,dynamic>) : null,
      lastPlayed: map['lastPlayed'] as String?,
    );
  }

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
  
  String toJson() => json.encode(toMap());

  @override
  UserModel fromMap(Map<String, dynamic> map) {
    return UserModel.fromMap(map);
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'username': username,
      'challangerLife' : challangerLife,
      'bestChallengerScore': bestChallengerScore,
      'bestTimerScore': bestTimerScore,
      'bestComboScore': bestComboScore,
      'level': level,
      'exp': exp,
      'expMultiplier': expMultiplier,
      'talentTree': talentTree,
      'achievements': achievements,
      'bestBossScores': bestBossScores,
      'lastPlayed' : lastPlayed,
    };
  }

}
