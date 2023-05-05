import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants/app_strings.dart';
import '../../enums/database_table.dart';
import '../../extensions/string_extension.dart';
import '../../models/boss_battle_result.dart';
import '../../models/challenger.dart';
import '../../models/feedback_model.dart';
import '../../models/time_trial.dart';
import '../../models/user_model.dart';
import '../../widgets/app_snackbar.dart';
import 'IDatabaseService.dart';

class FirestoreService implements IDatabaseService {
  FirestoreService._();
  static FirestoreService? _instance;
  static FirestoreService get instance => _instance ??= FirestoreService._();

  final _collectionRefUsers = FirebaseFirestore.instance.collection('Users');
  final _collectionRefFeedbacks = FirebaseFirestore.instance.collection('Feedbacks');
  final _collectionRefTimeTrial = FirebaseFirestore.instance.collection(DatabaseTable.TimeTrial.name);
  final _collectionRefChallanger = FirebaseFirestore.instance.collection(DatabaseTable.Challenger.name);
  String orderByScore = 'score';
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
      errorSnackbar();
      return [];
    }
  }

  Future<bool> _setData(CollectionReference<Map<String, dynamic>> collectionRef, Map<String, dynamic> data) async {
    //Create if it does not exist, update if it does exist.
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
  Future<bool> addChallengerScore(Challenger result) async {
    final isDataAdded = await _setData(_collectionRefChallanger, result.toMap());
    return isDataAdded;
  }

  @override
  Future<bool> addTimerScore(TimeTrial result) async {
    final isDataAdded = await _setData(_collectionRefTimeTrial, result.toMap());
    return isDataAdded;
  }

  @override
  Future<bool> addBossScore(BossBattleResult score) async {
    final collectionPathName = 'Boss_${score.boss.capitalize()}';
    final collection = FirebaseFirestore.instance.collection(collectionPathName);
    final isDataAdded = await _setData(collection, score.toMap());
    return isDataAdded;
  }

  @override
  Future<List<BossBattleResult>> getBossScores(String bossName) async {
    final collectionPathName = 'Boss_${bossName.replaceAll(" ", "_")}';
    final collectionRef = FirebaseFirestore.instance.collection(collectionPathName);
    final response = await _fetchData(
      collectionRef, 
      orderByFieldName: orderByTime, 
      fetchLimit: 5,
    );
    return response.map((e) => BossBattleResult.fromMap(e.data())).toList();
  }

  @override
  Future<List<Challenger>> getChallangerScores() async {
    final response = await _fetchData(
      _collectionRefChallanger,
       orderByFieldName: orderByScore, 
       descending: true,
    );
    return response.map((e) => Challenger.fromMap(e.data())).toList(); 
  }

  @override
  Future<List<TimeTrial>> getTimeTrialScores() async {
    final response = await _fetchData(
      _collectionRefTimeTrial, 
      orderByFieldName: orderByScore, 
      descending: true,
    );
    return response.map((e) => TimeTrial.fromMap(e.data())).toList();
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
