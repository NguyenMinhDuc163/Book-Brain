import 'package:book_brain/screen/login/view/login_screen.dart';
import 'package:book_brain/screen/login/widget/app_bar_continer_widget.dart';
import 'package:book_brain/utils/core/common/toast.dart' show showToast, showToastTop;
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/helpers/asset_helper.dart';
import 'package:book_brain/utils/core/helpers/image_helper.dart';
import 'package:book_brain/utils/router_names.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../login/widget/button_widget.dart' show ButtonWidget;

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  static const String routeName="/editProfile";
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();
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
    return GestureDetector(
      behavior: HitTestBehavior
          .translucent, // Cho phép GestureDetector bắt sự kiện trên toàn bộ khu vực widget
      onTap: () {
        // Khi bên ngoài form được chạm, ẩn bàn phím bằng cách mất trọng tâm
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: AppBarContinerWidget(
        titleString: 'Chỉnh sửa thông tin',
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: kDefaultPadding * 5,
              ),
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
                        borderRadius: BorderRadius.all(Radius.circular(6)))),
              ),
              SizedBox(
                height: kDefaultPadding,
              ),
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
                  items: <String>['Việt Nam', 'Hàn Quốc', 'Nhật Bản', 'Trung Quốc', 'Ấn Độ', 'Anh', 'Pháp', 'Mỹ', 'Đức', 'Nga'] 
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        children: [
                          Icon(FontAwesomeIcons.earthAsia), // Icon
                          SizedBox(width: 10), // Khoảng cách giữa icon và text
                          Text(value), // Text
                        ],
                      ),
                    );
                  }).toList(),
                  dropdownColor: Colors.white,
                  isExpanded: true,
                  underline: Container(
                    height: 0,
                    color: Colors.transparent,
                  ),
                ),
              ),
              SizedBox(
                height: kDefaultPadding,
              ),
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
                        borderRadius: BorderRadius.all(Radius.circular(6)))),
              ),
              SizedBox(
                height: kDefaultPadding,
              ),
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
                        borderRadius: BorderRadius.all(Radius.circular(6)))),
              ),
              
              SizedBox(
                height: kDefaultPadding,
              ),
              
              ButtonWidget(
                title: 'Cập nhật',
                isign: isSign,
                ontap: _signUp,
              ),
              SizedBox(
                height: kDefaultPadding,
              ),
              
              
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
  void _signUp() async{
    // if(_passwordController.text.length < 6){
    //   showToastTop(message: 'Mật khẩu phải có ít nhất 6 ký tự');
    //   return;
    // }

    if(!isValidEmail(_emailController.text)){
      showToastTop(message: 'Email không hợp lệ');
      return;
    }
    setState(() {
      isSign = true;
    });
    await Future.delayed(const Duration(milliseconds: 400));
    final String userName = _userNameController.text.trim();
    final String email = _emailController.text.trim();
    // final String password = _passwordController.text.trim();
    final String phoneNumber = _phoneNumberController.text.trim();  
    final String? nationality= selectedValue;
    // print('userName: $userName, email: $email, password: $password, phoneNumber: $phoneNumber');
    print('userName: $userName, email: $email, phoneNumber: $phoneNumber, nationality: $nationality');

    showToast(message: "Cập nhật thông tin thành công!");
    setState(() {
      isSign = false;
    });
    // User? user = await _auth.signUpWithEmailAndPassWord(email, password, userName,  phoneNumber);

    // setState(() {
    //   isSign = false;
    //
    // });
    //
    // if(user != null){
    //   showToast(message: 'Sign up success');
    //   Navigator.of(context).pushNamed(RouteNames.loginScreen);
    // }else{
    //   showToast(message: 'Sign up failed');
    // }
  }
}
