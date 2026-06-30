import 'package:book_brain/screen/edit_profile/view/edit_profile_screen.dart';
import 'package:book_brain/screen/edit_profile/provider/profile_notifier.dart';
import 'package:book_brain/screen/home/provider/home_notifier.dart';
import 'package:book_brain/screen/login/view/login_screen.dart';
import 'package:book_brain/screen/login/view/sign_up_screen.dart';
import 'package:book_brain/screen/login/widget/app_bar_continer_widget.dart';
import 'package:book_brain/screen/main_app.dart';
import 'package:book_brain/service/service_config/network_service.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:book_brain/utils/core/helpers/asset_helper.dart'
    show AssetHelper;
import 'package:book_brain/utils/core/common/toast.dart';
import 'package:book_brain/utils/core/helpers/local_storage_helper.dart';
import 'package:book_brain/utils/core/helpers/auth_helper.dart';
import 'package:easy_localization/easy_localization.dart';
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
    final isLoggedIn = AuthHelper.isLoggedIn;

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
                  username:
                      isLoggedIn
                          ? (presenter.userName ?? "")
                          : 'guest.guest_name'.tr(),
                  email:
                      isLoggedIn
                          ? (presenter.email ?? "")
                          : 'guest.guest_status'.tr(),
                  isLoggedIn: isLoggedIn,
                ),
                SizedBox(height: kDefaultPadding),
                isLoggedIn
                    ? _buildAccountSection()
                    : _buildGuestAccountSection(),
                SizedBox(height: kDefaultPadding),
                _buildAboutSection(),
                SizedBox(height: kDefaultPadding * 2),
                if (isLoggedIn) _buildLogoutButton(),
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
    required bool isLoggedIn,
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
              backgroundImage:
                  isLoggedIn ? AssetImage(AssetHelper.avatar) : null,
              child:
                  isLoggedIn
                      ? null
                      : FaIcon(
                        FontAwesomeIcons.user,
                        size: 24,
                        color: Color(0xFF6A5AE0),
                      ),
            ),
          ),
          SizedBox(width: kDefaultPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
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
          if (isLoggedIn)
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
              _buildDivider(),
              _buildSettingItem(
                "settings.delete_account".tr(),
                Colors.red,
                _showDeleteAccountDialog,
                subtitle: "settings.delete_account_subtitle".tr(),
                iconData: FontAwesomeIcons.trash,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGuestAccountSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFF0EDFF)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFDCD7FA)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6357CC).withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFE8E4FF),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.bookBookmark,
                size: 20,
                color: Color(0xFF6357CC),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'guest.account_cta_title'.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF323B4B),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'guest.account_cta_message'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed:
                      () => Navigator.of(
                        context,
                      ).pushNamed(LoginScreen.routeName),
                  icon: const Icon(Icons.login_rounded, size: 18),
                  label: Text('auth.login'.tr()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6357CC),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed:
                      () => Navigator.of(
                        context,
                      ).pushNamed(SignUpScreen.routeName),
                  icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
                  label: Text('guest.register'.tr()),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF6357CC),
                    side: const BorderSide(color: Color(0xFFB9B4E4)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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
              _buildSettingItem("Hỗ trợ", Color(0xFF6A5AE0), () async {
                final Uri url = Uri.parse(
                  'https://nguyenduc163.notion.site/Nguyen-Duc-Apps-Support-38303bc2971180bfa793f871713beba5',
                );
                if (!await launchUrl(
                  url,
                  mode: LaunchMode.externalApplication,
                )) {
                  throw 'Could not launch URL';
                }
              }, subtitle: "Liên hệ hỗ trợ kỹ thuật"),
              _buildDivider(),
              _buildSettingItem(
                "Điều khoản sử dụng",
                Color(0xFF38C9A7),
                () async {
                  final Uri url = Uri.parse(
                    'https://nguyenduc163.notion.site/Privacy-Policy-for-Book-Brain-38303bc29711809daae3e77cb0f1cae6',
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
                      onPressed: () async {
                        await _clearAccountLocalData();
                        await AuthHelper.continueAsGuest();
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          MainApp.routeName,
                          (_) => false,
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

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("settings.delete_account".tr()),
            content: Text("settings.delete_account_warning".tr()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("settings.cancel".tr()),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _deleteAccount();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text(
                  "settings.delete".tr(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  Future<void> _deleteAccount() async {
    try {
      bool success =
          await Provider.of<ProfileNotifier>(
            context,
            listen: false,
          ).deleteAccount();

      if (success && mounted) {
        _showDeleteAccountSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        showToastTop(message: "settings.delete_account_failed".tr());
      }
    }
  }

  void _showDeleteAccountSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: Text("settings.delete_account_success_title".tr()),
            content: Text("settings.delete_account_success_message".tr()),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  await _clearAccountLocalData();
                  await AuthHelper.continueAsGuest();
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                  Navigator.of(
                    this.context,
                  ).pushNamedAndRemoveUntil(MainApp.routeName, (_) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6A5AE0),
                ),
                child: Text(
                  "settings.close".tr(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  Future<void> _clearAccountLocalData() async {
    await LocalStorageHelper.setValue("authToken", null);
    await LocalStorageHelper.setValue("userName", null);
    await LocalStorageHelper.setValue("email", null);
    await LocalStorageHelper.setValue("userId", null);
    await LocalStorageHelper.setValue("saved_email", null);
    await LocalStorageHelper.setValue("saved_password", null);
    await LocalStorageHelper.setValue("remember_me", null);
    await LocalStorageHelper.setValue('ignoreIntroScreen', false);
    NetworkService.instance.updateAuthToken('');
  }

  Widget _buildSettingItem(
    String title,
    Color iconColor,
    VoidCallback onTap, {
    String? subtitle,
    IconData? iconData,
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
              child: FaIcon(
                iconData ?? getIconData(title),
                size: 16,
                color: iconColor,
              ),
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
