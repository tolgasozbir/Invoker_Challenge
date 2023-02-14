import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dota2_invoker/models/user_model.dart';

import '../../enums/database_table.dart';
import '../../models/challenger_result.dart';
import '../../models/timer_result.dart';
import 'IDatabaseService.dart';

class FirestoreService implements IDatabaseService {
  FirestoreService._();
  static FirestoreService? _instance;
  static FirestoreService get instance => _instance ??= FirestoreService._();

  final _collectionRefUsers = FirebaseFirestore.instance.collection('Users');
  final _collectionRefTimer = FirebaseFirestore.instance.collection(DatabaseTable.timer.name);
  final _collectionRefChallanger = FirebaseFirestore.instance.collection(DatabaseTable.challenger.name);
  final int _fetchLimit = 10;
  String orderByField = 'score';
  DocumentSnapshot? _lastDocument;
  bool _hasMoreData = true;

  @override
  Future<void> createOrUpdateUser(UserModel userModel) async {
    //if not exist create if exist update
    try {
      if (userModel.uid == null) throw Exception("uuid cant be null");
      await _collectionRefUsers.doc(userModel.uid).set((userModel.toMap()));
    } catch (e) {
      log(e.toString());
    }
  }
  
  @override
  Future<UserModel?> getUserRecords(String uid) async {
    try {
      var response = await _collectionRefUsers.doc(uid).get();
      return UserModel.fromMap(response.data()!);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

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
