import 'package:book_brain/service/api_service/response/base_response.dart';

class ReviewStatsResponse extends BaseResponse{
  ReviewStatsResponse({
    required this.totalReviews,
    required this.averageRating,
    required this.fiveStar,
    required this.fourStar,
    required this.threeStar,
    required this.twoStar,
    required this.oneStar,
  });

  final String? totalReviews;
  final String? averageRating;
  final String? fiveStar;
  final String? fourStar;
  final String? threeStar;
  final String? twoStar;
  final String? oneStar;

  factory ReviewStatsResponse.fromJson(Map<String, dynamic> json){
    return ReviewStatsResponse(
      totalReviews: json["total_reviews"],
      averageRating: json["average_rating"],
      fiveStar: json["five_star"],
      fourStar: json["four_star"],
      threeStar: json["three_star"],
      twoStar: json["two_star"],
      oneStar: json["one_star"],
    );
  }

  Map<String, dynamic> toJson() => {
    "total_reviews": totalReviews,
    "average_rating": averageRating,
    "five_star": fiveStar,
    "four_star": fourStar,
    "three_star": threeStar,
    "two_star": twoStar,
    "one_star": oneStar,
  };

  @override
  String toString(){
    return "$totalReviews, $averageRating, $fiveStar, $fourStar, $threeStar, $twoStar, $oneStar, ";
  }
}
