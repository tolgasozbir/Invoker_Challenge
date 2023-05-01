import 'package:dota2_invoker_game/models/base_model.dart';
import 'package:flutter/foundation.dart';

@immutable
class Challenger extends IBaseModel<Challenger> {
  final String? uid;
  final String? name;
  final int? time;
  final int? score;
  
  Challenger({
    required this.uid,
    required this.name,
    required this.time,
    required this.score,
  });

  factory Challenger.fromMap(Map<String, dynamic> map) {
    return Challenger(
      uid: map['uid'],
      name: map['name'],
      time: map['time'],
      score: map['score'],
    );
  }

  @override
  Challenger fromMap(Map<String, dynamic> map) {
    return Challenger.fromMap(map);
  }

  @override
  Map<String, dynamic> toMap() => {
    'uid': uid,
    'name': name,
    'time': time,
    'score': score,
  };

}
