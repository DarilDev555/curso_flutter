import 'package:tinycolor2/tinycolor2.dart';

import '../../../config/const/environment.dart';
import '../../../domain/entities/user.dart';
import '../../providers/auth/auth_provider.dart';
import '../../providers/users/users_register_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegistersScreen extends ConsumerStatefulWidget {
  static const String name = 'registers-screen';
  const RegistersScreen({super.key});

  @override
  RegistersScreenState createState() => RegistersScreenState();
}

class RegistersScreenState extends ConsumerState<RegistersScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    ref.read(usersRegisterProvider.notifier).loadUsers();
    controller.addListener(() {
      // Aquí podrías agregar lógica para paginación si lo necesitas en el futuro
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<User> users = ref.watch(usersRegisterProvider);
    final String accessToken = ref.watch(authProvider).user!.token;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Usuarios registrados',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body:
          users.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: ListView.builder(
                  controller: controller,
                  padding: const EdgeInsets.all(10),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return _UserCard(user: user, accessToken: accessToken);
                  },
                ),
              ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final User user;
  final String accessToken;

  const _UserCard({required this.user, required this.accessToken});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          child: Image.network(
            '${Environment.apiUrl}/${user.profilePicture}',
            headers: {'Authorization': 'Bearer $accessToken'},
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.image_not_supported_rounded,
                color: TinyColor.fromString('#b65d79').color,
              );
            },
          ),
        ),
        title: Text(
          user.userName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(user.email),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Aquí puedes navegar a una pantalla de detalle si lo deseas
          // context.push('/user-detail/${user.id}');
        },
      ),
    );
  }
}
