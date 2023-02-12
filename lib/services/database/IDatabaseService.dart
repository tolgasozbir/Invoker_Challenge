import 'package:dota2_invoker/models/user_model.dart';

import '../../models/challenger_result.dart';
import '../../models/timer_result.dart';

abstract class IDatabaseService {
  Future<void> createUser(UserModel userModel);
  Future<UserModel?> getUserRecords(String uid);
  Future<List<TimerResult>> getTimerScores();
  Future<List<ChallengerResult>> getChallangerScores();
  Future<void> addTimerScore(TimerResult score);
  Future<void> addChallengerScore(ChallengerResult score);
  void dispose();
}
