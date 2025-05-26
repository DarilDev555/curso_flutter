import '../../../config/const/environment.dart';
import '../../providers/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/shared/update_create_avatar_provider.dart';
import 'update_create_image_avatar.dart';

class CustomAvatarAppbar extends ConsumerWidget {
  const CustomAvatarAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAuth = ref.watch(authProvider);
    final String accessToken = ref.watch(authProvider).user!.token;
    final bool isOpenModal = ref.watch(updateCreateAvatarProvider);

    return GestureDetector(
      onTap: () {
        if (isOpenModal) return;
        ref.read(updateCreateAvatarProvider.notifier).update((state) => true);
        showCenterDialog(context);
      },
      onDoubleTap: ref.read(authProvider.notifier).logout,
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

  void showCenterDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const UpdateCreateImageAvatar(),
    );
  }
}
