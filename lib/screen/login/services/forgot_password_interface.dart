// ignore: prefer_mixin, one_member_abstracts
abstract class IForgotPasswordInterface {
  Future<bool?> forgotPassword({required int id, required String oldPassword, required String newPassword});
}
