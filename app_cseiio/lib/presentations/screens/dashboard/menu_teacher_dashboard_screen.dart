import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/user.dart';
import '../../providers/auth/auth_provider.dart';
import '../../widgets/shared/update_create_image_avatar.dart';

class MenuTeacherDashboardScreen extends ConsumerStatefulWidget {
  const MenuTeacherDashboardScreen({super.key});

  @override
  MenuTeacherDashboardScreenState createState() =>
      MenuTeacherDashboardScreenState();
}

class MenuTeacherDashboardScreenState
    extends ConsumerState<MenuTeacherDashboardScreen> {
  late User user;

  @override
  void initState() {
    super.initState();
    user = ref.read(authProvider).user!;
    final isProfilePicture = user.profilePicture == 'img/teachers/default.png';

    if (isProfilePicture) {
      Future.microtask(() {
        if (!mounted) return;

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const UpdateCreateImageAvatar(isFirstPicture: true),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
