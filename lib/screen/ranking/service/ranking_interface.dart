import 'package:book_brain/service/api_service/response/author_ranking_response.dart';
import 'package:book_brain/service/api_service/response/book_ranking_response.dart';

abstract class IRankingInterface {
  Future<List<BookRankingResponse>?> getBookRanking({required int limit});

  Future<List<AuthorRankingResponse>?> getAuthRanking({required int limit});

  Future<bool?> updateRanking();
}
