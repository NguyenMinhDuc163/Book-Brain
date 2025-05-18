
import 'package:book_brain/service/api_service/response/book_info_response.dart';
import 'package:book_brain/service/api_service/response/recoment_response.dart';

abstract class IHomeInterface {
  Future<List<BookInfoResponse>> getInfoBook();
  Future<List<BookInfoResponse>> getBookTrending({required int limit});
  Future<List<BookInfoResponse>> getRecommendation({required int userID, required int limit});
}
