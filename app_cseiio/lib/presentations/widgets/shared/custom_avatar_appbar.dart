import 'package:tinycolor2/tinycolor2.dart';

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
          radius: 20,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.network(
              '${Environment.apiUrl}/${userAuth.user!.profilePicture}',
              headers: {'Authorization': 'Bearer $accessToken'},
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const CircularProgressIndicator();
              },
              errorBuilder: (context, error, stackTrace) {
                print('${Environment.apiUrl}/${userAuth.user!.profilePicture}');
                return Icon(
                  size: 20,
                  Icons.image_not_supported_rounded,
                  color: TinyColor.fromString('#b65d79').color,
                );
              },
              filterQuality: FilterQuality.none,
            ),
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
