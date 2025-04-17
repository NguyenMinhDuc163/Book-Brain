

import 'package:book_brain/service/api_service/BaseApiService.dart';
import 'package:book_brain/service/api_service/request/RegisterRequest.dart';
import 'package:book_brain/service/api_service/request/login_request.dart';
import 'package:book_brain/service/api_service/response/base_response.dart';
import 'package:book_brain/service/api_service/response/book_info_response.dart';
import 'package:book_brain/service/api_service/response/detail_book_response.dart';
import 'package:book_brain/service/api_service/response/login_response.dart';
import 'package:book_brain/service/common/url_static.dart';

import 'response/RegisterResponse.dart';

class ApiServices extends BaseApiService {
  // api login
  Future<BaseResponse<LoginResponse>> sendLogin(LoginRequest request) async {
    return await sendRequest<LoginResponse>(
      UrlStatic.API_LOGIN,
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => LoginResponse.fromJson(json),
    );
  }

  Future<BaseResponse<RegisterResponse>> sendRegister(RegisterRequest request) async {
    return await sendRequest<RegisterResponse>(
      UrlStatic.API_REGISTER,
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => RegisterResponse.fromJson(json),
    );
  }



// GET
Future<BaseResponse<BookInfoResponse>> getInfoBook(
) async {
  return await sendRequest<BookInfoResponse>(
    UrlStatic.API_INFO_BOOK,
    method: 'GET',
    // data: {}, // Truyền queryParams vào đây
    fromJson: (json) => BookInfoResponse.fromJson(json),
  );
}


    // GET
    Future<BaseResponse<DetailBookResponse>> getDetailBook({
      required int bookId,
      required int chapterId,
    }) async {
      final queryParams = <String, int>{};

        queryParams["id"] = bookId;
        queryParams["chapter"] = chapterId;

      return await sendRequest<DetailBookResponse>(
        'detailBook',
        method: 'GET',
        data: queryParams, // Truyền queryParams vào đây
        fromJson: (json) => DetailBookResponse.fromJson(json),
      );
    }

}




