
import 'package:book_brain/screen/login/model/user_model.dart';

import 'base_response.dart';

class RegisterResponse extends BaseResponse{
  final UserModel user;

  RegisterResponse({required this.user});

  // Ánh xạ JSON sang RegisterResponse
  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      user: UserModel.fromJson(json),
    );
  }

  // Chuyển RegisterResponse sang JSON
  Map<String, dynamic> toJson() => user.toJson();

  @override
  String toString() {
    return 'RegisterResponse{user: $user}';
  }
}
