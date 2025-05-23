import 'package:book_brain/screen/edit_profile/provider/profile_notifier.dart';
import 'package:book_brain/screen/login/widget/app_bar_continer_widget.dart';
import 'package:book_brain/screen/login/widget/button_widget.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:book_brain/utils/core/common/toast.dart'
    show showToast, showToastTop;
import 'package:provider/provider.dart';
import 'package:book_brain/utils/core/helpers/local_storage_helper.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});
  static const routeName = "/changepassword_screen";
  @override
  State<ChangePasswordScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ChangePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _reEnterNewPasswordController =
      TextEditingController();
  bool isSign = false;
  bool _obscurePassword = true;
  bool _obscurePassword1 = true;
  bool _obscurePassword2 = true;
  @override
  void dispose() {
    _passwordController.dispose();
    _newPasswordController.dispose();
    _reEnterNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<ProfileNotifier>(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // Khi bên ngoài form được chạm, ẩn bàn phím bằng cách mất trọng tâm
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: AppBarContainerWidget(
        titleString: "Đổi mật khẩu",
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: kDefaultPadding * 5),
              TextField(
                style: TextStyle(fontSize: 18, color: Colors.black),
                obscureText: _obscurePassword,
                controller: _passwordController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Nhập mật khẩu hiện tại',
                  prefixIcon: Container(
                    width: 1,
                    child: Icon(FontAwesomeIcons.key),
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
              TextField(
                style: TextStyle(fontSize: 18, color: Colors.black),
                obscureText: _obscurePassword1,
                controller: _newPasswordController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Nhập mật khẩu mới',
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
                        _obscurePassword1 = !_obscurePassword1;
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
              TextField(
                style: TextStyle(fontSize: 18, color: Colors.black),
                obscureText: _obscurePassword2,
                controller: _reEnterNewPasswordController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Nhập lại mật khẩu mới',
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
                        _obscurePassword2 = !_obscurePassword2;
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
              ButtonWidget(
                title: "Đổi mật khẩu",
                isign: isSign,
                ontap: _changePassword,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changePassword() async {
    if (_passwordController.text.length < 6) {
      showToastTop(message: 'Hãy nhập mật khẩu hiện tại');
      return;
    }

    if (_newPasswordController.text.length < 6) {
      showToastTop(message: 'Mật khẩu phải có ít nhất 6 ký tự');
      return;
    }

    if (_newPasswordController.text != _reEnterNewPasswordController.text) {
      showToastTop(message: "Mật khẩu mới không khớp");
      return;
    }

    setState(() {
      isSign = true;
    });

    final String oldPass = _passwordController.text.trim();
    final String newPass = _newPasswordController.text.trim();

    bool success = await Provider.of<ProfileNotifier>(
      context,
      listen: false,
    ).changePassword(oldPassword: oldPass, newPassword: newPass);

    if (success) {
      // Xóa thông tin đăng nhập đã lưu nếu có
      LocalStorageHelper.setValue("saved_email", null);
      LocalStorageHelper.setValue("saved_password", null);
      LocalStorageHelper.setValue("remember_me", null);

      // Quay lại màn hình trước đó
      Navigator.pop(context);
    }

    setState(() {
      isSign = false;
    });
  }
}
