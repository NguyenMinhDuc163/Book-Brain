import 'package:book_brain/utils/core/helpers/local_storage_helper.dart';

class AuthHelper {
  const AuthHelper._();

  static bool get isLoggedIn {
    final token = LocalStorageHelper.getValue('authToken');
    return token != null && token.toString().isNotEmpty;
  }

  static bool get isGuest {
    return !isLoggedIn || LocalStorageHelper.getValue('isGuest') == true;
  }

  static Future<void> continueAsGuest() async {
    await LocalStorageHelper.setValue('isGuest', true);
  }

  static Future<void> markLoggedIn() async {
    await LocalStorageHelper.setValue('isGuest', false);
  }
}
