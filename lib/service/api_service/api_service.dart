import 'package:book_brain/service/api_service/BaseApiService.dart';
import 'package:book_brain/service/api_service/request/RegisterRequest.dart';
import 'package:book_brain/service/api_service/request/create_reivew_request.dart';
import 'package:book_brain/service/api_service/request/delete_all_noti_request.dart';
import 'package:book_brain/service/api_service/request/delete_notification_request.dart';
import 'package:book_brain/service/api_service/request/favorites_request.dart';
import 'package:book_brain/service/api_service/request/login_request.dart';
import 'package:book_brain/service/api_service/request/subscriptions_request.dart';
import 'package:book_brain/service/api_service/request/update_history_request.dart';
import 'package:book_brain/service/api_service/response/all_review_response.dart';
import 'package:book_brain/service/api_service/response/base_response.dart';
import 'package:book_brain/service/api_service/response/book_info_response.dart';
import 'package:book_brain/service/api_service/response/chapters_response.dart';
import 'package:book_brain/service/api_service/response/create_favorites_response.dart';
import 'package:book_brain/service/api_service/response/create_review_response.dart';
import 'package:book_brain/service/api_service/response/create_subscriptions_response.dart';
import 'package:book_brain/service/api_service/response/delete_all_notificaiton_response.dart';
import 'package:book_brain/service/api_service/response/delete_notification_response.dart';
import 'package:book_brain/service/api_service/response/delete_subscriptions_response.dart';
import 'package:book_brain/service/api_service/response/detail_book_response.dart';
import 'package:book_brain/service/api_service/response/favorites_response.dart';
import 'package:book_brain/service/api_service/response/history_response.dart';
import 'package:book_brain/service/api_service/response/login_response.dart';
import 'package:book_brain/service/api_service/response/notification_response.dart';
import 'package:book_brain/service/api_service/response/review_stats_response.dart';
import 'package:book_brain/service/api_service/response/search_book_response.dart';
import 'package:book_brain/service/api_service/response/subscriptions_response.dart';
import 'package:book_brain/service/api_service/response/update_history_response.dart';
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


  /// chuc nang yeu thich
  Future<BaseResponse<FavoritesResponse>> getFavorites({
    required int page,
    required int limit,
  }) async {
    final queryParams = <String, dynamic>{};

    queryParams["page"] = page;
    queryParams["limit"] = limit;

    return await sendRequest<FavoritesResponse>(
      UrlStatic.API_FAVORISTES,
      method: 'GET',
      data: queryParams,
      fromJson: (json) => FavoritesResponse.fromJson(json),
    );
  }

  Future<BaseResponse<CreateFavoritesResponse>> sendCreateFavorites(FavoritesRequest request) async {
    return await sendRequest<CreateFavoritesResponse>(
      UrlStatic.API_FAVORISTES,
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => CreateFavoritesResponse.fromJson(json),
    );
  }

  Future<BaseResponse<CreateFavoritesResponse>> sendDeleteFavorites(FavoritesRequest request) async {
    return await sendRequest<CreateFavoritesResponse>(
      UrlStatic.API_FAVORISTES,
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => CreateFavoritesResponse.fromJson(json),
    );
  }


  /// chuc nang dang ky theo doi sách
  Future<BaseResponse<SubscriptionsResponse>> getSubscriptions({
    required int page,
    required int limit,
    required bool activeOnly,
  }) async {
    final queryParams = <String, dynamic>{};

    queryParams["page"] = page;
    queryParams["limit"] = limit;
    queryParams["active_only"] = limit; //true tra ve các sách đã đăng ký theo dõi, false => all

    return await sendRequest<SubscriptionsResponse>(
      UrlStatic.API_SUBCRIPTIONS,
      method: 'GET',
      data: queryParams,
      fromJson: (json) => SubscriptionsResponse.fromJson(json),
    );
  }


  Future<BaseResponse<CreateSubscriptionsResponse>> sendCreateSubscription(SubscriptionsRequest request) async {
    return await sendRequest<CreateSubscriptionsResponse>(
      UrlStatic.API_SUBCRIPTIONS,
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => CreateSubscriptionsResponse.fromJson(json),
    );
  }

  Future<BaseResponse<DeleteSubscriptionsResponse>> sendDeleteSubscription(SubscriptionsRequest request) async {
    return await sendRequest<DeleteSubscriptionsResponse>(
      UrlStatic.API_SUBCRIPTIONS,
      method: 'API_SUBCRIPTIONS',
      data: request.toJson(),
      fromJson: (json) => DeleteSubscriptionsResponse.fromJson(json),
    );
  }


  /// nhan thong bao

  Future<BaseResponse<NotificationResponse>> getNotification({
    required int page,
    required int limit,
    required bool unreadOnly,
  }) async {
    final queryParams = <String, dynamic>{};

    queryParams["page"] = page;
    queryParams["limit"] = limit;
    queryParams["unread_only"] = unreadOnly;

    return await sendRequest<NotificationResponse>(
      UrlStatic.API_NOTIFICATION,
      method: 'GET',
      data: queryParams,
      fromJson: (json) => NotificationResponse.fromJson(json),
    );
  }

  Future<BaseResponse<DeleteNotificationResponse>> sendDeleteNotification(DeleteNotificationRequest request) async {
    return await sendRequest<DeleteNotificationResponse>(
      UrlStatic.API_NOTIFICATION,
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => DeleteNotificationResponse.fromJson(json),
    );
  }

  Future<BaseResponse<DeleteAllNotificaitonResponse>> sendDeleteAllNotification(DeleteAllNotiRequest request) async {
    return await sendRequest<DeleteAllNotificaitonResponse>(
      UrlStatic.API_NOTIFICATION,
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => DeleteAllNotificaitonResponse.fromJson(json),
    );
  }


  /// lay lich su doc sach
  Future<BaseResponse<UpdateHistoryResponse>> sendUpdateHistory(UpdateHistoryRequest request) async {
    return await sendRequest<UpdateHistoryResponse>(
      UrlStatic.API_HISTORY,
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => UpdateHistoryResponse.fromJson(json),
    );
  }

  Future<BaseResponse<HistoryResponse>> getHistory({
    required int page,
    required int limit,
    // co 3 kieu  status reading, completed va rong
    String? status,
  }) async {
    final queryParams = <String, dynamic>{};

    queryParams["page"] = page;
    queryParams["limit"] = limit;
    if(status != null) {
      queryParams["status"] = status;
    }

    return await sendRequest<HistoryResponse>(
      UrlStatic.API_HISTORY,
      method: 'GET',
      data: queryParams,
      fromJson: (json) => HistoryResponse.fromJson(json),
    );
  }


}
