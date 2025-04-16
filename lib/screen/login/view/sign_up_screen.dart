import 'package:book_brain/screen/login/provider/register_notifier.dart';
import 'package:book_brain/screen/login/view/login_screen.dart';
import 'package:book_brain/screen/login/widget/app_bar_continer_widget.dart';
import 'package:book_brain/utils/core/common/toast.dart'
    show showToast, showToastTop;
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/helpers/asset_helper.dart';
import 'package:book_brain/utils/core/helpers/image_helper.dart';
import 'package:book_brain/utils/router_names.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../widget/button_widget.dart' show ButtonWidget;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const String routeName = '/sign_up_screen';
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  String? selectedValue = 'Vietnamese';
  bool isSign = false;
  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<RegisterNotifier>(context);
    final model = presenter.userModel;
    return GestureDetector(
      behavior:
          HitTestBehavior
              .translucent, // Cho phép GestureDetector bắt sự kiện trên toàn bộ khu vực widget
      onTap: () {
        // Khi bên ngoài form được chạm, ẩn bàn phím bằng cách mất trọng tâm
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: AppBarContainerWidget(
        titleString: 'Đăng ký',
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: kDefaultPadding * 5),
              TextField(
                style: TextStyle(fontSize: 18, color: Colors.black),
                controller: _userNameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Tên người dùng',
                  prefixIcon: SizedBox(
                    width: 1,
                    child: Icon(FontAwesomeIcons.user),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                ),
              ),
              SizedBox(height: kDefaultPadding),
              Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  color: Colors.white,
                ),
                child: DropdownButton<String>(
                  value: selectedValue,
                  onChanged: (String? value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                  items:
                      <String>[
                        'Vietnamese',
                        'Myanmar',
                        'japan',
                        'China',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: [
                              Icon(FontAwesomeIcons.earthAsia), // Icon
                              SizedBox(
                                width: 10,
                              ), // Khoảng cách giữa icon và text
                              Text(value), // Text
                            ],
                          ),
                        );
                      }).toList(),
                  dropdownColor: Colors.white,
                  isExpanded: true,
                  underline: Container(height: 0, color: Colors.transparent),
                ),
              ),
              SizedBox(height: kDefaultPadding),
              TextField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                style: TextStyle(fontSize: 18, color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Số điện thoại',
                  prefixIcon: SizedBox(
                    width: 1,
                    child: Icon(FontAwesomeIcons.phone),
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
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Email',
                  prefixIcon: SizedBox(
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
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Mật khẩu',
                  prefixIcon: SizedBox(
                    width: 1,
                    child: Icon(FontAwesomeIcons.lock),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                ),
              ),
              SizedBox(height: kDefaultPadding),
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  children: [
                    TextSpan(
                      text: 'Bằng cách nhấn vào đăng ký, bạn đồng ý với ',
                      style: TextStyle(fontSize: 14),
                    ),
                    TextSpan(
                      text: 'Điều khoản và điều kiện ', // \n để xuống dòng
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              // Xử lý khi người dùng nhấp vào "Terms and Conditions"
                              print('Điều hướng đến Điều khoản và Điều kiện');
                            },
                    ),
                    TextSpan(
                      text: 'và ', // \n để xuống dòng
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 1.5,
                        wordSpacing: 2.0,
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              // Xử lý khi người dùng nhấp vào "and"
                              print('Điều hướng đến "và"');
                            },
                    ),
                    TextSpan(
                      text: 'Chính sách bảo mật ', // \n để xuống dòng
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              // Xử lý khi người dùng nhấp vào "Privacy Policy"
                              print('Navigate to Privacy Policy');
                            },
                    ),
                    TextSpan(
                      text: 'của ứng dụng này',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                textAlign: TextAlign.center, // Căn giữa dòng văn bản
              ),
              SizedBox(height: kDefaultPadding),
              ButtonWidget(
                title: 'Đăng ký',
                isign: isSign,
                ontap: () async {
                  bool isRegister = await presenter.register(
                    username: 'Nguyen Duc',
                    password: '123',
                    email: 'traj10x@gmail.com',
                  );

                  if (isRegister) {
                    Navigator.pushNamed(context, LoginScreen.routeName);
                  }
                },
              ),
              SizedBox(height: kDefaultPadding),
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
                      'hoặc đăng nhập bằng',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey, // Màu của đường thẳng
                      thickness: 1, // Độ dày của đường thẳng
                    ),
                  ),
                  SizedBox(height: kDefaultPadding),
                ],
              ),
              SizedBox(height: kDefaultPadding),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      // onTap: _signInWithGoogle,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ImageHelper.loadFromAsset(
                            AssetHelper.icoRectangleWhite,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ImageHelper.loadFromAsset(AssetHelper.icoGG),
                              SizedBox(width: kMinPadding),
                              Text(
                                'Google',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                          ImageHelper.loadFromAsset(
                            AssetHelper.icoRectangleBlue,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ImageHelper.loadFromAsset(AssetHelper.icoFB),
                              SizedBox(width: kMinPadding),
                              Text(
                                'Facebook',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: kDefaultPadding),
            ],
          ),
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    // Biểu thức chính quy kiểm tra cú pháp email
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    // Kiểm tra email có khớp với biểu thức chính quy hay không
    return emailRegExp.hasMatch(email);
  }
}
