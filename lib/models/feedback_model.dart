class FeedbackModel {
  String? senderId;
  String sender;
  int ratePoint;
  String message;
  String createdAt;

  FeedbackModel({
    this.senderId,
    required this.sender,
    required this.ratePoint,
    required this.message,
    required this.createdAt
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'senderName': sender,
      'ratePoint': ratePoint,
      'message': message,
      'createdAt' : createdAt,
    };
  }
}
