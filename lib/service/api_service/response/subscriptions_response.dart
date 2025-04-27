import 'package:book_brain/service/api_service/response/base_response.dart';

class SubscriptionsResponse extends BaseResponse{
  SubscriptionsResponse({
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
    required this.subscriptionId,
    required this.isActive,
    required this.subscribedAt,
    required this.lastNotifiedAt,
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
  final int? subscriptionId;
  final bool? isActive;
  final DateTime? subscribedAt;
  final dynamic lastNotifiedAt;

  factory SubscriptionsResponse.fromJson(Map<String, dynamic> json){
    return SubscriptionsResponse(
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
      subscriptionId: json["subscription_id"],
      isActive: json["is_active"],
      subscribedAt: DateTime.tryParse(json["subscribed_at"] ?? ""),
      lastNotifiedAt: json["last_notified_at"],
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
    "subscription_id": subscriptionId,
    "is_active": isActive,
    "subscribed_at": subscribedAt?.toIso8601String(),
    "last_notified_at": lastNotifiedAt,
  };

  @override
  String toString(){
    return "$bookId, $title, $url, $imageUrl, $excerpt, $views, $status, $rating, $authorId, $authorName, $categoryId, $categoryName, $subscriptionId, $isActive, $subscribedAt, $lastNotifiedAt, ";
  }
}
