class HistoryResponse {
  HistoryResponse({
    required this.historyId,
    required this.bookId,
    required this.readingStatus,
    required this.startDate,
    required this.finishDate,
    required this.notes,
    required this.timesRead,
    required this.completionRate,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.excerpt,
    required this.views,
    required this.bookStatus,
    required this.rating,
    required this.authorId,
    required this.authorName,
    required this.categoryId,
    required this.categoryName,
    required this.totalChapters,
    required this.currentChapterId,
    required this.lastReadAt,
    required this.currentChapterTitle,
    required this.isFavorite,
  });

  final int? historyId;
  final int? bookId;
  final String? readingStatus;
  final DateTime? startDate;
  final dynamic finishDate;
  final String? notes;
  final int? timesRead;
  final String? completionRate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? title;
  final String? url;
  final String? imageUrl;
  final String? excerpt;
  final int? views;
  final String? bookStatus;
  final String? rating;
  final int? authorId;
  final String? authorName;
  final int? categoryId;
  final String? categoryName;
  final String? totalChapters;
  final dynamic currentChapterId;
  final DateTime? lastReadAt;
  final dynamic currentChapterTitle;
  final bool? isFavorite;

  factory HistoryResponse.fromJson(Map<String, dynamic> json){
    return HistoryResponse(
      historyId: json["history_id"],
      bookId: json["book_id"],
      readingStatus: json["reading_status"],
      startDate: DateTime.tryParse(json["start_date"] ?? ""),
      finishDate: json["finish_date"],
      notes: json["notes"],
      timesRead: json["times_read"],
      completionRate: json["completion_rate"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      title: json["title"],
      url: json["url"],
      imageUrl: json["image_url"],
      excerpt: json["excerpt"],
      views: json["views"],
      bookStatus: json["book_status"],
      rating: json["rating"],
      authorId: json["author_id"],
      authorName: json["author_name"],
      categoryId: json["category_id"],
      categoryName: json["category_name"],
      totalChapters: json["total_chapters"],
      currentChapterId: json["current_chapter_id"],
      lastReadAt: DateTime.tryParse(json["last_read_at"] ?? ""),
      currentChapterTitle: json["current_chapter_title"],
      isFavorite: json["is_favorite"],
    );
  }

  Map<String, dynamic> toJson() => {
    "history_id": historyId,
    "book_id": bookId,
    "reading_status": readingStatus,
    "start_date": startDate?.toIso8601String(),
    "finish_date": finishDate,
    "notes": notes,
    "times_read": timesRead,
    "completion_rate": completionRate,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "title": title,
    "url": url,
    "image_url": imageUrl,
    "excerpt": excerpt,
    "views": views,
    "book_status": bookStatus,
    "rating": rating,
    "author_id": authorId,
    "author_name": authorName,
    "category_id": categoryId,
    "category_name": categoryName,
    "total_chapters": totalChapters,
    "current_chapter_id": currentChapterId,
    "last_read_at": lastReadAt?.toIso8601String(),
    "current_chapter_title": currentChapterTitle,
    "is_favorite": isFavorite,
  };

  @override
  String toString(){
    return "$historyId, $bookId, $readingStatus, $startDate, $finishDate, $notes, $timesRead, $completionRate, $createdAt, $updatedAt, $title, $url, $imageUrl, $excerpt, $views, $bookStatus, $rating, $authorId, $authorName, $categoryId, $categoryName, $totalChapters, $currentChapterId, $lastReadAt, $currentChapterTitle, $isFavorite, ";
  }
}
