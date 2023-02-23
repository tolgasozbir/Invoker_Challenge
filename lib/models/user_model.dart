import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  UserModel({
    required this.uid,
    required this.nickname,
    required this.maxChallengerScore,
    required this.maxTimerScore,
    required this.level,
    required this.exp,
    required this.expMultiplier,
    required this.talentTree,
  });

  UserModel.guest({
    this.uid = null,
    required this.nickname,
    this.maxChallengerScore = 0,
    this.maxTimerScore = 0,
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
  String nickname;
  int maxChallengerScore;
  int maxTimerScore;
  int level;
  double exp;
  double expMultiplier;
  Map<String,dynamic>? talentTree;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'nickname': nickname,
      'maxChallengerScore': maxChallengerScore,
      'maxTimerScore': maxTimerScore,
      'level': level,
      'exp': exp,
      'expMultiplier': expMultiplier,
      'talentTree': talentTree,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String?,
      nickname: map['nickname'] as String,
      maxChallengerScore: map['maxChallengerScore'] as int,
      maxTimerScore: map['maxTimerScore'] as int,
      level: map['level'] as int,
      exp: double.tryParse(map['exp'].toString()) ?? 0, 
      expMultiplier: double.tryParse(map['expMultiplier'].toString()) ?? 0,
      talentTree: map['talentTree'] != null ? Map<String,dynamic>.from((map['talentTree'] as Map<String,dynamic>)) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
