import '../../entities/user.dart';

abstract class UsersDatasource {
  Future<List<User>> getUsersResgiters({int page = 0});
  Future<User> crateUpdateUser(Map<String, dynamic> userLike);
}
