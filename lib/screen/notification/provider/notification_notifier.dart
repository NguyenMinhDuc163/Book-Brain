import 'package:book_brain/screen/notification/service/notification_service.dart';
import 'package:book_brain/service/api_service/response/notification_response.dart';
import 'package:book_brain/utils/core/base/base_notifier.dart';
import 'package:book_brain/utils/core/helpers/auth_helper.dart';

class NotificationNotifier extends BaseNotifier {
  NotificationService notifications = NotificationService();
  List<NotificationResponse>? listNotifications = [];

  Future<void> getData() async {
    if (!AuthHelper.isLoggedIn) return;
    await getNotification();
  }

  Future<bool> getNotification() async {
    if (!AuthHelper.isLoggedIn) return false;
    return await execute(() async {
      listNotifications = await notifications.getListNotification(
        page: 1,
        limit: 10,
        unreadOnly: false,
      );
      notifyListeners();
      print("listNotifications $listNotifications");
      return true;
    });
  }

  Future<bool> deleteNotification(int notificationId) async {
    if (!AuthHelper.isLoggedIn) return false;
    return await execute(() async {
      await notifications.deleteNotification(notificationId: notificationId);
      notifyListeners();
      print("listNotifications $listNotifications");
      return true;
    });
  }

  Future<bool> deleteAllNotification() async {
    if (!AuthHelper.isLoggedIn) return false;
    return await execute(() async {
      await notifications.deleteAllNotification();
      notifyListeners();
      print("listNotifications $listNotifications");
      return true;
    });
  }

  Future<bool> markNotification(int notificationId) async {
    if (!AuthHelper.isLoggedIn) return false;
    return await execute(() async {
      await notifications.markReadNotification(notificationId: notificationId);
      notifyListeners();
      print("listNotifications $listNotifications");
      return true;
    });
  }

  Future<bool> markAllNotification() async {
    if (!AuthHelper.isLoggedIn) return false;
    return await execute(() async {
      await notifications.markReaAllNotification();
      notifyListeners();
      print("listNotifications $listNotifications");
      return true;
    });
  }
}
