import 'package:book_brain/screen/login/view/login_screen.dart';
import 'package:book_brain/utils/core/constants/color_constants.dart';
import 'package:book_brain/utils/core/constants/textstyle_ext.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Future<void> showLoginRequiredDialog(
  BuildContext context, {
  String? message,
}) async {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text('guest.login_required_title'.tr()),
        content: Text(
          '${message ?? 'guest.login_required_default'.tr()}\n\n'
          '${'guest.public_features_available'.tr()}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('guest.later'.tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Navigator.of(context).pushNamed(LoginScreen.routeName);
            },
            child: Text('auth.login'.tr()),
          ),
        ],
      );
    },
  );
}

class LoginRequiredView extends StatelessWidget {
  const LoginRequiredView({super.key, required this.message, this.onLogin});

  final String message;
  final VoidCallback? onLogin;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline,
              size: 56,
              color: ColorPalette.primaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyles.defaultStyle.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed:
                  onLogin ??
                  () => Navigator.of(context).pushNamed(LoginScreen.routeName),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorPalette.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: Text('auth.login'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
