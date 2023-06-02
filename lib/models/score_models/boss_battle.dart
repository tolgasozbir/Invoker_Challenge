import '../base_models/base_model.dart';
import '../base_models/base_score_model.dart';

class BossBattle extends IBaseModel<BossBattle> with IScoreModel {
  @override
  final String? uid;
  @override
  final String name;
  final int round;
  final String boss;
  @override
  final int time;
  final double averageDps;
  final double maxDps;
  final double physicalDamage;
  final double magicalDamage;
  final List<String> items;

  BossBattle({
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

  factory BossBattle.fromMap(Map<String, dynamic> map) {
    return BossBattle(
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

  @override
  BossBattle fromMap(Map<String, dynamic> map) {
    return BossBattle.fromMap(map);
  }

  @override
  Map<String, dynamic> toMap() => {
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
