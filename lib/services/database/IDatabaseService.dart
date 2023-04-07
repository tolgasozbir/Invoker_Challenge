import '../../models/challenger_result.dart';
import '../../models/feedback_model.dart';
import '../../models/timer_result.dart';
import '../../models/user_model.dart';

abstract class IDatabaseService {
  Future<void> createOrUpdateUser(UserModel userModel);
  Future<UserModel?> getUserRecords(String uid);
  Future<List<TimerResult>> getTimerScores();
  Future<List<ChallengerResult>> getChallangerScores();
  Future<bool> addTimerScore(TimerResult score);
  Future<bool> addChallengerScore(ChallengerResult score);
  Future<bool> addBossScore(String uid, Map<String,dynamic> score);
  Future<bool> sendFeedback(FeedbackModel feedbackModel);
  void dispose();
}
