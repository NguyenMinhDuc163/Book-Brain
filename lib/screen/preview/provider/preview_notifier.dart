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

  Future<void> getData(int bookId) async {
    await getBookDetail(bookId);
  }


  Future<bool> getBookDetail(int bookId) async {
    return await execute(() async{
      bookDetail = await previewService.getDetailBook(bookId: bookId, chapterId: 1);
      // chapters = await previewService.getChapters(bookId: bookId);
      notifyListeners();
      print("bookDetail $bookDetail");
      return true;
    });
  }

}