// ignore: prefer_mixin, one_member_abstracts
import 'package:book_brain/service/api_service/response/search_book_response.dart';

abstract class ISearchInterface {
    Future<List<SearchBookResponse>?> searchBook({required String keyword, required int limit});
}
