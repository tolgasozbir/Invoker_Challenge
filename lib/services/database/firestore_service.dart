import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants/app_strings.dart';
import '../../enums/database_table.dart';
import '../../extensions/string_extension.dart';
import '../../models/base_models/base_model.dart';
import '../../models/feedback_model.dart';
import '../../models/score_models/boss_battle.dart';
import '../../models/score_models/challenger.dart';
import '../../models/score_models/combo.dart';
import '../../models/score_models/time_trial.dart';
import '../../models/user_model.dart';
import '../../widgets/app_snackbar.dart';
import 'IDatabaseService.dart';

enum ScoreType { TimeTrial, Challenger, Combo, Boss }

class FirestoreService implements IDatabaseService {
  FirestoreService._();
  static FirestoreService? _instance;
  static FirestoreService get instance => _instance ??= FirestoreService._();

  final _collectionRefUsers       = FirebaseFirestore.instance.collection('Users');
  final _collectionRefFeedbacks   = FirebaseFirestore.instance.collection('Feedbacks');
  final _collectionRefChallanger  = FirebaseFirestore.instance.collection(DatabaseTable.Challenger.name);
  final _collectionRefTimeTrial   = FirebaseFirestore.instance.collection(DatabaseTable.TimeTrial.name);
  final _collectionRefCombo       = FirebaseFirestore.instance.collection(DatabaseTable.Combo.name);

  final String _orderByScore = 'score';
  final String _orderByTime  = 'time';
  DocumentSnapshot? _lastDocument;
  bool _hasMoreData = true;

  void _errorSnackbar() => AppSnackBar.showSnackBarMessage(
    text: AppStrings.errorMessage, 
    snackBartype: SnackBarType.error,
  );

  void _noMoreSnackbar() => AppSnackBar.showSnackBarMessage(
    text: AppStrings.sbNoMoreData, 
    snackBartype: SnackBarType.info,
  );

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _fetchData(
    CollectionReference<Map<String, dynamic>> collectionRef, {
    required String orderByFieldName,
    bool descending = false,
    int fetchLimit = 10,
  }) async {

    if (!_hasMoreData) {
      _noMoreSnackbar();
      return [];
    }

    QuerySnapshot<Map<String,dynamic>> snapshot;
    try {
      if (_lastDocument == null) {
        snapshot = await collectionRef.orderBy(orderByFieldName, descending: descending).limit(fetchLimit).get();
      } else {
        snapshot = await collectionRef.
          orderBy(orderByFieldName, descending: descending)
          .limit(fetchLimit)
          .startAfterDocument(_lastDocument!)
          .get();
      }

      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
      }

      if (snapshot.docs.length < fetchLimit) {
        _hasMoreData = false;
      }
      
      return snapshot.docs;
    } 
    catch (e) {
      log('An error occurred: $e');
      _errorSnackbar();
      return [];
    }
  }

  Future<bool> _setData(CollectionReference<Map<String, dynamic>> collectionRef, Map<String, dynamic> data) async {
    if (data['uid'] == null) return false;
    try {
      await collectionRef.doc(data['uid']).set(data)
        .timeout(const Duration(milliseconds: 5000), onTimeout: () => log('Timeout occurred.'));
      return true;
    } catch (e) {
      log('An error occurred: $e');
      return false;
    }
  }

  ///Create if it does not exist, update if it does exist.
  @override
  Future<void> createOrUpdateUser(UserModel userModel) async {
    await _setData(_collectionRefUsers, userModel.toMap());
  }
  
  @override
  Future<UserModel?> getUserRecords(String uid) async {
    try {
      final response = await _collectionRefUsers.doc(uid).get(const GetOptions(source: Source.server));
      if (response.data() == null) throw Exception('data null');
      return UserModel.fromMap(response.data()!);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  @override
  Future<bool> addScore<T extends IBaseModel<T>>({required ScoreType scoreType, required T score}) async {
    switch (scoreType) {
      case ScoreType.TimeTrial:
        return _setData(_collectionRefTimeTrial, score.toMap());
      case ScoreType.Challenger:
        return _setData(_collectionRefChallanger, score.toMap());
      case ScoreType.Combo:
        return _setData(_collectionRefCombo, score.toMap());
      case ScoreType.Boss:
        final bossScore = score as BossBattle;
        final collectionPathName = 'Boss_${bossScore.boss.capitalize()}';
        final collection = FirebaseFirestore.instance.collection(collectionPathName);
        return _setData(collection, score.toMap());
    }
  }

  @override
  Future<List<T>> getScores<T extends IBaseModel<T>>({required ScoreType scoreType, String? bossName}) async {
    assert(!(scoreType == ScoreType.Boss && bossName == null), 'Boss name is required');
    switch (scoreType) {
      case ScoreType.TimeTrial:
        final response = await _fetchData(
          _collectionRefTimeTrial,
          orderByFieldName: _orderByScore,
          descending: true,
        );
        return response.map((e) => TimeTrial.fromMap(e.data()) as T).toList();
      case ScoreType.Challenger:
        final response = await _fetchData(
          _collectionRefChallanger,
          orderByFieldName: _orderByScore,
          descending: true,
        );
        return response.map((e) => Challenger.fromMap(e.data()) as T).toList();
      case ScoreType.Combo:
        final response = await _fetchData(
          _collectionRefCombo,
          orderByFieldName: _orderByScore,
          descending: true,
        );
        return response.map((e) => Combo.fromMap(e.data()) as T).toList();
      case ScoreType.Boss:
        if (bossName == null) 
          throw ArgumentError('Boss name must be provided for fetching boss scores.');

        final collectionPathName = 'Boss_${bossName.replaceAll(" ", "_")}';
        final collectionRef = FirebaseFirestore.instance.collection(collectionPathName);
        final response = await _fetchData(
          collectionRef,
          orderByFieldName: _orderByTime,
          fetchLimit: 5,
        );
        return response.map((e) => BossBattle.fromMap(e.data()) as T).toList();
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
  void resetPagination() {
    _hasMoreData = true;
    _lastDocument = null;
  }

}
