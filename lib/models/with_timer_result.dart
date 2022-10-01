import 'dart:convert';

class WithTimerResult {
  final String id;
  final String name;
  final int result;

  WithTimerResult({
    required this.id,
    required this.name,
    required this.result,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'result': result,
    };
  }

  factory WithTimerResult.fromMap(Map<String, dynamic> map) {
    return WithTimerResult(
      id: map['id'] as String,
      name: map['name'] as String,
      result: map['result'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory WithTimerResult.fromJson(String source) => WithTimerResult.fromMap(json.decode(source) as Map<String, dynamic>);
}
