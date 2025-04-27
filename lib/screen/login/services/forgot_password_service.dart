import 'package:book_brain/screen/login/services/forgot_password_interface.dart';
import 'package:book_brain/service/api_service/api_service.dart';
import 'package:book_brain/service/api_service/request/forgot_password_request.dart';
import 'package:book_brain/service/api_service/response/base_response.dart';
import 'package:book_brain/service/api_service/response/forgot_password_response.dart';
import 'package:book_brain/utils/core/common/toast.dart';
import 'package:easy_localization/easy_localization.dart';

class ForgotPasswordService implements IForgotPasswordInterface {
  final ApiServices apiServices = ApiServices();

  @override
  Future<bool> forgotPassword({required int id, required String oldPassword, required String newPassword}) async{
    ForgotPasswordRequest request = ForgotPasswordRequest(      id: id,
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
    final BaseResponse<ForgotPasswordResponse> response = await apiServices.forgotPassword(
      request,
    );

    if (response.code != null) {
      if (response.code == 200 || response.code == 201) {
        showToastTop(
          message: response.message.toString(),
        );
        return true;
      } else {
        showToast(
          message: "${'Đổi mật khẩu thất bại'.tr()}: ${response.message}",
        );
        return false;
      }
    }
    return response.code == 200 || response.code == 201;
  }
}
