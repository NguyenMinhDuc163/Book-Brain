class UpdateHistoryRequest {
  UpdateHistoryRequest({
    required this.bookId,
    required this.readingStatus,
    required this.completionRate,
    required this.notes,
    required this.currentChapterId,
  });

  final int? bookId;
  final String? readingStatus;
  final double? completionRate;
  final String? notes;
  final int? currentChapterId;

  factory UpdateHistoryRequest.fromJson(Map<String, dynamic> json){
    return UpdateHistoryRequest(
      bookId: json["book_id"],
      readingStatus: json["reading_status"],
      completionRate: json["completion_rate"],
      notes: json["notes"],
      currentChapterId: json["current_chapter_id"],
    );
  }

  Map<String, dynamic> toJson() => {
    "book_id": bookId,
    "reading_status": readingStatus,
    "completion_rate": completionRate,
    "notes": notes,
    "current_chapter_id": currentChapterId,
  };

  @override
  String toString(){
    return "$bookId, $readingStatus, $completionRate, $notes, $currentChapterId";
  }
}
