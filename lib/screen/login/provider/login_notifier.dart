import 'package:book_brain/utils/core/helpers/local_storage_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:book_brain/screen/login/model/user_model.dart';
import 'package:book_brain/screen/login/services/login_service.dart';
import 'package:book_brain/utils/core/base/base_notifier.dart';
import 'package:book_brain/utils/core/common/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginNotifier extends BaseNotifier{

  UserModel userModel = UserModel(); // khai báo model
  UserModel get model => userModel; // getter
  LoginService loginService = LoginService(); // khai báo service
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<bool> login({required String username, required String password, required String tokenFCM}) async {
    return await execute(() async{
      bool isLogin = await loginService.login(username: username, password: password,tokenFCM: tokenFCM ?? "");
      notifyListeners(); // thông báo cho các widget khác biết rằng đã có sự thay đổi

      if (isLogin) {
        showToastTop(message: "account_login.login_success".tr());
        return true;
      } else {
        showToastTop(message: "account_login.login_fail".tr());
        return false;
      }
    });
  }

  Future<bool> signInWithGoogle() async {

    return await execute(() async {

      try {
        // Bắt đầu quá trình đăng nhập Google
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        if (googleUser == null) {
          return false;
        }

        // Lấy thông tin xác thực từ request
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        // Tạo credential cho Firebase
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Đăng nhập vào Firebase với credential
        final UserCredential authResult = await _auth.signInWithCredential(credential);
        User? _user = authResult.user;

        LocalStorageHelper.setValue("userName", _user?.displayName ?? "");
        LocalStorageHelper.setValue("email", _user?.email ?? '');
        LocalStorageHelper.setValue("userId", _user?.uid ?? "");


        notifyListeners();
        return true;
      } catch (error) {
        print('LỖI ĐĂNG NHẬP GOOGLE: $error');
        showToast(message: "Đăng nhập thất bại: $error");
        return false;
      }
    });

  }
}