class DeleteNotificationResponse {
  DeleteNotificationResponse({
    required this.notificationId,
  });

  final int? notificationId;

  factory DeleteNotificationResponse.fromJson(Map<String, dynamic> json){
    return DeleteNotificationResponse(
      notificationId: json["notification_id"],
    );
  }

  Map<String, dynamic> toJson() => {
    "notification_id": notificationId,
  };

  @override
  String toString(){
    return "$notificationId, ";
  }
}
