class UpdateHistoryResponse {
  UpdateHistoryResponse({
    required this.historyId,
    required this.userId,
    required this.bookId,
    required this.readingStatus,
    required this.startDate,
    required this.finishDate,
    required this.timesRead,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.completionRate,
  });

  final int? historyId;
  final int? userId;
  final int? bookId;
  final String? readingStatus;
  final DateTime? startDate;
  final dynamic finishDate;
  final int? timesRead;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? completionRate;

  factory UpdateHistoryResponse.fromJson(Map<String, dynamic> json){
    return UpdateHistoryResponse(
      historyId: json["history_id"],
      userId: json["user_id"],
      bookId: json["book_id"],
      readingStatus: json["reading_status"],
      startDate: DateTime.tryParse(json["start_date"] ?? ""),
      finishDate: json["finish_date"],
      timesRead: json["times_read"],
      notes: json["notes"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      completionRate: json["completion_rate"],
    );
  }

  Map<String, dynamic> toJson() => {
    "history_id": historyId,
    "user_id": userId,
    "book_id": bookId,
    "reading_status": readingStatus,
    "start_date": startDate?.toIso8601String(),
    "finish_date": finishDate,
    "times_read": timesRead,
    "notes": notes,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "completion_rate": completionRate,
  };

  @override
  String toString(){
    return "$historyId, $userId, $bookId, $readingStatus, $startDate, $finishDate, $timesRead, $notes, $createdAt, $updatedAt, $completionRate, ";
  }
}
