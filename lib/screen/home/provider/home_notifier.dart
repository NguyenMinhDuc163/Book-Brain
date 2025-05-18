import 'package:book_brain/screen/home/service/home_service.dart';
import 'package:book_brain/screen/notification/service/notification_service.dart';
import 'package:book_brain/service/api_service/response/book_info_response.dart';
import 'package:book_brain/service/api_service/response/notification_response.dart';
import 'package:book_brain/service/api_service/response/recoment_response.dart';
import 'package:book_brain/utils/core/base/base_notifier.dart';
import 'package:book_brain/utils/core/helpers/local_storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeNotifier extends BaseNotifier {
  HomeService homeService = HomeService();
  NotificationService notificationService = NotificationService();
  List<BookInfoResponse> bookInfo = [];
  List<BookInfoResponse> trendingBook = [];
  List<NotificationResponse> notifications = [];
  List<BookInfoResponse> recommenlist = [];
  int unreadNotificationCount = 0;
  String? userName;
  String? email;

  // Thêm biến để theo dõi trạng thái loadmore
  bool isLoadingMoreTrending = false;
  bool isLoadingMoreRecommend = false;
  int currentTrendingLimit = 10;
  int currentRecommendLimit = 10;
  bool hasMoreTrending = true;
  bool hasMoreRecommend = true;

  Future<void> getData() async {
    await execute(() async {
      await Future.wait([
        getInfoBook(),
        getTrendingBook(limit: 10),
        getUnreadNotificationCount(),
        getRecommentBook(),
        loadUserInfo(),
      ]);
    });
  }

  Future<void> loadUserInfo() async {
    userName = LocalStorageHelper.getValue("userName");
    email = LocalStorageHelper.getValue("email");
    notifyListeners();
  }

  void updateUserInfo({String? userName, String? email}) {
    if (userName != null) {
      this.userName = userName;
      LocalStorageHelper.setValue("userName", userName);
    }
    if (email != null && email.isNotEmpty) {
      this.email = email;
      LocalStorageHelper.setValue("email", email);
    }
    notifyListeners();
  }

  Future<void> getUnreadNotificationCount() async {
    try {
      final notifications = await notificationService.getListNotification(
        page: 1,
        limit: 100,
        unreadOnly: true,
      );
      unreadNotificationCount = notifications?.length ?? 0;
      notifyListeners();
    } catch (e) {
      print("Error getting unread notifications: $e");
    }
  }

  Future<bool> getInfoBook() async {
    return await execute(() async {
      bookInfo = await homeService.getInfoBook();
      notifyListeners();

      return true;
    });
  }

  Future<bool> getTrendingBook({required int limit}) async {
    return await execute(() async {
      trendingBook = await homeService.getBookTrending(limit: limit);
      currentTrendingLimit = limit;
      hasMoreTrending = trendingBook.length >= limit;
      notifyListeners();
      return true;
    });
  }

  Future<bool> getRecommentBook() async {
    return await execute(() async {
      int userID = LocalStorageHelper.getValue("userId");
      recommenlist = await homeService.getRecommendation(
        userID: userID,
        limit: currentRecommendLimit,
      );
      hasMoreRecommend = recommenlist.length >= currentRecommendLimit;
      notifyListeners();
      return true;
    });
  }

  // Sửa lại hàm loadmore cho trending books
  Future<void> loadMoreTrendingBooks() async {
    if (isLoadingMoreTrending || !hasMoreTrending) return;

    isLoadingMoreTrending = true;
    notifyListeners();

    try {
      final newBooks = await homeService.getBookTrending(
        limit: currentTrendingLimit + 10,
      );

      // Lọc ra những cuốn sách mới chưa có trong danh sách hiện tại
      final existingIds = trendingBook.map((book) => book.bookId).toSet();
      final uniqueNewBooks =
          newBooks.where((book) => !existingIds.contains(book.bookId)).toList();

      if (uniqueNewBooks.isNotEmpty) {
        trendingBook.addAll(uniqueNewBooks);
        currentTrendingLimit += 10;
        hasMoreTrending = uniqueNewBooks.length >= 10;
      } else {
        hasMoreTrending = false;
      }
    } catch (e) {
      print("Error loading more trending books: $e");
    } finally {
      isLoadingMoreTrending = false;
      notifyListeners();
    }
  }

  // Sửa lại hàm loadmore cho recommend books
  Future<void> loadMoreRecommendBooks() async {
    if (isLoadingMoreRecommend || !hasMoreRecommend) return;

    isLoadingMoreRecommend = true;
    notifyListeners();

    try {
      int userID = LocalStorageHelper.getValue("userId");
      final newBooks = await homeService.getRecommendation(
        userID: userID,
        limit: currentRecommendLimit + 10,
      );

      // Lọc ra những cuốn sách mới chưa có trong danh sách hiện tại
      final existingIds = recommenlist.map((book) => book.bookId).toSet();
      final uniqueNewBooks =
          newBooks.where((book) => !existingIds.contains(book.bookId)).toList();

      if (uniqueNewBooks.isNotEmpty) {
        recommenlist.addAll(uniqueNewBooks);
        currentRecommendLimit += 10;
        hasMoreRecommend = uniqueNewBooks.length >= 10;
      } else {
        hasMoreRecommend = false;
      }
    } catch (e) {
      print("Error loading more recommend books: $e");
    } finally {
      isLoadingMoreRecommend = false;
      notifyListeners();
    }
  }
}
