import 'package:book_brain/service/api_service/response/base_response.dart';

class FavoritesResponse extends BaseResponse{
  FavoritesResponse({
    required this.bookId,
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.excerpt,
    required this.views,
    required this.status,
    required this.rating,
    required this.authorId,
    required this.authorName,
    required this.categoryId,
    required this.categoryName,
    required this.addedAt,
  });

  final int? bookId;
  final String? title;
  final String? url;
  final String? imageUrl;
  final String? excerpt;
  final int? views;
  final String? status;
  final String? rating;
  final int? authorId;
  final String? authorName;
  final int? categoryId;
  final String? categoryName;
  final DateTime? addedAt;

  factory FavoritesResponse.fromJson(Map<String, dynamic> json){
    return FavoritesResponse(
      bookId: json["book_id"],
      title: json["title"],
      url: json["url"],
      imageUrl: json["image_url"],
      excerpt: json["excerpt"],
      views: json["views"],
      status: json["status"],
      rating: json["rating"],
      authorId: json["author_id"],
      authorName: json["author_name"],
      categoryId: json["category_id"],
      categoryName: json["category_name"],
      addedAt: DateTime.tryParse(json["added_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "book_id": bookId,
    "title": title,
    "url": url,
    "image_url": imageUrl,
    "excerpt": excerpt,
    "views": views,
    "status": status,
    "rating": rating,
    "author_id": authorId,
    "author_name": authorName,
    "category_id": categoryId,
    "category_name": categoryName,
    "added_at": addedAt?.toIso8601String(),
  };

  @override
  String toString(){
    return "$bookId, $title, $url, $imageUrl, $excerpt, $views, $status, $rating, $authorId, $authorName, $categoryId, $categoryName, $addedAt, ";
  }
}
