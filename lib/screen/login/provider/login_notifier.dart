import 'package:easy_localization/easy_localization.dart';
import 'package:book_brain/screen/login/model/user_model.dart';
import 'package:book_brain/screen/login/services/login_service.dart';
import 'package:book_brain/utils/core/base/base_notifier.dart';
import 'package:book_brain/utils/core/common/toast.dart';

class LoginNotifier extends BaseNotifier{

  UserModel userModel = UserModel(); // khai báo model
  UserModel get model => userModel; // getter
  LoginService loginService = LoginService(); // khai báo service


  Future<bool> login({required String username, required String password, }) async {
    return await execute(() async{
      print("xin chào");
      return true;
    });
  }

}