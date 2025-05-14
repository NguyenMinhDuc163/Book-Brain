import 'package:book_brain/screen/login/view/forgot_password_screen.dart';
import 'package:book_brain/screen/login/provider/login_notifier.dart';
import 'package:book_brain/screen/login/widget/app_bar_continer_widget.dart';
import 'package:book_brain/screen/login/widget/button_widget.dart';
import 'package:book_brain/screen/main_app.dart';
import 'package:book_brain/screen/login/view/sign_up_screen.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/helpers/asset_helper.dart';
import 'package:book_brain/utils/core/helpers/image_helper.dart';
import 'package:book_brain/utils/core/helpers/local_storage_helper.dart';
import 'package:book_brain/utils/widget/loading_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routeName = '/LoginScreen';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isCheck = false;
  bool _isPressed = false;
  bool _isSigin = false;
  bool _isCliclSignUp = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  void _loadSavedCredentials() {
    final savedEmail = LocalStorageHelper.getValue("saved_email");
    final savedPassword = LocalStorageHelper.getValue("saved_password");
    final isRememberMe = LocalStorageHelper.getValue("remember_me") == "true";

    setState(() {
      _isCheck = isRememberMe;
      if (isRememberMe && savedEmail != null && savedPassword != null) {
        _emailController.text = savedEmail;
        _passwordController.text = savedPassword;
      } else if (kDebugMode) {
        // Chỉ set giá trị mặc định trong chế độ debug
        _emailController.text = 'traj10x@gmail.com';
        _passwordController.text = '123456';
      }
    });
  }

  void _saveCredentials() {
    if (_isCheck) {
      LocalStorageHelper.setValue("saved_email", _emailController.text);
      LocalStorageHelper.setValue("saved_password", _passwordController.text);
      LocalStorageHelper.setValue("remember_me", "true");
    } else {
      // Xóa thông tin đã lưu nếu không chọn nhớ mật khẩu
      LocalStorageHelper.setValue("saved_email", null);
      LocalStorageHelper.setValue("saved_password", null);
      LocalStorageHelper.setValue("remember_me", null);
    }
  }

  void _onRememberMeChanged(bool? value) {
    setState(() {
      _isCheck = value ?? false;
      // Lưu trạng thái ngay khi checkbox thay đổi
      LocalStorageHelper.setValue("remember_me", _isCheck ? "true" : null);
      if (!_isCheck) {
        // Nếu bỏ chọn, xóa thông tin đã lưu
        LocalStorageHelper.setValue("saved_email", null);
        LocalStorageHelper.setValue("saved_password", null);
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginNotifier>(context);

    final model = presenter.userModel;
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: [
            AppBarContainerWidget(
              titleString: 'Đăng nhập',
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: kDefaultPadding * 5),
                    TextField(
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Email',
                        prefixIcon: Container(
                          width: 1,
                          child: Icon(FontAwesomeIcons.envelope),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                      ),
                    ),
                    SizedBox(height: kDefaultPadding),
                    TextField(
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      obscureText: _obscurePassword,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Mật khẩu',
                        prefixIcon: Container(
                          width: 1,
                          child: Icon(FontAwesomeIcons.lock),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          borderSide: BorderSide(color: Colors.white, width: 1),
                        ),
                      ),
                    ),
                    SizedBox(height: kDefaultPadding),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _isCheck,
                              onChanged: _onRememberMeChanged,
                            ),
                            Text(
                              'Nhớ mật khẩu',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        SizedBox(width: kMediumPadding),
                        // InkWell(
                        //   child: Text(
                        //     'Quên mật khẩu',
                        //     style: TextStyle(
                        //       fontSize: 14,
                        //       color: _isPressed ? Colors.purple : Colors.blue,
                        //     ),
                        //   ),
                        //   onTap: () {
                        //     setState(() {
                        //       if (!_isPressed) _isPressed = true;
                        //       Navigator.of(
                        //         context,
                        //       ).pushNamed(ForgotPasswordScreen.routeName);
                        //     });
                        //   },
                        // ),
                      ],
                    ),
                    SizedBox(height: kDefaultPadding),

                    ButtonWidget(
                      title: 'Đăng nhập',
                      isign: _isSigin,
                      ontap: () async {
                        final tokenFCM = LocalStorageHelper.getValue(
                          'fcm_token',
                        );

                        bool isSend = await presenter.login(
                          username: _emailController.text,
                          password: _passwordController.text,
                          tokenFCM: tokenFCM ?? "123",
                        );

                        if (isSend) {
                          _saveCredentials(); // Lưu thông tin đăng nhập nếu đăng nhập thành công
                          Navigator.of(context).pushNamed(MainApp.routeName);
                        }
                      },
                    ),
                    SizedBox(height: kDefaultPadding),
                    Row(
                      children: const [
                        Expanded(
                          child: Divider(color: Colors.grey, thickness: 1),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Hoặc đăng nhập với',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        Expanded(
                          child: Divider(color: Colors.grey, thickness: 1),
                        ),
                        SizedBox(height: kDefaultPadding),
                      ],
                    ),
                    SizedBox(height: kDefaultPadding),
                    InkWell(
                      onTap: () async {
                        // bool isLogin = await presenter.signInWithGoogle();

                        // if (!isLogin) return;

                        Navigator.of(context).pushNamed(MainApp.routeName);
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ImageHelper.loadFromAsset(AssetHelper.icoGG),
                            SizedBox(width: 8),
                            Text(
                              'Google',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: kDefaultPadding),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Bạn chưa có tài khoản ? ',
                          style: TextStyle(fontSize: 14),
                        ),
                        InkWell(
                          child: Text(
                            'Đăng ký',
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  _isCliclSignUp ? Colors.purple : Colors.blue,
                            ),
                          ),
                          onTap: () {
                            Navigator.of(
                              context,
                            ).pushNamed(SignUpScreen.routeName);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            presenter.isLoading ? const LoadingWidget() : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
