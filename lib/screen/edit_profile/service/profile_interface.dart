abstract class IProfileInterface {
  Future<bool?> updateProfile({
    required int id,
    String? email,
    String? userName,
  });

  Future<bool?> changePassword({
    required int id,
    required String oldPassword,
    required String newPassword,
  });
}
