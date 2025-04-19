class CreateReviewRequest {
  CreateReviewRequest({
    required this.bookId,
    required this.rating,
    required this.comment,
  });

  final int? bookId;
  final int? rating;
  final String? comment;

  factory CreateReviewRequest.fromJson(Map<String, dynamic> json){
    return CreateReviewRequest(
      bookId: json["book_id"],
      rating: json["rating"],
      comment: json["comment"],
    );
  }

  Map<String, dynamic> toJson() => {
    "book_id": bookId,
    "rating": rating,
    "comment": comment,
  };

  @override
  String toString(){
    return "$bookId, $rating, $comment, ";
  }
}
