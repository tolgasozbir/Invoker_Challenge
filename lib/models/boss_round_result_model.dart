import 'package:dota2_invoker_game/models/base_model.dart';

class BossBattleResult extends IBaseModel<BossBattleResult> {
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

  BossBattleResult({
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

  factory BossBattleResult.fromJson(Map<String, dynamic> json) {
    return BossBattleResult(
      uid: json['uid'] as String,
      name: json['name'] as String,
      round: json['round'] as int,
      boss: json['boss'] as String,
      time: json['time'] as int,
      averageDps: json['averageDps'] as double,
      maxDps: json['maxDps'] as double,
      physicalDamage: json['physicalDamage'] as double,
      magicalDamage: json['magicalDamage'] as double,
      items: List<String>.from(json['items'] as List<dynamic>),
    );
  }

  @override
  BossBattleResult fromJson(Map<String, dynamic> json) {
    return BossBattleResult.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => {
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
