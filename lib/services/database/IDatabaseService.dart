import '../../models/boss_round_result_model.dart';
import '../../models/challenger.dart';
import '../../models/feedback_model.dart';
import '../../models/time_trial.dart';
import '../../models/user_model.dart';

abstract class IDatabaseService {
  Future<void> createOrUpdateUser(UserModel userModel);
  Future<UserModel?> getUserRecords(String uid);
  Future<List<TimeTrial>> getTimeTrialScores();
  Future<List<Challenger>> getChallangerScores();
  Future<List<BossBattleResult>> getBossScores(String bossName);
  Future<bool> addTimerScore(TimeTrial score);
  Future<bool> addChallengerScore(Challenger score);
  Future<bool> addBossScore(BossBattleResult score);
  Future<bool> sendFeedback(FeedbackModel feedbackModel);
  void dispose();
}
