import 'dart:convert';

class WithTimerResult {
  //final String id;
  final String name;
  final int score;

  WithTimerResult({
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

  factory WithTimerResult.fromMap(Map<String, dynamic> map) {
    return WithTimerResult(
      //id: map['id'] as String,
      name: map['name'] as String,
      score: map['score'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory WithTimerResult.fromJson(String source) => WithTimerResult.fromMap(json.decode(source) as Map<String, dynamic>);
}
