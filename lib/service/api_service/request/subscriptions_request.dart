class SubscriptionsRequest {
  SubscriptionsRequest({
    required this.bookId,
    required this.action,
     this.notificationMethod,
  });

  final int? bookId;
  final String? action;
  final String? notificationMethod;

  factory SubscriptionsRequest.fromJson(Map<String, dynamic> json){
    return SubscriptionsRequest(
      bookId: json["book_id"],
      action: json["action"],
      notificationMethod: json["notification_method"],
    );
  }

  Map<String, dynamic> toJson() => {
    "book_id": bookId,
    "action": action,
    "notification_method": notificationMethod,
  };

  @override
  String toString(){
    return "$bookId, $action, $notificationMethod, ";
  }
}
