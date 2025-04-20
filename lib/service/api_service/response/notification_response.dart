class NotificationResponse {
  NotificationResponse({
    required this.notificationId,
    required this.bookId,
    required this.chapterId,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
    required this.bookTitle,
    required this.bookUrl,
    required this.bookImageUrl,
    required this.chapterTitle,
    required this.chapterUrl,
  });

  final int? notificationId;
  final int? bookId;
  final int? chapterId;
  final String? title;
  final String? message;
  final bool? isRead;
  final DateTime? createdAt;
  final String? bookTitle;
  final String? bookUrl;
  final String? bookImageUrl;
  final String? chapterTitle;
  final String? chapterUrl;

  factory NotificationResponse.fromJson(Map<String, dynamic> json){
    return NotificationResponse(
      notificationId: json["notification_id"],
      bookId: json["book_id"],
      chapterId: json["chapter_id"],
      title: json["title"],
      message: json["message"],
      isRead: json["is_read"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      bookTitle: json["book_title"],
      bookUrl: json["book_url"],
      bookImageUrl: json["book_image_url"],
      chapterTitle: json["chapter_title"],
      chapterUrl: json["chapter_url"],
    );
  }

  Map<String, dynamic> toJson() => {
    "notification_id": notificationId,
    "book_id": bookId,
    "chapter_id": chapterId,
    "title": title,
    "message": message,
    "is_read": isRead,
    "created_at": createdAt?.toIso8601String(),
    "book_title": bookTitle,
    "book_url": bookUrl,
    "book_image_url": bookImageUrl,
    "chapter_title": chapterTitle,
    "chapter_url": chapterUrl,
  };

  @override
  String toString(){
    return "$notificationId, $bookId, $chapterId, $title, $message, $isRead, $createdAt, $bookTitle, $bookUrl, $bookImageUrl, $chapterTitle, $chapterUrl, ";
  }
}
