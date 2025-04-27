import 'package:book_brain/screen/preview/service/preview_interface.dart';
import 'package:book_brain/service/api_service/api_service.dart';
import 'package:book_brain/service/api_service/response/base_response.dart';
import 'package:book_brain/service/api_service/response/chapters_response.dart';
import 'package:book_brain/service/api_service/response/detail_book_response.dart';

class PreviewService implements IPreviewInterface {
  final ApiServices apiServices = ApiServices();

  @override
  Future<DetailBookResponse?> getDetailBook({
    required int bookId,
    required int chapterId,
  }) async {
    final BaseResponse<DetailBookResponse> response = await apiServices
        .getDetailBook(bookId: bookId, chapterId: chapterId);
    if (response.code != null) {
      DetailBookResponse data = response.data![0];
      return data;
    }
    return null;
  }

  @override
  Future<List<ChaptersResponse>?> getChapters({required int bookId}) async{
    final BaseResponse<ChaptersResponse> response = await apiServices
        .getChapters(bookId: bookId);
    if (response.code != null) {
      List<ChaptersResponse> data = response.data!;
      return data;
    }
    return null;
  }
}
