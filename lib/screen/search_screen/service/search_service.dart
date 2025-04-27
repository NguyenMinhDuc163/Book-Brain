import 'package:book_brain/screen/preview/service/preview_interface.dart';
import 'package:book_brain/screen/search_screen/service/search_interface.dart';
import 'package:book_brain/service/api_service/api_service.dart';
import 'package:book_brain/service/api_service/response/base_response.dart';
import 'package:book_brain/service/api_service/response/detail_book_response.dart';
import 'package:book_brain/service/api_service/response/search_book_response.dart';

class SearchService implements ISearchInterface {
  final ApiServices apiServices = ApiServices();

  @override
  Future<List<SearchBookResponse>?> searchBook({
    required String keyword,
    required int limit,
  }) async {
    final BaseResponse<SearchBookResponse> response = await apiServices
        .searchBook(keyword: keyword, limit: limit);
    if (response.code != null) {
      List<SearchBookResponse> data = response.data!;
      return data;
    }
    return null;
  }
}
