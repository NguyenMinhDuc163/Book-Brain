class BookRankingResponse {
  BookRankingResponse({
    required this.bookId,
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.views,
    required this.rating,
    required this.authorId,
    required this.authorName,
    required this.categoryId,
    required this.categoryName,
    required this.rankingScore,
    required this.overallRank,
    required this.favoriteCount,
    required this.avgRating,
    required this.reviewCount,
  });

  final int? bookId;
  final String? title;
  final String? url;
  final String? imageUrl;
  final int? views;
  final String? rating;
  final int? authorId;
  final String? authorName;
  final int? categoryId;
  final String? categoryName;
  final int? rankingScore;
  final int? overallRank;
  final String? favoriteCount;
  final String? avgRating;
  final String? reviewCount;

  factory BookRankingResponse.fromJson(Map<String, dynamic> json){
    return BookRankingResponse(
      bookId: json["book_id"],
      title: json["title"],
      url: json["url"],
      imageUrl: json["image_url"],
      views: json["views"],
      rating: json["rating"],
      authorId: json["author_id"],
      authorName: json["author_name"],
      categoryId: json["category_id"],
      categoryName: json["category_name"],
      rankingScore: json["ranking_score"],
      overallRank: json["overall_rank"],
      favoriteCount: json["favorite_count"],
      avgRating: json["avg_rating"],
      reviewCount: json["review_count"],
    );
  }

  Map<String, dynamic> toJson() => {
    "book_id": bookId,
    "title": title,
    "url": url,
    "image_url": imageUrl,
    "views": views,
    "rating": rating,
    "author_id": authorId,
    "author_name": authorName,
    "category_id": categoryId,
    "category_name": categoryName,
    "ranking_score": rankingScore,
    "overall_rank": overallRank,
    "favorite_count": favoriteCount,
    "avg_rating": avgRating,
    "review_count": reviewCount,
  };

  @override
  String toString(){
    return "$bookId, $title, $url, $imageUrl, $views, $rating, $authorId, $authorName, $categoryId, $categoryName, $rankingScore, $overallRank, $favoriteCount, $avgRating, $reviewCount, ";
  }
}
