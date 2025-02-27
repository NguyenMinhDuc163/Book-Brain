// ignore: prefer_mixin, one_member_abstracts
abstract class ILoginInterface {
  Future<bool> login({required String username, required String password});
}
