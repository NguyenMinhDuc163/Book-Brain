import 'package:book_brain/service/api_service/response/chapters_response.dart';
import 'package:book_brain/service/api_service/response/detail_book_response.dart';

abstract class IPreviewInterface {
  Future<DetailBookResponse?> getDetailBook({
    required int bookId,
    required int chapterId,
  });

  Future<List<ChaptersResponse>?> getChapters({
    required int bookId,
  });
}
