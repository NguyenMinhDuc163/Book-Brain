import 'package:book_brain/screen/forgot_password/view/forgot_password_screen.dart';
import 'package:book_brain/screen/login/provider/login_notifier.dart';
import 'package:book_brain/screen/login/widget/app_bar_continer_widget.dart';
import 'package:book_brain/screen/login/widget/button_widget.dart';
import 'package:book_brain/screen/main_app.dart';
import 'package:book_brain/screen/search_book/view/search_screen.dart';
import 'package:book_brain/screen/login/view/sign_up_screen.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/helpers/asset_helper.dart';
import 'package:book_brain/utils/core/helpers/image_helper.dart';
import 'package:book_brain/utils/core/helpers/local_storage_helper.dart';
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
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginNotifier>(context);
    final model = presenter.userModel;
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior
            .translucent, // Cho phép GestureDetector bắt sự kiện trên toàn bộ khu vực widget
        onTap: () {
          // Khi bên ngoài form được chạm, ẩn bàn phím bằng cách mất trọng tâm
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: AppBarContainerWidget(
          titleString: 'Đăng nhập',
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: kDefaultPadding * 5,
                ),
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
                          borderRadius: BorderRadius.all(Radius.circular(6)))),
                ),
                SizedBox(
                  height: kDefaultPadding,
                ),
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
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
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
                      )),
                ),
                SizedBox(
                  height: kDefaultPadding,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                            value: _isCheck,
                            onChanged: (bool? val) {
                              setState(() {
                                _isCheck = val ?? false;
                              });
                            }),
                        // SizedBox(width: kDefaultPadding,),
                        Text(
                          'Nhớ mật khẩu',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: kMediumPadding,
                    ),
                    InkWell(
                      child: Text(
                        'Quên mật khẩu',
                        style: TextStyle(
                            fontSize: 14,
                            color: _isPressed ? Colors.purple : Colors.blue),
                      ),
                      onTap: () {
                        setState(() {
                          if (!_isPressed) _isPressed = true;
                          Navigator.of(context)
                              .pushNamed(ForgotPasswordScreen.routeName);
                        });
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: kDefaultPadding,
                ),
                //TODO login button
                ButtonWidget(
                  title: 'Đăng nhập',
                  isign: _isSigin,
                  ontap: () async {
                    // presenter.login(username: "", password: "");
                    final tokenFCM = LocalStorageHelper.getValue('fcm_token');

                    bool isSend = await presenter.login(
                      username: _emailController.text,
                      password: _passwordController.text,
                      tokenFCM: tokenFCM ?? "123",
                    );
                    if (isSend) {
                      Navigator.of(context).pushNamed(MainApp.routeName);
                    }

                  },
                ),
                SizedBox(
                  height: kDefaultPadding,
                ),
                Row(
                  children: const [
                    Expanded(
                      child: Divider(
                        color: Colors.grey, // Màu của đường thẳng
                        thickness: 1, // Độ dày của đường thẳng
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Hoặc đăng nhập với',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey, // Màu của đường thẳng
                        thickness: 1, // Độ dày của đường thẳng
                      ),
                    ),
                    SizedBox(
                      height: kDefaultPadding,
                    ),
                  ],
                ),
                SizedBox(
                  height: kDefaultPadding,
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector( 
                        onTap: (){},
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ImageHelper.loadFromAsset(AssetHelper.icoRectangleWhite),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ImageHelper.loadFromAsset(AssetHelper.icoGG),
                                SizedBox(
                                  width: kMinPadding,
                                ),
                                Text(
                                  'Google',
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Navigator.of(context).pushNamed(TicketStubScreen.routeName);
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ImageHelper.loadFromAsset(AssetHelper.icoRectangleBlue),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ImageHelper.loadFromAsset(AssetHelper.icoFB),
                                SizedBox(
                                  width: kMinPadding,
                                ),
                                Text(
                                  'Facebook',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: kDefaultPadding,
                ),
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
                            color: _isCliclSignUp ? Colors.purple : Colors.blue),
                      ),
                      onTap: () {
                        // setState(() {
                        //   if (!_isCliclSignUp) _isCliclSignUp = true;
                        // });
                        Navigator.of(context).pushNamed(SignUpScreen.routeName);
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
