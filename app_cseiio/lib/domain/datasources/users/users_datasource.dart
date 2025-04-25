import '../../entities/user.dart';

abstract class UsersDatasource {
  Future<List<User>> getUsersResgiters({int page = 0});
}
