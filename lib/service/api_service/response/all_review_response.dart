import 'base_response.dart';

class AllReviewResponse extends BaseResponse{
  AllReviewResponse({
    required this.reviewId,
    required this.bookId,
    required this.userId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
    required this.username,
    required this.avatarUrl,
    required this.helpfulCount,
  });

  final int? reviewId;
  final int? bookId;
  final int? userId;
  final int? rating;
  final String? comment;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? username;
  final String? avatarUrl;
  final String? helpfulCount;

  factory AllReviewResponse.fromJson(Map<String, dynamic> json){
    return AllReviewResponse(
      reviewId: json["review_id"],
      bookId: json["book_id"],
      userId: json["user_id"],
      rating: json["rating"],
      comment: json["comment"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      username: json["username"],
      avatarUrl: json["avatar_url"],
      helpfulCount: json["helpful_count"],
    );
  }

  Map<String, dynamic> toJson() => {
    "review_id": reviewId,
    "book_id": bookId,
    "user_id": userId,
    "rating": rating,
    "comment": comment,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "username": username,
    "avatar_url": avatarUrl,
    "helpful_count": helpfulCount,
  };

  @override
  String toString(){
    return "$reviewId, $bookId, $userId, $rating, $comment, $createdAt, $updatedAt, $username, $avatarUrl, $helpfulCount, ";
  }
}
