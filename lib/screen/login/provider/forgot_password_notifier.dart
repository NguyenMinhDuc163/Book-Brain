import 'package:book_brain/screen/login/services/forgot_password_service.dart';
import 'package:book_brain/screen/login/services/register_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:book_brain/screen/login/model/user_model.dart';
import 'package:book_brain/screen/login/services/login_service.dart';
import 'package:book_brain/utils/core/base/base_notifier.dart';
import 'package:book_brain/utils/core/common/toast.dart';

import '../../../utils/core/helpers/local_storage_helper.dart';

class ForgotPasswordNotifier extends BaseNotifier{

  UserModel userModel = UserModel(); // khai báo model
  UserModel get model => userModel; // getter
  ForgotPasswordService forgotPasswordService = ForgotPasswordService(); // khai báo service


  Future<bool> forgotPassword({ required String oldPassword, required String newPassword}) async {
    int id = int.tryParse(LocalStorageHelper.getValue("userId")) ?? 1;

    return await execute(() async{
      bool isForgotPassword = await forgotPasswordService.forgotPassword(id: id, oldPassword: oldPassword, newPassword: newPassword);
      notifyListeners(); //thông báo cho các widget khác biết  rằng đã có sự thay đổi

      if (isForgotPassword ) {
        showToastTop(message: "Đông mật khẩu thành công");
        return true;
      } else {
        showToastTop(message: "Đổi mật khẩu thất bại");
        return false;
      }
    });
  }

}