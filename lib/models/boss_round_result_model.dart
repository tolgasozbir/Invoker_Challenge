import 'dart:convert';

class BossRoundResultModel {
  final String? uid;
  final String name;
  final int round;
  final String boss;
  final int time;
  final double averageDps;
  final double maxDps;
  final double physicalDamage;
  final double magicalDamage;
  final List<String> items;

  BossRoundResultModel({
    required this.uid,
    required this.name,
    required this.round,
    required this.boss,
    required this.time,
    required this.averageDps,
    required this.maxDps,
    required this.physicalDamage,
    required this.magicalDamage,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'round': round,
      'boss': boss,
      'time': time,
      'averageDps': averageDps,
      'maxDps': maxDps,
      'physicalDamage': physicalDamage,
      'magicalDamage': magicalDamage,
      'items': items,
    };
  }

  factory BossRoundResultModel.fromMap(Map<String, dynamic> map) {
    return BossRoundResultModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      round: map['round'] as int,
      boss: map['boss'] as String,
      time: map['time'] as int,
      averageDps: map['averageDps'] as double,
      maxDps: map['maxDps'] as double,
      physicalDamage: map['physicalDamage'] as double,
      magicalDamage: map['magicalDamage'] as double,
      items: List<String>.from(map['items'] as List<dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory BossRoundResultModel.fromJson(String source) => BossRoundResultModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
