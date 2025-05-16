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

import '../../../utils/widget/loading_widget.dart';
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
      child: Stack(
        children: [
          AppBarContainerWidget(
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
                                  print(
                                    'Điều hướng đến Điều khoản và Điều kiện',
                                  );
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
                      if (!validateInputs()) {
                        return;
                      }

                      bool isRegister = await presenter.register(
                        username: _userNameController.text.trim(),
                        password: _passwordController.text.trim(),
                        email: _emailController.text.trim(),
                        phoneNumber: _phoneNumberController.text.trim(),
                      );
                      if (isRegister) {
                        Navigator.pushNamed(context, LoginScreen.routeName);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          presenter.isLoading ? const LoadingWidget() : const SizedBox(),
        ],
      ),
    );
  }

  bool isValidPhoneNumber(String phoneNumber) {
    // Kiểm tra số điện thoại Việt Nam
    // Format: 0 + 9 số hoặc +84 + 9 số
    final RegExp phoneRegex = RegExp(r'^(0|\+84)([0-9]{9})$');

    // Loại bỏ khoảng trắng và dấu gạch ngang
    String cleanPhone = phoneNumber.replaceAll(RegExp(r'[\s-]'), '');

    return phoneRegex.hasMatch(cleanPhone);
  }

  bool isValidEmail(String email) {
    if (email.isEmpty) return false;

    // Loại bỏ khoảng trắng ở đầu và cuối
    email = email.trim();

    // Kiểm tra độ dài tối đa của email
    if (email.length > 254) return false;

    // Biểu thức chính quy kiểm tra cú pháp email chặt chẽ hơn
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      caseSensitive: false,
    );

    // Kiểm tra các trường hợp đặc biệt
    if (email.contains('..')) return false;
    if (email.startsWith('.') || email.endsWith('.')) return false;
    if (email.contains('@.') || email.contains('.@')) return false;

    // Kiểm tra phần domain
    final parts = email.split('@');
    if (parts.length != 2) return false;

    final domain = parts[1];
    if (domain.length > 255) return false;
    if (domain.startsWith('.') || domain.endsWith('.')) return false;

    return emailRegExp.hasMatch(email);
  }

  bool validateInputs() {
    if (_userNameController.text.trim().isEmpty) {
      showToastTop(message: 'Vui lòng nhập tên người dùng');
      return false;
    }

    if (_userNameController.text.trim().length < 3) {
      showToastTop(message: 'Tên người dùng phải có ít nhất 3 ký tự');
      return false;
    }

    if (_emailController.text.trim().isEmpty) {
      showToastTop(message: 'Vui lòng nhập email');
      return false;
    }

    if (!isValidEmail(_emailController.text)) {
      showToastTop(message: 'Email không hợp lệ, vui lòng kiểm tra lại');
      return false;
    }

    if (_phoneNumberController.text.trim().isEmpty) {
      showToastTop(message: 'Vui lòng nhập số điện thoại');
      return false;
    }

    if (!isValidPhoneNumber(_phoneNumberController.text)) {
      showToastTop(
        message:
            'Số điện thoại không hợp lệ. Vui lòng nhập theo định dạng: 0xxxxxxxxx hoặc +84xxxxxxxxx',
      );
      return false;
    }

    if (_passwordController.text.trim().isEmpty) {
      showToastTop(message: 'Vui lòng nhập mật khẩu');
      return false;
    }

    if (_passwordController.text.length < 6) {
      showToastTop(message: 'Mật khẩu phải có ít nhất 6 ký tự');
      return false;
    }

    return true;
  }
}
