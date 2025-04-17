
import 'package:book_brain/service/api_service/response/book_info_response.dart';

abstract class IHomeInterface {
  Future<List<BookInfoResponse>> getInfoBook();
}
