import 'package:dota2_invoker_game/models/base_model.dart';

class UserModel extends IBaseModel<UserModel> {
  String? uid;
  String username;
  int challangerLife;
  int bestChallengerScore;
  int bestTimerScore;
  int level;
  double exp;
  double expMultiplier;
  Map<String,dynamic>? talentTree;
  Map<String,dynamic>? achievements;
  Map<String,dynamic>? bestBossScores;

  UserModel({
    required this.uid,
    required this.username,
    required this.challangerLife,
    required this.bestChallengerScore,
    required this.bestTimerScore,
    required this.level,
    required this.exp,
    required this.expMultiplier,
    required this.talentTree,
    required this.achievements,
    required this.bestBossScores,
  });

  UserModel.guest({
    this.uid,
    required this.username,
    this.challangerLife = 0,
    this.bestChallengerScore = 0,
    this.bestTimerScore = 0,
    this.level = 1,
    this.exp = 0,
    this.expMultiplier = 3,
    this.talentTree,
    this.achievements,
    this.bestBossScores,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String?,
      username: json['username'] as String,
      challangerLife: json['challangerLife'] as int,
      bestChallengerScore: json['bestChallengerScore'] as int,
      bestTimerScore: json['bestTimerScore'] as int,
      level: json['level'] as int,
      exp: double.tryParse(json['exp'].toString()) ?? 0, 
      expMultiplier: double.tryParse(json['expMultiplier'].toString()) ?? 0,
      talentTree: json['talentTree'] != null ? Map<String,dynamic>.from(json['talentTree'] as Map<String,dynamic>) : null,
      achievements: json['achievements'] != null ? Map<String,dynamic>.from(json['achievements'] as Map<String,dynamic>) : null,
      bestBossScores: json['bestBossScores'] != null ? Map<String,dynamic>.from(json['bestBossScores'] as Map<String,dynamic>) : null,
    );
  }

  @override
  UserModel fromJson(Map<String, dynamic> json) {
    return UserModel.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uid': uid,
      'username': username,
      'challangerLife' : challangerLife,
      'bestChallengerScore': bestChallengerScore,
      'bestTimerScore': bestTimerScore,
      'level': level,
      'exp': exp,
      'expMultiplier': expMultiplier,
      'talentTree': talentTree,
      'achievements': achievements,
      'bestBossScores': bestBossScores,
    };
  }

}
