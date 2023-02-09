import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/timer_result.dart';
import '../../models/challenger_result.dart';
import 'IDatabaseService.dart';
import '../../enums/database_table.dart';


class FirestoreService implements IDatabaseService {
  FirestoreService._();
  static FirestoreService? _instance;
  static FirestoreService get instance => _instance ??= FirestoreService._();

  final _collectionRefTimer = FirebaseFirestore.instance.collection(DatabaseTable.timer.name);
  final _collectionRefChallanger = FirebaseFirestore.instance.collection(DatabaseTable.challenger.name);
  final int _fetchLimit = 10;
  String orderByField = 'score';
  DocumentSnapshot? _lastDocument;
  bool _hasMoreData = true;

  @override
  Future<void> addChallengerScore(ChallengerResult score) async {
    try {
      await _collectionRefChallanger.add(score.toMap());
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<void> addTimerScore(TimerResult score) async {
    try {
      await _collectionRefTimer.add(score.toMap());
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<List<ChallengerResult>> getChallangerScores() async {
    if (!_hasMoreData) return [];
    
    QuerySnapshot<Map<String,dynamic>> snapshot;
    try {
      if (_lastDocument == null) {
        snapshot = await _collectionRefChallanger.orderBy(orderByField, descending: true).limit(_fetchLimit).get();
      } else {
        snapshot = await _collectionRefChallanger.
          orderBy(orderByField, descending: true)
          .limit(_fetchLimit)
          .startAfterDocument(_lastDocument!)
          .get();
      }

      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
      }

      if (snapshot.docs.length < _fetchLimit) {
        _hasMoreData = false;
      }
      
      return snapshot.docs.map((e) => ChallengerResult.fromMap(e.data())).toList();
    } 
    catch (e) {
      log(e.toString());
      return [];
    }
  }

  @override
  Future<List<TimerResult>> getTimerScores() async {
    if (!_hasMoreData) return [];
    
    QuerySnapshot<Map<String,dynamic>> snapshot;
    try {
      if (_lastDocument == null) {
        snapshot = await _collectionRefTimer.orderBy(orderByField, descending: true).limit(_fetchLimit).get();
      } else {
        snapshot = await _collectionRefTimer.
          orderBy(orderByField, descending: true)
          .limit(_fetchLimit)
          .startAfterDocument(_lastDocument!)
          .get();
      }

      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
      }

      if (snapshot.docs.length < _fetchLimit) {
        _hasMoreData = false;
      }

      return snapshot.docs.map((e) => TimerResult.fromMap(e.data())).toList();
    } 
    catch (e) {
      log(e.toString());
      return [];
    }
  }
  
  @override
  void dispose() {
    _hasMoreData = true;
    _lastDocument = null;
  }

}
