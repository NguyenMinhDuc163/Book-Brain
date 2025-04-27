import 'package:book_brain/screen/home/service/home_interface.dart';
import 'package:book_brain/service/api_service/api_service.dart';
import 'package:book_brain/service/api_service/response/base_response.dart';
import 'package:book_brain/service/api_service/response/book_info_response.dart';

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
  Future<List<BookInfoResponse>> getBookTrending() async {
    final BaseResponse<BookInfoResponse> response = await apiServices.getTrending(
    );
    if (response.code != null){
      List<BookInfoResponse> data = response.data!;
      return data;
    }
    return [];
  }
}
