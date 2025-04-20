import 'package:book_brain/screen/following_book/service/subscription_interface.dart';
import 'package:book_brain/service/api_service/api_service.dart';
import 'package:book_brain/service/api_service/request/subscriptions_request.dart';
import 'package:book_brain/service/api_service/response/base_response.dart';
import 'package:book_brain/service/api_service/response/create_subscriptions_response.dart';
import 'package:book_brain/service/api_service/response/delete_subscriptions_response.dart';
import 'package:book_brain/service/api_service/response/subscriptions_response.dart';


class SubscriptionService implements ISubscriptionInterface {
  final ApiServices apiServices = ApiServices();



  @override
  Future<bool?> createSubscription({required int bookId}) async{
    final SubscriptionsRequest request = SubscriptionsRequest(
      bookId: bookId,
      action: "subscribe",
    );
    final BaseResponse<CreateSubscriptionsResponse> response = await apiServices.sendCreateSubscription(request);
    if (response.code != null) {
      return true;
    }
    return false;
  }

  @override
  Future<bool?> deleteSubscription({required int bookId}) async{
    final SubscriptionsRequest request = SubscriptionsRequest(
      bookId: bookId,
      action: "unsubscribe",
    );
    final BaseResponse<DeleteSubscriptionsResponse> response = await apiServices.sendDeleteSubscription(request);
    if (response.code != null) {
      return true;
    }
    return false;
  }

  @override
  Future<List<SubscriptionsResponse>?> getListSubscription({required int page, required int limit, required bool activeOnly}) async{
    final BaseResponse<SubscriptionsResponse> response = await apiServices.getSubscriptions(page: page,limit: limit, activeOnly: activeOnly);
    if (response.code != null) {
      List<SubscriptionsResponse> data = response.data!;
      return data;
    }
    return null;
  }
}
