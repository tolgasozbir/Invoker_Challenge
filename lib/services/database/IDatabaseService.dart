import 'package:dota2_invoker_game/enums/Bosses.dart';

import '../../models/base_models/base_model.dart';
import '../../models/feedback_model.dart';
import '../../models/user_model.dart';
import 'firestore_service.dart';

abstract class IDatabaseService {
  Future<void> createOrUpdateUser(UserModel userModel);
  Future<UserModel?> getUserRecords(String uid);
  Future<List<T>> getScores<T extends IBaseModel<T>>({required ScoreType scoreType, Bosses? boss});
  Future<bool> addScore<T extends IBaseModel<T>>({required ScoreType scoreType, required T score});
  Future<bool> sendFeedback(FeedbackModel feedbackModel);
  void resetPagination();
}
