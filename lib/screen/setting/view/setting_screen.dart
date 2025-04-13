import 'package:book_brain/screen/change_password/view/change_password_screen.dart';
import 'package:book_brain/screen/edit_profile/view/edit_profile_screen.dart';
import 'package:book_brain/screen/login/view/login_screen.dart';
import 'package:book_brain/utils/core/helpers/asset_helper.dart' show AssetHelper;
import 'package:book_brain/utils/core/helpers/image_helper.dart';
import 'package:book_brain/screen/login/widget/app_bar_continer_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});
  static const routeName = "/settingScreen";
  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Đăng xuất'),
          content: Text('Bạn có chắc chắn muốn đăng xuất không?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: Text('Hủy'), 
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
                
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false, // Xóa toàn bộ stack điều hướng
                );
              },
              child: Text('Đồng ý'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: AppBarContinerWidget(
        titleString: "Cài đặt",
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: kDefaultPadding * 5,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kMediumPadding),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    _buildSettingItem(
                      "Chỉnh sửa thông tin",
                      const Color.fromARGB(255, 0, 0, 0),
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditProfileScreen()),
                      ),
                    ),
                    _buildSettingItem(
                      "Thông báo",
                      const Color.fromARGB(255, 0, 0, 0),
                      () {},
                    ),
                    _buildSettingItem(
                      "Đổi mật khẩu",
                      const Color.fromARGB(255, 0, 0, 0),
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                      ),
                    ),
                    _buildSettingItem(
                      "Đăng xuất",
                      const Color.fromARGB(255, 0, 0, 0),
                      () => _showLogoutConfirmationDialog(), 
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(String title, Color iconColor, VoidCallback onTap) {
    IconData getIconData(String title) {
      switch (title) {
        case "Chỉnh sửa thông tin":
          return FontAwesomeIcons.userEdit;
        case "Thông báo":
          return FontAwesomeIcons.bell;
        case "Đổi mật khẩu":
          return FontAwesomeIcons.key;
        case "Đăng xuất":
          return FontAwesomeIcons.signOutAlt;
        default:
          return FontAwesomeIcons.circle;
      }
    }

    return Padding(
      padding: EdgeInsets.all(kItemPadding * 1.5),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            FaIcon(
              getIconData(title),
              size: kDefaultIconSize * 1.2,
              color: iconColor,
            ),
            SizedBox(width: kItemPadding),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            Spacer(),
            FaIcon(
              FontAwesomeIcons.chevronRight,
              size: kDefaultIconSize,
              color: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }
}