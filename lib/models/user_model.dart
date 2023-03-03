import 'dart:convert';

class UserModel {
  UserModel({
    required this.uid,
    required this.username,
    required this.bestChallengerScore,
    required this.bestTimerScore,
    required this.level,
    required this.exp,
    required this.expMultiplier,
    required this.talentTree,
    required this.achievements,
  });

  UserModel.guest({
    this.uid = null,
    required this.username,
    this.bestChallengerScore = 0,
    this.bestTimerScore = 0,
    this.level = 1,
    this.exp = 0,
    this.expMultiplier = 1,
    this.achievements = const [],
    this.talentTree = const {
                        '10' : false,
                        '15' : false,
                        '20' : false,
                        '25' : false
                      },
  });

  String? uid;
  String username;
  int bestChallengerScore;
  int bestTimerScore;
  int level;
  double exp;
  double expMultiplier;
  Map<String,dynamic>? talentTree;
  List<UserAchievementModel?> achievements;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'username': username,
      'bestChallengerScore': bestChallengerScore,
      'bestTimerScore': bestTimerScore,
      'level': level,
      'exp': exp,
      'expMultiplier': expMultiplier,
      'talentTree': talentTree,
      'achievements': achievements.map((x) => x?.toMap()).toList(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String?,
      username: map['username'] as String,
      bestChallengerScore: map['bestChallengerScore'] as int,
      bestTimerScore: map['bestTimerScore'] as int,
      level: map['level'] as int,
      exp: double.tryParse(map['exp'].toString()) ?? 0, 
      expMultiplier: double.tryParse(map['expMultiplier'].toString()) ?? 0,
      talentTree: map['talentTree'] != null ? Map<String,dynamic>.from((map['talentTree'] as Map<String,dynamic>)) : null,
      achievements: List<UserAchievementModel>.from((map['achievements'] as List<dynamic>).map<UserAchievementModel?>((x) => UserAchievementModel.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class UserAchievementModel {
  final String id;
  int currentProgress;
  
  UserAchievementModel({
    required this.id,
    required this.currentProgress,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'currentProgress': currentProgress,
    };
  }

  factory UserAchievementModel.fromMap(Map<String, dynamic> map) {
    return UserAchievementModel(
      id: map['id'] as String,
      currentProgress: map['currentProgress'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserAchievementModel.fromJson(String source) => UserAchievementModel.fromMap(json.decode(source) as Map<String, dynamic>);
}