import 'package:book_brain/screen/home/service/home_service.dart';
import 'package:book_brain/screen/preview/service/preview_service.dart';
import 'package:book_brain/service/api_service/response/book_info_response.dart';
import 'package:book_brain/service/api_service/response/detail_book_response.dart';
import 'package:book_brain/utils/core/base/base_notifier.dart';

class PreviewNotifier extends BaseNotifier{
  PreviewService previewService = PreviewService();
   DetailBookResponse? bookDetail;

  Future<void> getData() async {
    await getBookDetail();
  }


  Future<bool> getBookDetail() async {
    return await execute(() async{
      bookDetail = await previewService.getDetailBook(bookId: 458, chapterId: 1);
      notifyListeners();
      print("bookDetail $bookDetail");
      return true;
    });
  }

}