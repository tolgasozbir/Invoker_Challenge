// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TimerResult {
  final String uid;
  final String name;
  final int score;

  TimerResult({
    required this.uid,
    required this.name,
    required this.score,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'score': score,
    };
  }

  factory TimerResult.fromMap(Map<String, dynamic> map) {
    return TimerResult(
      uid: map['uid'] as String,
      name: map['name'] as String,
      score: map['score'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory TimerResult.fromJson(String source) => TimerResult.fromMap(json.decode(source) as Map<String, dynamic>);
}
