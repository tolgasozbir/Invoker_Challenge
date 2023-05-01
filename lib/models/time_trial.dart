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

  factory TimeTrial.fromMap(Map<String, dynamic> map) {
    return TimeTrial(
      uid: map['uid'],
      name: map['name'],
      score: map['score'],
    );
  }

  @override
  TimeTrial fromMap(Map<String, dynamic> map) {
    return TimeTrial.fromMap(map);
  }
  
  @override
  Map<String, dynamic> toMap() => {
    'uid': uid,
    'name': name,
    'score': score,
  };
  
}
