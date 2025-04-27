class UpdateHistoryRequest {
  UpdateHistoryRequest({
    required this.bookId,
    required this.readingStatus,
    required this.completionRate,
    required this.notes,
  });

  final int? bookId;
  final String? readingStatus;
  final double? completionRate;
  final String? notes;

  factory UpdateHistoryRequest.fromJson(Map<String, dynamic> json){
    return UpdateHistoryRequest(
      bookId: json["book_id"],
      readingStatus: json["reading_status"],
      completionRate: json["completion_rate"],
      notes: json["notes"],
    );
  }

  Map<String, dynamic> toJson() => {
    "book_id": bookId,
    "reading_status": readingStatus,
    "completion_rate": completionRate,
    "notes": notes,
  };

  @override
  String toString(){
    return "$bookId, $readingStatus, $completionRate, $notes, ";
  }
}
