import 'package:flutter/foundation.dart';
import 'base_model.dart';

@immutable
class TimeTrial extends IBaseModel<TimeTrial> {
  final String? uid;
  final String? name;
  final int? score;

  TimeTrial({
    this.uid,
    this.name,
    this.score,
  });

  factory TimeTrial.fromJson(Map<String, dynamic> json) {
    return TimeTrial(
      uid: json['uid'],
      name: json['name'],
      score: json['score'],
    );
  }

  @override
  TimeTrial fromJson(Map<String, dynamic> json) {
    return TimeTrial.fromJson(json);
  }
  
  @override
  Map<String, dynamic> toJson() => {
    'uid': uid,
    'name': name,
    'score': score,
  };
  
}
