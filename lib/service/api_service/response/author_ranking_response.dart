class AuthorRankingResponse {
  AuthorRankingResponse({
    required this.authorId,
    required this.name,
    required this.totalBooks,
    required this.totalViews,
    required this.avgRating,
    required this.totalFavorites,
    required this.authorScore,
    required this.overallRank,
  });

  final int? authorId;
  final String? name;
  final String? totalBooks;
  final String? totalViews;
  final String? avgRating;
  final String? totalFavorites;
  final String? authorScore;
  final String? overallRank;

  factory AuthorRankingResponse.fromJson(Map<String, dynamic> json){
    return AuthorRankingResponse(
      authorId: json["author_id"],
      name: json["name"],
      totalBooks: json["total_books"],
      totalViews: json["total_views"],
      avgRating: json["avg_rating"],
      totalFavorites: json["total_favorites"],
      authorScore: json["author_score"],
      overallRank: json["overall_rank"],
    );
  }

  Map<String, dynamic> toJson() => {
    "author_id": authorId,
    "name": name,
    "total_books": totalBooks,
    "total_views": totalViews,
    "avg_rating": avgRating,
    "total_favorites": totalFavorites,
    "author_score": authorScore,
    "overall_rank": overallRank,
  };

  @override
  String toString(){
    return "$authorId, $name, $totalBooks, $totalViews, $avgRating, $totalFavorites, $authorScore, $overallRank, ";
  }
}
