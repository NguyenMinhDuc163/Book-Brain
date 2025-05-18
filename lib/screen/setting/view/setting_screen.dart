import 'package:book_brain/screen/edit_profile/view/edit_profile_screen.dart';
import 'package:book_brain/screen/home/provider/home_notifier.dart';
import 'package:book_brain/screen/login/view/login_screen.dart';
import 'package:book_brain/screen/login/widget/app_bar_continer_widget.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/helpers/asset_helper.dart'
    show AssetHelper;
import 'package:book_brain/utils/core/helpers/local_storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'change_password_screen.dart' show ChangePasswordScreen;

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});
  static const routeName = "/settingScreen";
  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<HomeNotifier>(context, listen: false).getData(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<HomeNotifier>(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: AppBarContainerWidget(
        titleString: "Cài đặt",
        isShowBackButton: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: kDefaultPadding,
              vertical: kDefaultPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileSection(
                  username: presenter.userName ?? "",
                  email: presenter.email ?? "",
                ),
                SizedBox(height: kDefaultPadding),
                _buildAccountSection(),
                SizedBox(height: kDefaultPadding),
                _buildAboutSection(),
                SizedBox(height: kDefaultPadding * 2),
                _buildLogoutButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection({
    required String username,
    required String email,
  }) {
    return Container(
      padding: EdgeInsets.all(kMediumPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Color(0xFF6A5AE0), width: 2),
            ),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[200],
              backgroundImage: AssetImage(AssetHelper.avatar),
            ),
          ),
          SizedBox(width: kDefaultPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username ?? '',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfileScreen()),
              );
            },
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFF6A5AE0).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: FaIcon(
                FontAwesomeIcons.penToSquare,
                size: 16,
                color: Color(0xFF6A5AE0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            "Tài khoản",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildSettingItem(
                "Chỉnh sửa thông tin",
                Color(0xFF6A5AE0),
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfileScreen()),
                ),
                subtitle: "Thay đổi thông tin cá nhân",
              ),
              _buildDivider(),
              _buildSettingItem(
                "Đổi mật khẩu",
                Color(0xFF6A5AE0),
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangePasswordScreen(),
                  ),
                ),
                subtitle: "Cập nhật mật khẩu của bạn",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            "Thông tin",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildSettingItem("Về Book Brain", Color(0xFF38C9A7), () async {
                final Uri url = Uri.parse(
                  'https://github.com/NguyenMinhDuc163/Book-Brain/blob/main/README.md',
                );
                if (!await launchUrl(
                  url,
                  mode: LaunchMode.externalApplication,
                )) {
                  throw 'Could not launch URL}';
                }
              }, subtitle: "Phiên bản 1.0.0"),
              _buildDivider(),
              _buildSettingItem("Hỗ trợ", Color(0xFF6A5AE0), () {
                launchEmail(context);
              }, subtitle: "Liên hệ hỗ trợ kỹ thuật"),
              _buildDivider(),
              _buildSettingItem(
                "Điều khoản sử dụng",
                Color(0xFF38C9A7),
                () async {
                  final Uri url = Uri.parse(
                    'https://www.freeprivacypolicy.com/live/e98e0bef-5336-4269-8197-71cd770e1c24',
                  );
                  if (!await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  )) {
                    throw 'Could not launch URL}';
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: Text("Đăng xuất"),
                  content: Text("Bạn có chắc chắn muốn đăng xuất không?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Hủy"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        LocalStorageHelper.setValue('ignoreIntroScreen', false);
                        Navigator.pop(context);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6A5AE0),
                      ),
                      child: Text(
                        "Đăng xuất",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.red.shade300),
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.rightFromBracket,
              size: 16,
              color: Colors.red.shade400,
            ),
            SizedBox(width: 8),
            Text(
              "Đăng xuất",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.red.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    String title,
    Color iconColor,
    VoidCallback onTap, {
    String? subtitle,
  }) {
    IconData getIconData(String title) {
      switch (title) {
        case "Chỉnh sửa thông tin":
          return FontAwesomeIcons.userPen;
        case "Thông báo":
          return FontAwesomeIcons.bell;
        case "Đổi mật khẩu":
          return FontAwesomeIcons.key;
        case "Đăng xuất":
          return FontAwesomeIcons.rightFromBracket;
        case "Về Book Brain":
          return FontAwesomeIcons.circleInfo;
        case "Hỗ trợ":
          return FontAwesomeIcons.headset;
        case "Điều khoản sử dụng":
          return FontAwesomeIcons.fileContract;
        default:
          return FontAwesomeIcons.circle;
      }
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: FaIcon(getIconData(title), size: 16, color: iconColor),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ],
              ),
            ),
            FaIcon(
              FontAwesomeIcons.chevronRight,
              size: 14,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem(
    String title,
    IconData iconData,
    bool value,
    Function(bool) onChanged,
    Color iconColor,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: FaIcon(iconData, size: 16, color: iconColor),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Color(0xFF6A5AE0),
            activeTrackColor: Color(0xFF6A5AE0).withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(color: Colors.grey.shade200, height: 1),
    );
  }

  Future<void> launchEmail(BuildContext context) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'ngminhduc1603@gmail.com',
      queryParameters: {
        'subject': 'Báo cáo sự cố - Book Brain',
        'body': 'Mô tả sự cố: \n\nThời gian: ${DateTime.now().toString()}\n\n',
      },
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể mở ứng dụng email'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
