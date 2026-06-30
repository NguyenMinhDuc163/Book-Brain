import 'package:book_brain/screen/following_book/service/subscription_service.dart';
import 'package:book_brain/service/api_service/response/subscriptions_response.dart';
import 'package:book_brain/utils/core/base/base_notifier.dart';
import 'package:book_brain/utils/core/helpers/auth_helper.dart';

class SubscriptionNotifier extends BaseNotifier {
  SubscriptionService subscriptionService = SubscriptionService();
  List<SubscriptionsResponse> subscriptions = [];

  Future<void> getData() async {
    if (!AuthHelper.isLoggedIn) return;
    await getListSubscription();
  }

  Future<bool> getListSubscription() async {
    if (!AuthHelper.isLoggedIn) return false;
    return await execute(() async {
      setLoading(true);
      subscriptions =
          (await subscriptionService.getListSubscription(
            page: 1,
            limit: 10,
            activeOnly: true,
          ))!;
      notifyListeners();
      print("subscriptions $subscriptions");
      return true;
    });
  }
}
