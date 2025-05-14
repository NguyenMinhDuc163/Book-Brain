import 'package:book_brain/service/api_service/response/chapters_response.dart';
import 'package:book_brain/service/api_service/response/detail_book_response.dart';
import 'package:book_brain/service/api_service/response/favorites_response.dart';
import 'package:book_brain/service/api_service/response/subscriptions_response.dart';

abstract class IProfileInterface {
  Future<bool?> updateProfile({
    required int id,
     String email,
     String phoneNumber,
  });

  Future<bool?> changePassword({
    required int id,
    required String oldPassword,
    required String newPassword,
  });
}
