// ignore: prefer_mixin, one_member_abstracts
abstract class IRegisterInterface {
  Future<bool> register({required String username, required String password, required String email, String? phoneNumber});
}
