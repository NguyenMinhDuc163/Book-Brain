import 'package:book_brain/screen/ranking/service/ranking_service.dart';
import 'package:book_brain/service/api_service/response/author_ranking_response.dart';
import 'package:book_brain/service/api_service/response/book_ranking_response.dart';
import 'package:book_brain/utils/core/base/base_notifier.dart';

class RankingNotifier extends BaseNotifier{
  RankingService rankingService = RankingService();
   List<BookRankingResponse>? bookRanking ;
   List<AuthorRankingResponse>?  authRanking ;

  Future<void> getData() async {
    await getBookRanking();
    await getAuthorRanking();
  }


  Future<bool> getBookRanking() async {
    return await execute(() async{
      bookRanking = await rankingService.getBookRanking(limit: 5);
      notifyListeners();
      return true;
    });
  }
  Future<bool> getAuthorRanking() async {
    return await execute(() async{
      authRanking = await rankingService.getAuthRanking(limit: 5);
      notifyListeners();
      return true;
    });
  }

}