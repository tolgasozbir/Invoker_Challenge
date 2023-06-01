import '../base_models/base_model.dart';
import '../base_models/base_score_model.dart';

class TimeTrial extends IBaseModel<TimeTrial> with IScoreModel {
  @override
  final String? uid;
  @override
  final String? name;
  @override
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
