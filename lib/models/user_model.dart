import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../services/hive/IBaseHiveService.dart';
import '../services/iap/revenuecat_service.dart';
import 'base_models/base_model.dart';

part 'user_model.g.dart';

@HiveType(typeId: HiveTypeIds.userTypeId)
class UserModel extends IBaseModel<UserModel> {

  @HiveField(0)
  String? uid;
  @HiveField(1)
  String username;
  @HiveField(2)
  int challangerLife;
  @HiveField(3)
  int bestChallengerScore;
  @HiveField(4)
  int bestTimerScore;
  @HiveField(5)
  int bestComboScore;
  @HiveField(6)
  int level;
  @HiveField(7)
  double exp;
  @HiveField(8)
  double expMultiplier;
  @HiveField(9)
  Map<String,dynamic>? talentTree;
  @HiveField(10)
  Map<String,dynamic>? achievements;
  @HiveField(11)
  Map<String,dynamic>? bestBossScores;
  @HiveField(12)
  String? lastPlayed;

  // abonelik
  @HiveField(13)
  bool? isSubscribed;
  @HiveField(14)
  int? subscriptionCount;
  @HiveField(15)
  String? lastSubscriptionDate;
  @HiveField(16)
  List<String>? subscriptionHistory;

  // tekil satın alma
  @HiveField(17)
  bool? hasPurchased;
  @HiveField(18)
  int? purchaseCount;
  @HiveField(19)
  String? lastPurchaseDate;
  
  @HiveField(20)
  bool? isAdminGrantedPremium;

  @HiveField(21)
  bool? isPremiumSuspended;

  UserModel({
    required this.uid,
    required this.username,
    required this.challangerLife,
    required this.bestChallengerScore,
    required this.bestTimerScore,
    required this.bestComboScore,
    required this.level,
    required this.exp,
    required this.expMultiplier,
    required this.talentTree,
    required this.achievements,
    required this.bestBossScores,
    required this.lastPlayed,
    required this.isSubscribed,
    required this.subscriptionCount,
    required this.lastSubscriptionDate,
    required this.subscriptionHistory,
    required this.hasPurchased,
    required this.purchaseCount,
    required this.lastPurchaseDate,
    required this.isAdminGrantedPremium,
    required this.isPremiumSuspended,
  });

  UserModel.guest({
    this.uid,
    required this.username,
    this.challangerLife = 0,
    this.bestChallengerScore = 0,
    this.bestTimerScore = 0,
    this.bestComboScore = 0,
    this.level = 1,
    this.exp = 0,
    this.expMultiplier = 3,
    this.talentTree,
    this.achievements,
    this.bestBossScores,
    this.lastPlayed,
    this.isSubscribed = false,
    this.subscriptionCount = 0,
    this.lastSubscriptionDate,
    this.subscriptionHistory = const [],
    this.hasPurchased = false,
    this.purchaseCount = 0,
    this.lastPurchaseDate,
    this.isAdminGrantedPremium = false,
    this.isPremiumSuspended = false,
  });

  bool get isPremium {
    if (isPremiumSuspended ?? false) return false;
    if (isAdminGrantedPremium ?? false) return true;
    if (hasPurchased ?? false) return true;
    if (_totalSubscriptionDurationInDays >= 60) return true;
    if (RevenueCatService.instance.isSubscribed) return true;
    return false;
  }

  int get _totalSubscriptionDurationInDays {
    if (subscriptionHistory == null || subscriptionHistory!.length < 2) return 0;

    final parsedDates = subscriptionHistory!
        .map((e) => DateTime.tryParse(e))
        .whereType<DateTime>()
        .toList()
      ..sort();

    if (parsedDates.length < 2) return 0;

    final first = parsedDates.first;
    final last = parsedDates.last;

    return last.difference(first).inDays;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String?,
      username: map['username'] as String,
      challangerLife: map['challangerLife'] as int,
      bestChallengerScore: map['bestChallengerScore'] as int,
      bestTimerScore: map['bestTimerScore'] as int,
      bestComboScore: map['bestComboScore'] ?? 0,
      level: map['level'] as int,
      exp: double.tryParse(map['exp'].toString()) ?? 0, 
      expMultiplier: double.tryParse(map['expMultiplier'].toString()) ?? 0,
      talentTree: map['talentTree'] != null ? Map<String,dynamic>.from(map['talentTree'] as Map<String,dynamic>) : null,
      achievements: map['achievements'] != null ? Map<String,dynamic>.from(map['achievements'] as Map<String,dynamic>) : null,
      bestBossScores: map['bestBossScores'] != null ? Map<String,dynamic>.from(map['bestBossScores'] as Map<String,dynamic>) : null,
      lastPlayed: map['lastPlayed'] as String?,
      isSubscribed: map['isSubscribed'] as bool? ?? false,
      subscriptionCount: map['subscriptionCount'] as int? ?? 0,
      lastSubscriptionDate: map['lastSubscriptionDate'] as String?,
      subscriptionHistory: map['subscriptionHistory'] != null ? List<String>.from(map['subscriptionHistory']) : [],
      hasPurchased: map['hasPurchased'] as bool? ?? false,
      purchaseCount: map['purchaseCount'] as int? ?? 0,
      lastPurchaseDate: map['lastPurchaseDate'] as String?,
      isAdminGrantedPremium: map['isAdminGrantedPremium'] as bool? ?? false,
      isPremiumSuspended: map['isPremiumSuspended'] as bool? ?? false,
    );
  }

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
  
  String toJson() => json.encode(toMap());

  @override
  UserModel fromMap(Map<String, dynamic> map) {
    return UserModel.fromMap(map);
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'username': username,
      'challangerLife': challangerLife,
      'bestChallengerScore': bestChallengerScore,
      'bestTimerScore': bestTimerScore,
      'bestComboScore': bestComboScore,
      'level': level,
      'exp': exp,
      'expMultiplier': expMultiplier,
      'talentTree': talentTree,
      'achievements': achievements,
      'bestBossScores': bestBossScores,
      'lastPlayed' : lastPlayed,
      'isSubscribed': isSubscribed,
      'subscriptionCount': subscriptionCount,
      'lastSubscriptionDate': lastSubscriptionDate,
      'subscriptionHistory': subscriptionHistory,
      'hasPurchased': hasPurchased,
      'purchaseCount': purchaseCount,
      'lastPurchaseDate': lastPurchaseDate,
      'isAdminGrantedPremium' : isAdminGrantedPremium,
      'isPremiumSuspended' : isPremiumSuspended,
    };
  }

}
