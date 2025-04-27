
import 'package:book_brain/screen/login/provider/forgot_password_notifier.dart';
import 'package:book_brain/screen/login/view/login_screen.dart';
import 'package:book_brain/screen/login/widget/app_bar_continer_widget.dart';
import 'package:book_brain/screen/login/widget/button_widget.dart';
import 'package:book_brain/utils/core/common/toast.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/router_names.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../utils/widget/loading_widget.dart';
import '../provider/login_notifier.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  static const String routeName = '/forgot_password_screen';
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool _isForgot = false;
  // final SendEmailService _sendEmailService = SendEmailService();

  bool isValidEmail(String email) {
    // Biểu thức chính quy kiểm tra cú pháp email
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    // Kiểm tra email có khớp với biểu thức chính quy hay không
    return emailRegExp.hasMatch(email);
  }
  void resetPassword(BuildContext context) async {
    setState(() {
      _isForgot = true;
    });
    if(isValidEmail(emailController.text) == false){
      showToastTop(
        message: 'Email không hợp lệ, hãy thử lại',
      );
      setState(() {
        _isForgot = false;
      });
      return;
    }

    try {

      showToastTop(
        message: 'Email đặt lại mật khẩu đã được gửi thành công. Vui lòng kiểm tra email của bạn.',
      );
      Navigator.of(context).pushNamed(LoginScreen.routeName);
    } catch (e) {
      showToastTop(
        message: 'Không gửi được email đặt lại mật khẩu',
      );
      print("log ------------------- ${e.toString()}");
    } finally {
      setState(() {
        _isForgot = false;
      });
    }



  }

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginNotifier>(context);
    return Stack(
      children: [
        AppBarContainerWidget(
          titleString: 'Quên mật khẩu',
          child: Column(
            children: [
              SizedBox(
                height: kDefaultPadding * 5,
              ),
              TextField(
                controller: emailController,
                style: TextStyle(fontSize: 18, color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Email',
                  hintText: 'Nhập email của bạn',
                  prefixIcon: Container(
                    width: 1,
                    child: Icon(FontAwesomeIcons.envelope),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: kDefaultPadding,
              ),
              ButtonWidget(
                title: 'Send',
                isign: _isForgot,
                ontap: () => resetPassword(context),
              ),
            ],
          ),
        ),
        presenter.isLoading ? const LoadingWidget() : const SizedBox(),

      ],
    );
  }
}
