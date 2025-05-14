import 'package:book_brain/screen/edit_profile/service/profile_service.dart';
import 'package:book_brain/screen/home/provider/home_notifier.dart';
import 'package:book_brain/service/api_service/response/subscriptions_response.dart';
import 'package:book_brain/utils/core/base/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_brain/utils/routers.dart';

import '../../../utils/core/common/toast.dart';
import '../../../utils/core/constants/dimension_constants.dart';
import '../../../utils/core/helpers/local_storage_helper.dart';

class ProfileNotifier extends BaseNotifier {
  ProfileService profileService = ProfileService();

  Future<bool> updateProfile({
    String? email,
    String? userName,
    String? phoneNumber,
  }) async {
    return await execute(() async {
      int id = LocalStorageHelper.getValue("userId") ?? 1;
      bool? isSucc = await profileService.updateProfile(
        id: id,
        email: email?.isNotEmpty == true ? email : null,
        phoneNumber: phoneNumber,
        userName: userName,
      );

      if (isSucc == true) {
        // Cập nhật thông tin người dùng trong HomeNotifier
        Provider.of<HomeNotifier>(
          NavigationService.navigatorKey.currentContext!,
          listen: false,
        ).updateUserInfo(
          userName: userName,
          email: email?.isNotEmpty == true ? email : null,
        );
      }

      notifyListeners();
      return isSucc ?? false;
    });
  }




  Future<bool> changePassword({
    String? oldPassword,
    String? newPassword,
  }) async {
    return await execute(() async {
      int id = LocalStorageHelper.getValue("userId") ?? 1;
      bool? isSucc = await profileService.changePassword(
        id: id,
        oldPassword: oldPassword ?? "",
        newPassword: newPassword ?? "",

      );

      if (isSucc == true) {
         showToastTop(message: "Đổi mật khẩu thành công");
         return true;
      }

      notifyListeners();
      return false;
    });
  }
}
