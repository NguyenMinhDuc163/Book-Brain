import 'package:book_brain/screen/favorites/service/favorites_service.dart';
import 'package:book_brain/service/api_service/response/favorites_response.dart';
import 'package:book_brain/utils/core/base/base_notifier.dart';

class FavoritesNotifier extends BaseNotifier{
  FavoritesService favoritesService = FavoritesService();
  List<FavoritesResponse> favorites = [];
  Future<void> getData() async {
    await getFavorites();
  }


  Future<bool> getFavorites() async {
    return await execute(() async{
      favorites = (await favoritesService.getListFavorites(page: 1,limit: 10))!;
      notifyListeners();
      print("favorites $favorites");
      return true;
    });
  }

  Future<bool> createFavorites({required bookId}) async {
    return await execute(() async{
     bool? isCheck = await favoritesService.createFavorites(bookId: bookId);
      notifyListeners();
      return isCheck == true;
    });
  }

  Future<bool> deleteFavorites({required bookId}) async {
    return await execute(() async{
      bool? isCheck = await favoritesService.deleteFavorites(bookId: bookId);
      notifyListeners();
      return isCheck == true;
    });
  }
}