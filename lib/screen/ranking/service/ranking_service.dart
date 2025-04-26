import 'package:book_brain/screen/preview/service/preview_interface.dart';
import 'package:book_brain/screen/ranking/service/ranking_interface.dart';
import 'package:book_brain/service/api_service/api_service.dart';
import 'package:book_brain/service/api_service/request/basse_request.dart';
import 'package:book_brain/service/api_service/response/author_ranking_response.dart';
import 'package:book_brain/service/api_service/response/base_response.dart';
import 'package:book_brain/service/api_service/response/book_ranking_response.dart';
import 'package:book_brain/service/api_service/response/chapters_response.dart';
import 'package:book_brain/service/api_service/response/detail_book_response.dart';
import 'package:book_brain/service/api_service/response/update_ranking_response.dart';

class RankingService implements IRankingInterface {
  final ApiServices apiServices = ApiServices();

  @override
  Future<List<AuthorRankingResponse>?> getAuthRanking({
    required int limit,
  }) async {
    final BaseResponse<AuthorRankingResponse> response = await apiServices
        .getAuthRanking(limit: limit);
    if (response.code != null) {
      List<AuthorRankingResponse> data = response.data!;
      return data;
    }
    return null;
  }

  @override
  Future<List<BookRankingResponse>?> getBookRanking({
    required int limit,
  }) async {
    final BaseResponse<BookRankingResponse> response = await apiServices
        .getBookRanking(limit: limit);
    print("======> 1");
    if (response.code != null) {
      List<BookRankingResponse> data = response.data!;
      print("======> 2");
      return data;
    }
    print("======> 3 ${response.data.toString()}" );

    return null;
  }

  @override
  Future<bool?> updateRanking() async {
    BaseRequest request = BaseRequest();
    final BaseResponse<UpdateRankingResponse> response = await apiServices
        .sendUpdateRanking(request);

    return response.code == 200 || response.code == 201;
  }
}
