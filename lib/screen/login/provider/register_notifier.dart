import 'package:book_brain/screen/login/services/register_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:book_brain/screen/login/model/user_model.dart';
import 'package:book_brain/screen/login/services/login_service.dart';
import 'package:book_brain/utils/core/base/base_notifier.dart';
import 'package:book_brain/utils/core/common/toast.dart';

class RegisterNotifier extends BaseNotifier{

  UserModel userModel = UserModel(); // khai báo model
  UserModel get model => userModel; // getter
  RegisterService registerService = RegisterService(); // khai báo service


  Future<bool> register({required String username, required String password, required String email}) async {
    return await execute(() async{
      bool isRegister = await registerService.register(username: username, password: password, email: email);
      notifyListeners(); // thông báo cho các widget khác biết rằng đã có sự thay đổi

      if (isRegister == 200 || isRegister == 201) {
        showToastTop(message: "account_login.login_success".tr());
        return true;
      } else {
        showToastTop(message: "account_login.login_fail".tr());
        return false;
      }
    });
  }

}