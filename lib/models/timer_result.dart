import 'dart:convert';

class TimerResult {
  //final String id;
  final String name;
  final int score;

  TimerResult({
    //required this.id,
    required this.name,
    required this.score,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      //'id': id,
      'name': name,
      'score': score,
    };
  }

  factory TimerResult.fromMap(Map<String, dynamic> map) {
    return TimerResult(
      //id: map['id'] as String,
      name: map['name'] as String,
      score: map['score'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory TimerResult.fromJson(String source) => TimerResult.fromMap(json.decode(source) as Map<String, dynamic>);
}
