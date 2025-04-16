import 'package:book_brain/screen/login/services/login_interface.dart';
import 'package:book_brain/screen/login/services/register_inteface.dart';
import 'package:book_brain/service/api_service/api_service.dart';
import 'package:book_brain/service/api_service/request/RegisterRequest.dart';
import 'package:book_brain/service/api_service/request/login_request.dart';
import 'package:book_brain/service/api_service/response/RegisterResponse.dart';
import 'package:book_brain/service/api_service/response/base_response.dart';
import 'package:book_brain/service/api_service/response/login_response.dart';
import 'package:book_brain/utils/core/common/toast.dart';
import 'package:book_brain/utils/core/helpers/local_storage_helper.dart';
import 'package:easy_localization/easy_localization.dart';

class RegisterService implements IRegisterInterface {
  final ApiServices apiServices = ApiServices();

  @override
  Future<bool> register({required String username, required String password, required String email}) async {
    RegisterRequest request = RegisterRequest(email: email, password: password,  username: username);
    final BaseResponse<RegisterResponse> response = await apiServices.sendRegister(
      request,
    );

    if (response.code != null) {
      final tokenFCM = LocalStorageHelper.getValue('fcm_token');
      if (response.code == 200 || response.code == 201) {
        showToastTop(
          message: response.message.toString(),
        );
        return true;
      } else {
        showToast(
          message: "${'Đăng nhập thất bại'.tr()}: ${response.message}",
        );
        return false;
      }
    }
    return response.code == 200 || response.code == 201;

  }
}
