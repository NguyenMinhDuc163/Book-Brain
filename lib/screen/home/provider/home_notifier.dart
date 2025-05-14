import 'package:book_brain/screen/home/service/home_service.dart';
import 'package:book_brain/screen/notification/service/notification_service.dart';
import 'package:book_brain/service/api_service/response/book_info_response.dart';
import 'package:book_brain/service/api_service/response/notification_response.dart';
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
  int unreadNotificationCount = 0;
  String? userName;
  String? email;

  Future<void> getData() async {
    await execute(() async {
      await Future.wait([
        getInfoBook(),
        getTrendingBook(),
        getUnreadNotificationCount(),
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

  Future<bool> getTrendingBook() async {
    return await execute(() async {
      trendingBook = await homeService.getBookTrending();
      notifyListeners();

      return true;
    });
  }
}
