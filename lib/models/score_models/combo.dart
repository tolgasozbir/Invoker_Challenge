import '../base_models/base_model.dart';
import '../base_models/base_score_model.dart';

class Combo extends IBaseModel<Combo> with IScoreModel {
  @override
  final String? uid;
  @override
  final String? name;
  @override
  final int? score;

  Combo({
    this.uid,
    this.name,
    this.score,
  });

  factory Combo.fromMap(Map<String, dynamic> map) {
    return Combo(
      uid: map['uid'],
      name: map['name'],
      score: map['score'],
    );
  }

  @override
  Combo fromMap(Map<String, dynamic> map) {
    return Combo.fromMap(map);
  }
  
  @override
  Map<String, dynamic> toMap() => {
    'uid': uid,
    'name': name,
    'score': score,
  };
  
}
