import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  });

  UserModel.guest({
    this.uid = null,
    required this.username,
    this.bestChallengerScore = 0,
    this.bestTimerScore = 0,
    this.level = 1,
    this.exp = 0,
    this.expMultiplier = 1,
    this.talentTree = const {
                        '10' : false,
                        '15' : false,
                        '20' : false,
                        '25' : false
                      }
  });

  String? uid;
  String username;
  int bestChallengerScore;
  int bestTimerScore;
  int level;
  double exp;
  double expMultiplier;
  Map<String,dynamic>? talentTree;

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
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
