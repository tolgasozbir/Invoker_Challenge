import 'package:dota2_invoker/models/timer_result.dart';
import '../../models/challenger_result.dart';

abstract class IDatabaseService {
  Future<List<TimerResult>> getAllTimerScores();
  Future<List<ChallengerResult>> getAllChallangerScores();
  Future<void> addTimerScore(TimerResult score);
  Future<void> addChallengerScore(ChallengerResult score);
}