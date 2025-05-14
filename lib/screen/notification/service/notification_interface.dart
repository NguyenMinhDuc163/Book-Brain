import 'package:book_brain/service/api_service/response/chapters_response.dart';
import 'package:book_brain/service/api_service/response/delete_all_notificaiton_response.dart';
import 'package:book_brain/service/api_service/response/delete_notification_response.dart';
import 'package:book_brain/service/api_service/response/detail_book_response.dart';
import 'package:book_brain/service/api_service/response/notification_response.dart';

abstract class INotificationInterface {
  Future<List<NotificationResponse>?> getListNotification({
    required int page,
    required int limit,
    required bool unreadOnly,
  });

  Future<bool?> deleteNotification({required int notificationId});

  Future<bool?> deleteAllNotification();

  Future<bool?> markReadNotification({required int notificationId});

  Future<bool?> markReaAllNotification();
}
