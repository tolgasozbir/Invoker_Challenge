import '../../models/challenger_result.dart';
import '../../models/timer_result.dart';

abstract class IDatabaseService {
  Future<List<TimerResult>> getAllTimerScores();
  Future<List<ChallengerResult>> getAllChallangerScores();
  Future<void> addTimerScore(TimerResult score);
  Future<void> addChallengerScore(ChallengerResult score);
}