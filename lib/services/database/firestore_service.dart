import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dota2_invoker/models/timer_result.dart';
import 'package:dota2_invoker/models/challenger_result.dart';
import 'package:dota2_invoker/services/database/IDatabaseService.dart';
import 'package:dota2_invoker/services/database_service.dart';


class FirestoreService implements IDatabaseService {
  FirestoreService._();
  static FirestoreService? _instance;
  static FirestoreService get instance => _instance ??= FirestoreService._();

  final _collectionRefTimer = FirebaseFirestore.instance.collection(DatabaseTable.withTimer.name);
  final _collectionRefChallanger = FirebaseFirestore.instance.collection(DatabaseTable.challenger.name);

  @override
  Future<void> addChallengerScore(ChallengerResult score) async {
    try {
      await _collectionRefChallanger.add(score.toMap());
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> addTimerScore(TimerResult score) async {
    try {
      await _collectionRefTimer.add(score.toMap());
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<List<ChallengerResult>> getAllChallangerScores() async {
    try {
      var response = await _collectionRefChallanger.orderBy("score", descending: true).get();
      var data = response.docs;
      var results = data.map((e) => ChallengerResult.fromMap(e.data())).toList();
      return results;
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<List<TimerResult>> getAllTimerScores() async {
    try {
      var response = await _collectionRefTimer.orderBy("score", descending: true).get();
      var data = response.docs;
      var results = data.map((e) => TimerResult.fromMap(e.data())).toList();
      return results;
    } catch (e) {
      print(e);
      return [];
    }
  }

}