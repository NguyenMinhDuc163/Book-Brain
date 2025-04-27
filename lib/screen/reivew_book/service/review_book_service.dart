import 'package:book_brain/screen/preview/service/preview_interface.dart';
import 'package:book_brain/screen/reivew_book/service/review_book_interface.dart';
import 'package:book_brain/service/api_service/api_service.dart';
import 'package:book_brain/service/api_service/request/create_reivew_request.dart';
import 'package:book_brain/service/api_service/response/all_review_response.dart';
import 'package:book_brain/service/api_service/response/base_response.dart';
import 'package:book_brain/service/api_service/response/chapters_response.dart';
import 'package:book_brain/service/api_service/response/create_review_response.dart';
import 'package:book_brain/service/api_service/response/detail_book_response.dart';
import 'package:book_brain/service/api_service/response/review_stats_response.dart';

class ReviewBookService implements IReviewBookInterface {
  final ApiServices apiServices = ApiServices();

  @override
  Future<List<ChaptersResponse>?> getChapters({required int bookId}) async {
    final BaseResponse<ChaptersResponse> response = await apiServices
        .getChapters(bookId: bookId);
    if (response.code != null) {
      List<ChaptersResponse> data = response.data!;
      return data;
    }
    return null;
  }

  @override
  Future<bool> createReview({
    required int bookId,
    required int rating,
    required String comment,
  }) async {
    final CreateReviewRequest request = CreateReviewRequest(
      bookId: bookId,
      rating: rating,
      comment: comment,
    );
    final BaseResponse<CreateReviewResponse> response = await apiServices
        .sendCreateReview(request);
    if (response.code != null) {
       return true;
    }
    return false;
  }

  @override
  Future<List<AllReviewResponse>?> getAllReview({
    required int bookId,
    required int page,
    required int limit,
  }) async {
    final BaseResponse<AllReviewResponse> response = await apiServices
        .getAllReview(bookId: bookId, page: page, limit: limit);
    if (response.code != null) {
      List<AllReviewResponse> data = response.data!;
      return data;
    }
    return null;
  }

  @override
  Future<ReviewStatsResponse?> getStatsReview({required int bookId}) async{
    final BaseResponse<ReviewStatsResponse> response = await apiServices
        .getStatsReview(bookId: bookId);
    if (response.code != null) {
      List<ReviewStatsResponse> data = response.data!;
      return data[0];
    }
    return null;
  }
}
