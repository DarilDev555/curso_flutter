import '../../../config/const/environment.dart';
import '../../providers/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomAvatarAppbar extends ConsumerWidget {
  const CustomAvatarAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAuth = ref.watch(authProvider);
    final String accessToken = ref.watch(authProvider).user!.token;

    return GestureDetector(
      onTap: ref.read(authProvider.notifier).logout,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: CircleAvatar(
          backgroundImage: NetworkImage(
            '${Environment.apiUrl}/${userAuth.user!.profilePicture}',
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
        ),
      ),
    );
  }
}
