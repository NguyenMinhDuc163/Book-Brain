import 'package:book_brain/service/api_service/response/base_response.dart';

class DeleteSubscriptionsResponse extends BaseResponse{
  DeleteSubscriptionsResponse({
    required this.subscriptionId,
    required this.userId,
    required this.bookId,
    required this.isActive,
  });

  final int? subscriptionId;
  final int? userId;
  final int? bookId;
  final bool? isActive;

  factory DeleteSubscriptionsResponse.fromJson(Map<String, dynamic> json){
    return DeleteSubscriptionsResponse(
      subscriptionId: json["subscription_id"],
      userId: json["user_id"],
      bookId: json["book_id"],
      isActive: json["is_active"],
    );
  }

  Map<String, dynamic> toJson() => {
    "subscription_id": subscriptionId,
    "user_id": userId,
    "book_id": bookId,
    "is_active": isActive,
  };

  @override
  String toString(){
    return "$subscriptionId, $userId, $bookId, $isActive, ";
  }
}
