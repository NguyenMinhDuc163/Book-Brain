import 'package:book_brain/service/api_service/response/chapters_response.dart';
import 'package:book_brain/service/api_service/response/detail_book_response.dart';
import 'package:book_brain/service/api_service/response/favorites_response.dart';

abstract class IFavoritesInterface {

  Future<List<FavoritesResponse>?> getListFavorites({
    required int page,
    required int limit,
  });

  Future<bool?> createFavorites({
    required int bookId,
  });

  Future<bool?> deleteFavorites({
    required int bookId,
  });
}
