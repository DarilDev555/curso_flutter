import '../../../domain/entities/user.dart';
import 'users_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final usersRegisterProvider =
    StateNotifierProvider<UsersRegisterNotifier, List<User>>((ref) {
      final fetchgetusers =
          ref.watch(usersRepositoryProvider).getUsersResgiters;

      return UsersRegisterNotifier(fetchgetUsers: fetchgetusers);
    });

typedef UsersCallback = Future<List<User>> Function({int page});

class UsersRegisterNotifier extends StateNotifier<List<User>> {
  int currentPage = 0;
  bool isLoading = false;
  int ultimaPeticon = 10;
  UsersCallback fetchgetUsers;

  UsersRegisterNotifier({required this.fetchgetUsers}) : super([]);

  Future<void> loadUsers() async {
    if (isLoading) return;

    isLoading = true;
    final List<User> users = await fetchgetUsers(page: currentPage);

    if (users.isEmpty) {
      isLoading = false;
      return;
    }

    if (users.length == 10 && ultimaPeticon == 10) {
      currentPage++;
      ultimaPeticon = users.length;
      state = [...state, ...users];
      isLoading = false;
      return;
    }
    if (users.length > ultimaPeticon) {
      for (var i = ultimaPeticon; i < users.length; i++) {
        state = [...state, users[i]];
      }

      ultimaPeticon = users.length;
      isLoading = false;
      users.length == 10 ? currentPage++ : 0;
      return;
    }
    // ultima ueron 10 pero la entrega son menores
    if (ultimaPeticon == 10) {
      state = [...state, ...users];

      ultimaPeticon = users.length;
      isLoading = false;
      return;
    }
    isLoading = false;
  }
}
