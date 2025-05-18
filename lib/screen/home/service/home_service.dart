import 'package:book_brain/screen/home/service/home_interface.dart';
import 'package:book_brain/service/api_service/api_service.dart';
import 'package:book_brain/service/api_service/response/base_response.dart';
import 'package:book_brain/service/api_service/response/book_info_response.dart';
import 'package:book_brain/service/api_service/response/recoment_response.dart';

class HomeService implements IHomeInterface {
  final ApiServices apiServices = ApiServices();


  @override
  Future<List<BookInfoResponse>> getInfoBook() async{
    final BaseResponse<BookInfoResponse> response = await apiServices.getInfoBook(
    );
    if (response.code != null){
      List<BookInfoResponse> data = response.data!;
      return data;
    }
    return [];
  }

  @override
  Future<List<BookInfoResponse>> getBookTrending({required int limit}) async {
    final BaseResponse<BookInfoResponse> response = await apiServices.getTrending(
      limit: limit

    );
    if (response.code != null){
      List<BookInfoResponse> data = response.data!;
      return data;
    }
    return [];
  }

  @override
  Future<List<BookInfoResponse>> getRecommendation({required int userID, required int limit}) async{
    final BaseResponse<BookInfoResponse> response = await apiServices.getRecommendBook(
      userId: userID,
      limit: limit,
    );
    if (response.code != null){
      List<BookInfoResponse> data = response.data!;
      return data;
    }
    return [];
  }
}
