class NotificationRequest {
  NotificationRequest({
    required this.action,
    required this.bookId,
    required this.chapterId,
    required this.title,
    required this.message,
  });

  final String? action;
  final int? bookId;
  final int? chapterId;
  final String? title;
  final String? message;

  factory NotificationRequest.fromJson(Map<String, dynamic> json){
    return NotificationRequest(
      action: json["action"],
      bookId: json["book_id"],
      chapterId: json["chapter_id"],
      title: json["title"],
      message: json["message"],
    );
  }

  Map<String, dynamic> toJson() => {
    "action": action,
    "book_id": bookId,
    "chapter_id": chapterId,
    "title": title,
    "message": message,
  };

  @override
  String toString(){
    return "$action, $bookId, $chapterId, $title, $message, ";
  }
}
