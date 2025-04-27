import 'package:book_brain/screen/favorites/service/favorites_interface.dart';
import 'package:book_brain/service/api_service/api_service.dart';
import 'package:book_brain/service/api_service/request/favorites_request.dart';
import 'package:book_brain/service/api_service/response/base_response.dart';
import 'package:book_brain/service/api_service/response/create_favorites_response.dart';
import 'package:book_brain/service/api_service/response/favorites_response.dart';


class FavoritesService implements IFavoritesInterface {
  final ApiServices apiServices = ApiServices();

  @override
  Future<bool?> createFavorites({required int bookId}) async{
    final FavoritesRequest request = FavoritesRequest(
      bookId: bookId,
      action: "add",
    );
    final BaseResponse<CreateFavoritesResponse> response = await apiServices.sendCreateFavorites(request);
    if (response.code != null) {
      return true;
    }
    return false;
  }

  @override
  Future<bool?> deleteFavorites({required int bookId}) async{
    final FavoritesRequest request = FavoritesRequest(
      bookId: bookId,
      action: "remove",
    );
    final BaseResponse<CreateFavoritesResponse> response = await apiServices.sendDeleteFavorites(request);
    if (response.code != null) {
      return true;
    }
    return false;
  }

  @override
  Future<List<FavoritesResponse>?> getListFavorites({required int page, required int limit}) async{
    final BaseResponse<FavoritesResponse> response = await apiServices.getFavorites(page: page,limit: limit);
    if (response.code != null) {
      List<FavoritesResponse> data = response.data!;
      return data;
    }
    return null;
  }
}
