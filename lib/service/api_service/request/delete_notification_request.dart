class DeleteNotificationRequest {
  DeleteNotificationRequest({
    required this.action,
    required this.notificationId,
  });

  final String? action;
  final int? notificationId;

  factory DeleteNotificationRequest.fromJson(Map<String, dynamic> json){
    return DeleteNotificationRequest(
      action: json["action"],
      notificationId: json["notification_id"],
    );
  }

  Map<String, dynamic> toJson() => {
    "action": action,
    "notification_id": notificationId,
  };

  @override
  String toString(){
    return "$action, $notificationId, ";
  }
}
