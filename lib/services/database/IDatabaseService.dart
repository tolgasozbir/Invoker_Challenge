import '../../models/challenger_result.dart';
import '../../models/timer_result.dart';

abstract class IDatabaseService {
  Future<List<TimerResult>> getTimerScores();
  Future<List<ChallengerResult>> getChallangerScores();
  Future<void> addTimerScore(TimerResult score);
  Future<void> addChallengerScore(ChallengerResult score);
  void dispose();
}
