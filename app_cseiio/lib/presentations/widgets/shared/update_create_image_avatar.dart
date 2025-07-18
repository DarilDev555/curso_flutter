import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tinycolor2/tinycolor2.dart';

import '../../../config/const/environment.dart';
import '../../../domain/entities/user.dart';
import '../../../service/camera_gallery_service_impl.dart';
import '../../providers/auth/auth_provider.dart';
import '../../providers/shared/update_create_avatar_provider.dart';

class UpdateCreateImageAvatar extends ConsumerWidget {
  static const name = 'update-create-image-avatar';
  final bool isFirstPicture;
  const UpdateCreateImageAvatar({super.key, this.isFirstPicture = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final user = ref.watch(authProvider).user!;

    return Stack(
      children: [
        // Bloquea taps en el fondo
        ModalBarrier(
          dismissible: false,
          color: Colors.black.withValues(
            alpha: 0.3,
          ), // o Colors.transparent si no quieres sombra
        ),

        Center(
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                width: size.width * 0.8,
                height: size.height * 0.45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Stack(
                    children: [
                      Container(
                        width: size.width * 0.9,
                        height: size.height * 0.5,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.only(
                          left: 16,
                          top: 8,
                          right: 16,
                        ),
                        child: Center(
                          child: _UserInfo(
                            user: user,
                            contextDialog: context,
                            isFistPicture: isFirstPicture,
                          ),
                        ),
                      ),
                      !isFirstPicture
                          ? Positioned(
                            top: 0,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                ref
                                    .watch(updateCreateAvatarProvider.notifier)
                                    .update((state) => false);
                                // overlayEntry.remove();
                                Navigator.of(context).pop();
                              },
                              child: const Icon(
                                Icons.close,
                                size: 28,
                                color: Colors.black,
                              ),
                            ),
                          )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _UserInfo extends ConsumerWidget {
  final BuildContext contextDialog;
  final bool isFistPicture;
  final User user;

  const _UserInfo({
    required this.user,
    required this.contextDialog,
    required this.isFistPicture,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 70,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  '${Environment.apiUrl}/${user.profilePicture}',
                  headers: {'Authorization': 'Bearer ${user.token}'},
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      size: 80,
                      Icons.image_not_supported_rounded,
                      color: TinyColor.fromString('#b65d79').color,
                    );
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 4,
              child: ElevatedButton(
                onPressed: () {
                  _showAvatarOptions(context, ref, contextDialog);
                },

                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(10),
                  backgroundColor: theme.primaryColor,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          user.userName,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(user.email, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 8),
        Text(
          !isFistPicture
              ? 'Puedes cambiar tu imagen de avatar tocando el botón de cámara.'
              : 'Para continuar, toque el ícono de la cámara para crear su foto de perfil.',
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _showAvatarOptions(
    BuildContext context,
    WidgetRef ref,
    BuildContext contextDialog,
  ) {
    showModalBottomSheet(
      enableDrag: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Cambiar avatar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Tomar foto con cámara'),
                onTap: () async {
                  final photoPath =
                      await CameraGalleryServiceImpl().takePhoto();
                  if (photoPath == null) return;
                  final photoPath2 = await CameraGalleryServiceImpl()
                      .cropSelectedImage(photoPath);
                  if (photoPath2 == null) {
                    return;
                  }
                  final updatePicture = await ref
                      .read(authProvider.notifier)
                      .updateAvatarUser(photoPath2);
                  if (updatePicture != null &&
                      updatePicture &&
                      context.mounted) {
                    Navigator.of(context).pop();
                    Navigator.of(contextDialog).pop();
                    ref
                        .watch(updateCreateAvatarProvider.notifier)
                        .update((state) => false);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Seleccionar desde galería'),
                onTap: () async {
                  final photoPath =
                      await CameraGalleryServiceImpl().selectPhoto();
                  if (photoPath == null) return;
                  final photoPath2 = await CameraGalleryServiceImpl()
                      .cropSelectedImage(photoPath);
                  if (photoPath2 == null) return;
                  final updatePicture = await ref
                      .read(authProvider.notifier)
                      .updateAvatarUser(photoPath2);
                  if (updatePicture != null &&
                      updatePicture &&
                      context.mounted) {
                    Navigator.of(context).pop();
                    Navigator.of(contextDialog).pop();
                    ref
                        .watch(updateCreateAvatarProvider.notifier)
                        .update((state) => false);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
