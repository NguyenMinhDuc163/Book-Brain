class RecommenResponse {
  RecommenResponse({
    required this.authorId,
    required this.authorName,
    required this.bookId,
    required this.categoryId,
    required this.categoryName,
    required this.excerpt,
    required this.imageUrl,
    required this.rating,
    required this.score,
    required this.status,
    required this.title,
    required this.url,
    required this.views,
  });

  final int? authorId;
  final String? authorName;
  final int? bookId;
  final int? categoryId;
  final String? categoryName;
  final String? excerpt;
  final String? imageUrl;
  final String? rating;
  final double? score;
  final String? status;
  final String? title;
  final String? url;
  final int? views;

  factory RecommenResponse.fromJson(Map<String, dynamic> json){
    return RecommenResponse(
      authorId: json["author_id"],
      authorName: json["author_name"],
      bookId: json["book_id"],
      categoryId: json["category_id"],
      categoryName: json["category_name"],
      excerpt: json["excerpt"],
      imageUrl: json["image_url"],
      rating: json["rating"],
      score: json["score"],
      status: json["status"],
      title: json["title"],
      url: json["url"],
      views: json["views"],
    );
  }

  Map<String, dynamic> toJson() => {
    "author_id": authorId,
    "author_name": authorName,
    "book_id": bookId,
    "category_id": categoryId,
    "category_name": categoryName,
    "excerpt": excerpt,
    "image_url": imageUrl,
    "rating": rating,
    "score": score,
    "status": status,
    "title": title,
    "url": url,
    "views": views,
  };

  @override
  String toString(){
    return "$authorId, $authorName, $bookId, $categoryId, $categoryName, $excerpt, $imageUrl, $rating, $score, $status, $title, $url, $views, ";
  }
}
