import 'dart:convert';

class Challenger {
  final String id;
  final String name;
  final int time;
  final int result;
  
  Challenger({
    required this.id,
    required this.name,
    required this.time,
    required this.result,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'time': time,
      'result': result,
    };
  }

  factory Challenger.fromMap(Map<String, dynamic> map) {
    return Challenger(
      id: map['id'] as String,
      name: map['name'] as String,
      time: map['time'] as int,
      result: map['result'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Challenger.fromJson(String source) => Challenger.fromMap(json.decode(source) as Map<String, dynamic>);
}
