import '../../models/boss_battle_result.dart';
import '../../models/challenger.dart';
import '../../models/combo.dart';
import '../../models/feedback_model.dart';
import '../../models/time_trial.dart';
import '../../models/user_model.dart';

abstract class IDatabaseService {
  //User
  Future<void> createOrUpdateUser(UserModel userModel);
  Future<UserModel?> getUserRecords(String uid);
  //Get Scores
  Future<List<Combo>> getComboScores();
  Future<List<TimeTrial>> getTimeTrialScores();
  Future<List<Challenger>> getChallangerScores();
  Future<List<BossBattleResult>> getBossScores(String bossName);
  //Set Scores
  Future<bool> addComboScore(Combo score);
  Future<bool> addTimerScore(TimeTrial score);
  Future<bool> addChallengerScore(Challenger score);
  Future<bool> addBossScore(BossBattleResult score);
  //Oth
  Future<bool> sendFeedback(FeedbackModel feedbackModel);
  void dispose();
}
