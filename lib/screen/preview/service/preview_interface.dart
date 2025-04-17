import 'package:book_brain/service/api_service/response/detail_book_response.dart';

abstract class IPreviewInterface {
  Future<DetailBookResponse?> getDetailBook({
    required int bookId,
    required int chapterId,
  });
}
