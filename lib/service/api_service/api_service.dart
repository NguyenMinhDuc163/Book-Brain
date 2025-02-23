

import 'package:book_brain/service/api_service/BaseApiService.dart';
import 'package:book_brain/service/api_service/request/login_request.dart';
import 'package:book_brain/service/api_service/response/base_response.dart';
import 'package:book_brain/service/api_service/response/login_response.dart';

class ApiServices extends BaseApiService {
  // api login
  Future<BaseResponse<LoginResponse>> sendLogin(LoginRequest request) async {
    return await sendRequest<LoginResponse>(
      'auth/login',
      method: 'POST',
      data: request.toJson(),
      fromJson: (json) => LoginResponse.fromJson(json),
    );
    // // GET
    // Future<BaseResponse<GetFamilyResponse>> getFamily({
    //   int? userId,
    // }) async {
    //   final queryParams = <String, int>{};
    //
    //   // Thêm tham số vào queryParams nếu chúng không null hoặc không rỗng
    //   if (userId != null) {
    //     queryParams["user_id"] = userId;
    //   }
    //
    //   return await sendRequest<GetFamilyResponse>(
    //     'family/list',
    //     method: 'GET',
    //     data: queryParams, // Truyền queryParams vào đây
    //     fromJson: (json) => GetFamilyResponse.fromJson(json),
    //   );
    // }

  }
}




