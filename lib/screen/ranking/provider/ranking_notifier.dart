import 'package:book_brain/screen/favorites/service/favorites_service.dart';
import 'package:book_brain/screen/following_book/service/subscription_service.dart';
import 'package:book_brain/screen/home/service/home_service.dart';
import 'package:book_brain/screen/preview/service/preview_service.dart';
import 'package:book_brain/screen/ranking/service/ranking_service.dart';
import 'package:book_brain/service/api_service/response/author_ranking_response.dart';
import 'package:book_brain/service/api_service/response/book_info_response.dart';
import 'package:book_brain/service/api_service/response/book_ranking_response.dart';
import 'package:book_brain/service/api_service/response/chapters_response.dart';
import 'package:book_brain/service/api_service/response/detail_book_response.dart';
import 'package:book_brain/utils/core/base/base_notifier.dart';

class RankingNotifier extends BaseNotifier{
  RankingService rankingService = RankingService();
  List<BookRankingResponse> bookRanking = [];
  List<AuthorRankingResponse>  authRanking = [];

  Future<void> getData() async {
    await getRanking();
  }


  Future<bool> getRanking() async {
    return await execute(() async{
      bookRanking = (await rankingService.getBookRanking(limit: 5))!;
      authRanking = (await rankingService.getAuthRanking(limit: 5))!;
      notifyListeners();
      return true;
    });
  }

  Future<bool> updateRanking() async {
    return await execute(() async{
      setLoading(true);
      bool result = await rankingService.updateRanking() ?? false;
      if (result) {
        bookRanking = (await rankingService.getBookRanking(limit: 5))!;
        authRanking = (await rankingService.getAuthRanking(limit: 5))!;
      }
      setLoading(false);
      notifyListeners();
      return result;
    });
  }

}