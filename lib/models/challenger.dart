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

  factory Challenger.fromJson(Map<String, dynamic> json) {
    return Challenger(
      uid: json['uid'],
      name: json['name'],
      time: json['time'],
      score: json['score'],
    );
  }

  @override
  Challenger fromJson(Map<String, dynamic> json) {
    return Challenger.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => {
    'uid': uid,
    'name': name,
    'time': time,
    'score': score,
  };

}
