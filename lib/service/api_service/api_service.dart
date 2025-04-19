import 'package:book_brain/service/api_service/BaseApiService.dart';
import 'package:book_brain/service/api_service/request/RegisterRequest.dart';
import 'package:book_brain/service/api_service/request/create_reivew_request.dart';
import 'package:book_brain/service/api_service/request/login_request.dart';
import 'package:book_brain/service/api_service/response/all_review_response.dart';
import 'package:book_brain/service/api_service/response/base_response.dart';
import 'package:book_brain/service/api_service/response/book_info_response.dart';
import 'package:book_brain/service/api_service/response/chapters_response.dart';
import 'package:book_brain/service/api_service/response/create_review_response.dart';
import 'package:book_brain/service/api_service/response/detail_book_response.dart';
import 'package:book_brain/service/api_service/response/login_response.dart';
import 'package:book_brain/service/api_service/response/review_stats_response.dart';
import 'package:book_brain/service/api_service/response/search_book_response.dart';
import 'package:book_brain/service/common/url_static.dart';

import 'response/RegisterResponse.dart';

class ApiServices extends BaseApiService {
  // api login
  Future<BaseResponse<LoginResponse>> sendLogin(LoginRequest request) async {
    return await sendRequest<LoginResponse>(
      UrlStatic.API_LOGIN,
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => LoginResponse.fromJson(json),
    );
  }

  Future<BaseResponse<RegisterResponse>> sendRegister(
    RegisterRequest request,
  ) async {
    return await sendRequest<RegisterResponse>(
      UrlStatic.API_REGISTER,
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => RegisterResponse.fromJson(json),
    );
  }

  // GET
  Future<BaseResponse<BookInfoResponse>> getInfoBook() async {
    return await sendRequest<BookInfoResponse>(
      UrlStatic.API_INFO_BOOK,
      method: 'GET',
      // data: {}, // Truyền queryParams vào đây
      fromJson: (json) => BookInfoResponse.fromJson(json),
    );
  }

  // GET
  Future<BaseResponse<DetailBookResponse>> getDetailBook({
    required int bookId,
    required int chapterId,
  }) async {
    final queryParams = <String, int>{};

    queryParams["id"] = bookId;
    queryParams["chapter"] = chapterId;

    return await sendRequest<DetailBookResponse>(
      UrlStatic.API_DETAIL_BOOK,
      method: 'GET',
      data: queryParams, // Truyền queryParams vào đây
      fromJson: (json) => DetailBookResponse.fromJson(json),
    );
  }


  // GET
  Future<BaseResponse<SearchBookResponse>> searchBook({
    required String keyword,
    required int limit,
  }) async {
    final queryParams = <String, dynamic>{};

    queryParams["keyword"] = keyword;
    queryParams["limit"] = limit;

    return await sendRequest<SearchBookResponse>(
      UrlStatic.API_SEARCH_BOOK,
      method: 'GET',
      data: queryParams,
      fromJson: (json) => SearchBookResponse.fromJson(json),
    );
  }

  // lay chapter
  Future<BaseResponse<ChaptersResponse>> getChapters({
    required int bookId,
  }) async {
    final queryParams = <String, dynamic>{};

    queryParams["bookId"] = bookId;

    return await sendRequest<ChaptersResponse>(
      UrlStatic.API_CHAPTERS_BOOK,
      method: 'GET',
      data: queryParams,
      fromJson: (json) => ChaptersResponse.fromJson(json),
    );
  }

  // lay all review
  Future<BaseResponse<AllReviewResponse>> getAllReview({
    required int bookId,
    required int page,
    required int limit,
  }) async {
    final queryParams = <String, dynamic>{};

    queryParams["book_id"] = bookId;
    queryParams["page"] = page;
    queryParams["limit"] = limit;

    return await sendRequest<AllReviewResponse>(
      UrlStatic.API_ALL_REVIEW,
      method: 'GET',
      data: queryParams,
      fromJson: (json) => AllReviewResponse.fromJson(json),
    );
  }

  Future<BaseResponse<ReviewStatsResponse>> getStatsReview({
    required int bookId,
  }) async {
    final queryParams = <String, dynamic>{};

    queryParams["bookId"] = bookId;

    return await sendRequest<ReviewStatsResponse>(
      UrlStatic.API_STATS_REVIEW,
      method: 'GET',
      data: queryParams,
      fromJson: (json) => ReviewStatsResponse.fromJson(json),
    );
  }

  Future<BaseResponse<CreateReviewResponse>> sendCreateReview(CreateReviewRequest request) async {
    return await sendRequest<CreateReviewResponse>(
      UrlStatic.API_CREATE_REVIEW,
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => CreateReviewResponse.fromJson(json),
    );
  }
}
