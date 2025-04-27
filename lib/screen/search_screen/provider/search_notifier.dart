import 'package:book_brain/screen/home/service/home_service.dart';
import 'package:book_brain/screen/preview/service/preview_service.dart';
import 'package:book_brain/screen/search_screen/service/search_service.dart';
import 'package:book_brain/service/api_service/response/book_info_response.dart';
import 'package:book_brain/service/api_service/response/detail_book_response.dart';
import 'package:book_brain/service/api_service/response/search_book_response.dart';
import 'package:book_brain/utils/core/base/base_notifier.dart';

class SearchNotifier extends BaseNotifier{
  SearchService searchService = SearchService();
  late List<SearchBookResponse> searchBookResponse = [];
  Future<void> getData(String keyWord) async {
    await getSearchData(keyWord);
  }


  Future<bool> getSearchData(String keyWord) async {
    return await execute(() async{
      searchBookResponse = (await searchService.searchBook(keyword: keyWord, limit: 10))!;
      notifyListeners();
      return true;
    });
  }

}