import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants/app_strings.dart';
import '../../enums/database_table.dart';
import '../../extensions/string_extension.dart';
import '../../models/boss_round_result_model.dart';
import '../../models/challenger_result.dart';
import '../../models/feedback_model.dart';
import '../../models/timer_result.dart';
import '../../models/user_model.dart';
import '../../widgets/app_snackbar.dart';
import 'IDatabaseService.dart';

class FirestoreService implements IDatabaseService {
  FirestoreService._();
  static FirestoreService? _instance;
  static FirestoreService get instance => _instance ??= FirestoreService._();

  final _collectionRefUsers = FirebaseFirestore.instance.collection('Users');
  final _collectionRefFeedbacks = FirebaseFirestore.instance.collection('Feedbacks');
  final _collectionRefTimer = FirebaseFirestore.instance.collection(DatabaseTable.timer.name);
  final _collectionRefChallanger = FirebaseFirestore.instance.collection(DatabaseTable.challenger.name);
  final int _fetchLimit = 10;
  final int _fetchLimitBoss = 5;
  String orderByField = 'score';
  String orderByTime = 'time';
  DocumentSnapshot? _lastDocument;
  bool _hasMoreData = true;

  void errorSnackbar() => AppSnackBar.showSnackBarMessage(
    text: AppStrings.errorMessage, 
    snackBartype: SnackBarType.error,
  );

  void _noMoreSnackbar() => AppSnackBar.showSnackBarMessage(
    text: AppStrings.sbNoMoreData, 
    snackBartype: SnackBarType.info,
  );

  @override
  Future<void> createOrUpdateUser(UserModel userModel) async {
    //if not exist create if exist update
    try {
      if (userModel.uid == null) throw Exception('uuid cant be null');
      await _collectionRefUsers.doc(userModel.uid).set(userModel.toMap())
        .timeout(const Duration(milliseconds: 5000), onTimeout: () { return; });
    } catch (e) {
      log(e.toString());
    }
  }
  
  @override
  Future<UserModel?> getUserRecords(String uid) async {
    try {
      final response = await _collectionRefUsers.doc(uid).get(const GetOptions(source: Source.server));
      if (response.data() != null) {
        return UserModel.fromMap(response.data()!);
      }
      throw Exception('data is null');
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  @override
  Future<bool> addChallengerScore(ChallengerResult result) async {
    try {
      await _collectionRefChallanger.doc(result.uid).set(result.toMap());
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  @override
  Future<bool> addTimerScore(TimerResult result) async {
    try {
      await _collectionRefTimer.doc(result.uid).set(result.toMap());
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  @override
  Future<bool> addBossScore(BossRoundResultModel score) async {
    final collectionPathName = 'Boss_${score.boss.capitalize()}';
    final collection = FirebaseFirestore.instance.collection(collectionPathName);
    try {
      await collection.doc(score.uid).set(score.toMap());
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  @override
  Future<List<BossRoundResultModel>> getBossScores(String bossName) async {
    if (!_hasMoreData) {
      _noMoreSnackbar();
      return [];
    }
    final collectionPathName = 'Boss_${bossName.capitalize()}';
    final collection = FirebaseFirestore.instance.collection(collectionPathName);
    QuerySnapshot<Map<String,dynamic>> snapshot;
    try {
      if (_lastDocument == null) {
        snapshot = await collection.orderBy(orderByTime).limit(_fetchLimitBoss).get();
      } else {
        snapshot = await collection.
          orderBy(orderByTime)
          .limit(_fetchLimitBoss)
          .startAfterDocument(_lastDocument!)
          .get();
      }

      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
      }

      if (snapshot.docs.length < _fetchLimitBoss) {
        _hasMoreData = false;
      }

      final data =  snapshot.docs.map((e) => BossRoundResultModel.fromMap(e.data())).toList();
      return data;
    } 
    catch (e) {
      log(e.toString());
      errorSnackbar();
      return [];
    }
  }

  @override
  Future<List<ChallengerResult>> getChallangerScores() async {
    if (!_hasMoreData) {
      _noMoreSnackbar();
      return [];
    }
    
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
      errorSnackbar();
      return [];
    }
  }

  @override
  Future<List<TimerResult>> getTimerScores() async {
    if (!_hasMoreData) {
      _noMoreSnackbar();
      return [];
    }
    
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
      errorSnackbar();
      return [];
    }
  }
  
  @override
  Future<bool> sendFeedback(FeedbackModel feedbackModel) async {
    try {
      await _collectionRefFeedbacks.add(feedbackModel.toMap());
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  @override
  void dispose() {
    _hasMoreData = true;
    _lastDocument = null;
  }

}
