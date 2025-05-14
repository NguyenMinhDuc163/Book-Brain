import 'package:book_brain/screen/reivew_book/service/review_book_service.dart';
import 'package:book_brain/service/api_service/request/create_reivew_request.dart';
import 'package:book_brain/service/api_service/response/all_review_response.dart';
import 'package:book_brain/utils/core/base/base_notifier.dart';

import '../../../service/api_service/response/review_stats_response.dart';

class ReviewBookNotifier extends BaseNotifier {
  ReviewBookService reviewBookService = ReviewBookService();
  late List<AllReviewResponse> reviews = [];
  ReviewStatsResponse? statsReview;
  Future<void> getData(int bookId) async {
    await getAllReview(bookId);
    await getStatsReview(bookId);
  }

  Future<bool> getAllReview(int bookId) async {
    return await execute(() async {
      reviews =
          (await reviewBookService.getAllReview(
            bookId: bookId,
            page: 1,
            limit: 10,
          ))!;

      notifyListeners();
      print("reviews $reviews");
      return true;
    });
  }

  Future<bool> getStatsReview(int bookId) async {
    return await execute(() async {
      statsReview = (await reviewBookService.getStatsReview(bookId: bookId))!;

      notifyListeners();
      print("statsReview $statsReview");
      return true;
    });
  }

  Future<bool> createReview({required int bookId, required  int rating, required String comment}) async {
    return await execute(() async {
      bool isSubmit = await reviewBookService.createReview(
        bookId: bookId,
        rating: rating,
        comment: comment,
      );

      notifyListeners();
      return isSubmit;
    });
  }

  Future<bool> deleteReview({required int reviewId}) async {
    return await execute(() async {
      bool isSubmit = await reviewBookService.deleteReview(
        reviewId: reviewId,
      );

      notifyListeners();
      return isSubmit;
    });
  }
}
