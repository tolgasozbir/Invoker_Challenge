import 'dart:convert';

class ChallengerResult {
  final String uid;
  final String name;
  final int time;
  final int score;
  
  ChallengerResult({
    required this.uid,
    required this.name,
    required this.time,
    required this.score,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'time': time,
      'score': score,
    };
  }

  factory ChallengerResult.fromMap(Map<String, dynamic> map) {
    return ChallengerResult(
      uid: map['uid'] as String,
      name: map['name'] as String,
      time: map['time'] as int,
      score: map['score'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChallengerResult.fromJson(String source) => ChallengerResult.fromMap(json.decode(source) as Map<String, dynamic>);
}
