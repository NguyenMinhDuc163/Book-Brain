import 'package:book_brain/service/api_service/response/all_review_response.dart';
import 'package:book_brain/service/api_service/response/create_review_response.dart';
import 'package:book_brain/service/api_service/response/review_stats_response.dart';

abstract class IReviewBookInterface {
  Future<List<AllReviewResponse>?> getAllReview({
    required int bookId,
    required int page,
    required int limit,
  });

  Future<ReviewStatsResponse?> getStatsReview({
    required int bookId,
  });

  Future<bool> createReview({
    required int bookId,
    required int rating,
    required String comment,
  });

  Future<bool> deleteReview({
    required int reviewId,
  });
}
