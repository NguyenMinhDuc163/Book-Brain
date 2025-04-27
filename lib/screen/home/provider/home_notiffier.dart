import 'package:book_brain/screen/home/service/home_service.dart';
import 'package:book_brain/service/api_service/response/book_info_response.dart';
import 'package:book_brain/utils/core/base/base_notifier.dart';
import 'package:book_brain/utils/core/helpers/local_storage_helper.dart';

class HomeNotiffier extends BaseNotifier{
  HomeService homeService = HomeService();
  List<BookInfoResponse> bookInfo = [];
  String userName = "";
  String email = "";
  Future<void> getData() async {
    await getInfoBook();
    userName = await LocalStorageHelper.getValue("userName");
    email = await LocalStorageHelper.getValue("email");
  }


  Future<bool> getInfoBook() async {
    return await execute(() async{
      print("====> ");
      bookInfo = await homeService.getInfoBook();
      notifyListeners();

      print("hfhsdhd $bookInfo");
      return true;
    });
  }

}