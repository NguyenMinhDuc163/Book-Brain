import 'package:book_brain/service/api_service/response/chapters_response.dart';
import 'package:book_brain/service/api_service/response/detail_book_response.dart';
import 'package:book_brain/service/api_service/response/favorites_response.dart';
import 'package:book_brain/service/api_service/response/subscriptions_response.dart';

abstract class ISubscriptionInterface {

  Future<List<SubscriptionsResponse>?> getListSubscription({
    required int page,
    required int limit,
    required bool activeOnly,
  });

  Future<bool?> createSubscription({
    required int bookId,
  });

  Future<bool?> deleteSubscription({
    required int bookId,
  });
}
