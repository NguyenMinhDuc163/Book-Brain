import 'package:book_brain/screen/edit_profile/service/profile_interface.dart';
import 'package:book_brain/service/api_service/api_service.dart';
import 'package:book_brain/service/api_service/request/change_password_request.dart';
import 'package:book_brain/service/api_service/request/update_profile_request.dart';
import 'package:book_brain/service/api_service/response/base_response.dart';
import 'package:book_brain/service/api_service/response/update_profile_response.dart';


class ProfileService implements IProfileInterface {
  final ApiServices apiServices = ApiServices();


  @override
  Future<bool?> updateProfile({required int id,  String? email,  String? phoneNumber, String? userName})async {
    final UpdateProfileRequest request = UpdateProfileRequest(
      id: id,
      email: email,
      phoneNumber: phoneNumber,
      username: userName
    );
    final BaseResponse<UpdateProfileResponse> response = await apiServices.updateProfile(request);
    if (response.code != null) {
      return true;
    }
    return false;
  }

  @override
  Future<bool?> changePassword({required int id, required String oldPassword, required String newPassword}) async{
    final ChangePasswordRequest request = ChangePasswordRequest(
        id: id,
        oldPassword: oldPassword,
        newPassword: newPassword
    );
    final BaseResponse<UpdateProfileResponse> response = await apiServices.changePassword(request);
    if (response.code != null) {
      return true;
    }
    return false;
  }
}
