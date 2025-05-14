class DeleteReview {
  DeleteReview({
    required this.reviewId,
  });

  final int? reviewId;

  factory DeleteReview.fromJson(Map<String, dynamic> json){
    return DeleteReview(
      reviewId: json["review_id"],
    );
  }

  Map<String, dynamic> toJson() => {
    "review_id": reviewId,
  };

  @override
  String toString(){
    return "$reviewId, ";
  }
}
