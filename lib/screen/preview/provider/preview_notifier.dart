import 'package:book_brain/screen/favorites/service/favorites_service.dart';
import 'package:book_brain/screen/following_book/service/subscription_service.dart';
import 'package:book_brain/screen/home/service/home_service.dart';
import 'package:book_brain/screen/preview/service/preview_service.dart';
import 'package:book_brain/service/api_service/response/book_info_response.dart';
import 'package:book_brain/service/api_service/response/chapters_response.dart';
import 'package:book_brain/service/api_service/response/detail_book_response.dart';
import 'package:book_brain/utils/core/base/base_notifier.dart';

class PreviewNotifier extends BaseNotifier{
  PreviewService previewService = PreviewService();
   DetailBookResponse? bookDetail;
   List<ChaptersResponse>? chapters;
   bool isFollowing = false;
   bool isFavorites = false;

  Future<void> getData(int bookId) async {
    await getBookDetail(bookId);
  }


  Future<bool> getBookDetail(int bookId) async {
    return await execute(() async{
      bookDetail = await previewService.getDetailBook(bookId: bookId, chapterId: 1);
      isFollowing = bookDetail?.isSubscribed ?? false;
      isFavorites = bookDetail?.isFavorited ?? false;
      notifyListeners();
      print("bookDetail $bookDetail");
      return true;
    });
  }

  void setFollowing(bool value) {
    SubscriptionService service = SubscriptionService();
    value == true ? service.createSubscription(bookId: bookDetail?.bookId ?? 1) : service.deleteSubscription(bookId: bookDetail?.bookId ?? 1);
    isFollowing = value;
    notifyListeners();
  }


  void setFavorites(bool value) {
    FavoritesService service = FavoritesService();
    value == true ? service.createFavorites(bookId: bookDetail?.bookId ?? 1) : service.deleteFavorites(bookId: bookDetail?.bookId ?? 1);
    isFavorites = value;
    notifyListeners();
  }
}