import 'package:book_brain/screen/home/service/home_service.dart';
import 'package:book_brain/service/api_service/response/book_info_response.dart';
import 'package:book_brain/utils/core/base/base_notifier.dart';
import 'package:book_brain/utils/core/helpers/local_storage_helper.dart';

class HomeNotifier extends BaseNotifier{
  HomeService homeService = HomeService();
  List<BookInfoResponse> bookInfo = [];
  List<BookInfoResponse> trendingBook = [];
  String userName = "";
  String email = "";
  Future<void> getData() async {
    await getInfoBook();
    await getTrendingBook();
    userName = await LocalStorageHelper.getValue("userName");
    email = await LocalStorageHelper.getValue("email");
  }


  Future<bool> getInfoBook() async {
    return await execute(() async{
      bookInfo = await homeService.getInfoBook();
      notifyListeners();

      return true;
    });
  }


  Future<bool> getTrendingBook() async {
    return await execute(() async{
      trendingBook = await homeService.getBookTrending();
      notifyListeners();

      return true;
    });
  }
}