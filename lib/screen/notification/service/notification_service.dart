import 'package:book_brain/screen/notification/service/notification_interface.dart';
import 'package:book_brain/screen/preview/service/preview_interface.dart';
import 'package:book_brain/service/api_service/api_service.dart';
import 'package:book_brain/service/api_service/request/delete_all_noti_request.dart';
import 'package:book_brain/service/api_service/request/delete_notification_request.dart';
import 'package:book_brain/service/api_service/response/base_response.dart';
import 'package:book_brain/service/api_service/response/chapters_response.dart';
import 'package:book_brain/service/api_service/response/delete_all_notificaiton_response.dart';
import 'package:book_brain/service/api_service/response/delete_notification_response.dart';
import 'package:book_brain/service/api_service/response/detail_book_response.dart';
import 'package:book_brain/service/api_service/response/notification_response.dart';

class NotificationService implements INotificationInterface {
  final ApiServices apiServices = ApiServices();


  @override
  Future<bool?> deleteAllNotification() async{
    final DeleteAllNotiRequest request = DeleteAllNotiRequest(
      action: "delete_all",
    );
    final BaseResponse<DeleteAllNotificaitonResponse> response = await apiServices.sendDeleteAllNotification(request);
    if (response.code != null) {
      return true;
    }
    return false;
  }

  @override
  Future<bool?> deleteNotification({ required int notificationId})async {
    final DeleteNotificationRequest request = DeleteNotificationRequest(
      action: "delete",
      notificationId: notificationId,
    );
    final BaseResponse<DeleteNotificationResponse> response = await apiServices.sendDeleteNotification(request);
    if (response.code != null) {
      return true;
    }
    return false;
  }

  @override
  Future<List<NotificationResponse>?> getListNotification({required int page, required int limit, required bool unreadOnly}) async{
    final BaseResponse<NotificationResponse> response = await apiServices
        .getNotification(page: page, limit: limit, unreadOnly: unreadOnly);
    if (response.code != null) {
      List<NotificationResponse> data = response.data!;
      return data;
    }
    return null;
  }
}
