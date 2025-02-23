import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:book_brain/screen/login/provider/login_notifier.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routeName = '/LoginScreen';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginNotifier>(context);
    final model = presenter.userModel;
    return Scaffold(
      body: Container(
        color: Colors.blueGrey,
        child: Center(child: Text("account_login.login_success".tr())),
      ),
    );
  }
}
