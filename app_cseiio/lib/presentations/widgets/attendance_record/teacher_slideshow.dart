// import 'package:animate_do/animate_do.dart';

import '../../providers/auth/auth_provider.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/teacher.dart';
import '../../providers/storage/local_teachers_provider.dart';
import 'teacher_card.dart';

class TeacherSlideshow extends ConsumerStatefulWidget {
  final int idAttendance;
  final double height;
  final double width;
  final bool cardIsJustAvatar;

  const TeacherSlideshow({
    super.key,
    this.idAttendance = -1,
    this.height = 100,
    this.width = 100,
    this.cardIsJustAvatar = false,
  });

  @override
  TeacherSlideshowState createState() => TeacherSlideshowState();
}

class TeacherSlideshowState extends ConsumerState<TeacherSlideshow> {
  final SwiperController controller = SwiperController();
  @override
  void initState() {
    super.initState();
    ref.read(localTeachersProvider.notifier).loadTeachers();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Teacher> teachers =
        ref
            .watch(localTeachersProvider)
            .values
            .where((teacher) => teacher.idAttendance == widget.idAttendance)
            .toList();
    final String accessToken = ref.watch(authProvider).user!.token;
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Swiper(
        controller: controller,
        index: teachers.length - 1,
        viewportFraction: 0.85,
        scale: 0.95,
        autoplay: false,
        loop: false,
        autoplayDisableOnInteraction: false,
        pagination: SwiperPagination(
          margin: const EdgeInsets.all(20),
          builder: DotSwiperPaginationBuilder(
            activeColor: colors.primary,
            color: Colors.grey.shade300,
          ),
        ),
        itemCount: teachers.length,
        itemBuilder: (context, index) {
          return TeacherCard(
            teacher: teachers[index],
            accessToken: accessToken,
            height: widget.height,
            width: widget.width,
            isJustAvatar: widget.cardIsJustAvatar,
          );
        },
      ),
    );
  }
}
