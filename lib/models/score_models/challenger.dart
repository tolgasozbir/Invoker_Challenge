import '../base_models/base_model.dart';
import '../base_models/base_score_model.dart';

class Challenger extends IBaseModel<Challenger> with IScoreModel {
  @override
  final String? uid;
  @override
  final String? name;
  @override
  final int? score;
  @override
  final int? time;
  
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
