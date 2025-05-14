import 'package:book_brain/screen/edit_profile/provider/profile_notifier.dart';
import 'package:book_brain/screen/home/provider/home_notifier.dart';
import 'package:book_brain/screen/login/view/login_screen.dart';
import 'package:book_brain/screen/login/widget/app_bar_continer_widget.dart';
import 'package:book_brain/utils/core/common/toast.dart'
    show showToast, showToastTop;
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/helpers/asset_helper.dart';
import 'package:book_brain/utils/core/helpers/image_helper.dart';
import 'package:book_brain/utils/core/helpers/local_storage_helper.dart';
import 'package:book_brain/utils/router_names.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../login/widget/button_widget.dart' show ButtonWidget;

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  static const String routeName = "/editProfile";
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  String? selectedValue = 'Việt Nam';
  bool isSign = false;
  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    // _passwordController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<ProfileNotifier>(context);

    return GestureDetector(
      behavior:
          HitTestBehavior
              .translucent, // Cho phép GestureDetector bắt sự kiện trên toàn bộ khu vực widget
      onTap: () {
        // Khi bên ngoài form được chạm, ẩn bàn phím bằng cách mất trọng tâm
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: AppBarContainerWidget(
        titleString: 'Chỉnh sửa thông tin',
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

              ButtonWidget(title: 'Cập nhật', isign: isSign, ontap: _signUp),
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

  void _signUp() async {
    setState(() {
      isSign = true;
    });
    final String userName = _userNameController.text.trim();
    final String email = _emailController.text.trim();
    final String phoneNumber = _phoneNumberController.text.trim();
    final String? nationality = selectedValue;
    print(
      'userName: $userName, email: $email, phoneNumber: $phoneNumber, nationality: $nationality',
    );
    bool success = await Provider.of<ProfileNotifier>(
      context,
      listen: false,
    ).updateProfile(email: email, phoneNumber: phoneNumber, userName: userName);

    if (success) {
      showToastTop(message: "Cập nhật thông tin thành công!");
      setState(() {
        isSign = false;
        LocalStorageHelper.setValue("userName", userName ?? "");
      });
      // Gọi getData() của HomeNotifier khi quay lại
      if (mounted) {
        Provider.of<HomeNotifier>(context, listen: false).getData();
      }
      Navigator.pop(context);
    } else {
      showToastTop(message: "Cập nhật thông tin thất bại!");
      setState(() {
        isSign = false;
      });
    }
  }
}
