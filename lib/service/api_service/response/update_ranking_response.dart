class UpdateRankingResponse {
  UpdateRankingResponse({
    required this.updatedBooks,
    required this.updatedAuthors,
    required this.timestamp,
  });

  final int? updatedBooks;
  final int? updatedAuthors;
  final DateTime? timestamp;

  factory UpdateRankingResponse.fromJson(Map<String, dynamic> json){
    return UpdateRankingResponse(
      updatedBooks: json["updated_books"],
      updatedAuthors: json["updated_authors"],
      timestamp: DateTime.tryParse(json["timestamp"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "updated_books": updatedBooks,
    "updated_authors": updatedAuthors,
    "timestamp": timestamp?.toIso8601String(),
  };

  @override
  String toString(){
    return "$updatedBooks, $updatedAuthors, $timestamp, ";
  }
}
