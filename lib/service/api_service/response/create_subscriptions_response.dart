import 'package:book_brain/service/api_service/response/base_response.dart';

class CreateSubscriptionsResponse extends BaseResponse {
  CreateSubscriptionsResponse({
    required this.subscriptionId,
    required this.userId,
    required this.bookId,
    required this.isActive,
    required this.subscribedAt,
  });

  final int? subscriptionId;
  final int? userId;
  final int? bookId;
  final bool? isActive;
  final DateTime? subscribedAt;

  factory CreateSubscriptionsResponse.fromJson(Map<String, dynamic> json){
    return CreateSubscriptionsResponse(
      subscriptionId: json["subscription_id"],
      userId: json["user_id"],
      bookId: json["book_id"],
      isActive: json["is_active"],
      subscribedAt: DateTime.tryParse(json["subscribed_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "subscription_id": subscriptionId,
    "user_id": userId,
    "book_id": bookId,
    "is_active": isActive,
    "subscribed_at": subscribedAt?.toIso8601String(),
  };

  @override
  String toString(){
    return "$subscriptionId, $userId, $bookId, $isActive, $subscribedAt, ";
  }
}
