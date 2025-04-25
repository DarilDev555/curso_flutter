import '../../../domain/datasources/users/users_datasource.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/repositories/users/users_repository.dart';

class UsersRepositoryImpl extends UsersRepository {
  final UsersDatasource usersDatasource;

  UsersRepositoryImpl({required this.usersDatasource});

  @override
  Future<List<User>> getUsersResgiters({int page = 0}) {
    return usersDatasource.getUsersResgiters(page: page);
  }
}
