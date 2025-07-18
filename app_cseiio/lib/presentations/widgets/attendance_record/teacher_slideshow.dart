// import 'package:animate_do/animate_do.dart';

import 'package:tinycolor2/tinycolor2.dart';

import '../../providers/auth/auth_provider.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/teacher.dart';
import '../../providers/storage/local_teachers_provider.dart';
import '../shared/text_frave.dart';
import 'teacher_card.dart';

class TeacherSlideshow extends ConsumerStatefulWidget {
  final int idAttendance;
  final double heightAvatar;
  final double widthAvatar;
  final EdgeInsetsGeometry? margin;
  final bool viewHourRegister;

  const TeacherSlideshow({
    super.key,
    this.idAttendance = -1,
    this.heightAvatar = 100,
    this.widthAvatar = 100,
    this.viewHourRegister = false,
    this.margin,
  });

  @override
  TeacherSlideshowState createState() => TeacherSlideshowState();
}

class TeacherSlideshowState extends ConsumerState<TeacherSlideshow> {
  final SwiperController controller = SwiperController();
  @override
  void initState() {
    super.initState();
    ref.read(localTeachersProvider.notifier).loadTeachers(widget.idAttendance);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Teacher>? teachers =
        ref.watch(localTeachersProvider)[widget.idAttendance];
    ref.listen(localTeachersProvider, (previous, next) {
      if (next[widget.idAttendance] == null) return;
      controller.move(next[widget.idAttendance]!.length);
    });

    final String accessToken = ref.watch(authProvider).user!.token;
    return (teachers != null)
        ? (teachers.isNotEmpty)
            ? SizedBox(
              child: Swiper(
                controller: controller,
                index: teachers.length - 1,
                viewportFraction: 0.85,
                scale: 0.95,
                autoplay: false,
                loop: false,
                autoplayDisableOnInteraction: false,
                pagination: SwiperPagination(
                  margin: const EdgeInsets.all(10),
                  builder: DotSwiperPaginationBuilder(
                    activeColor: TinyColor.fromString('#cb8ca0').color,
                    color: TinyColor.fromString('#a12f53').color,
                  ),
                ),
                itemCount: teachers.length,
                itemBuilder: (context, index) {
                  return TeacherCard(
                    teacher: teachers[index],
                    accessToken: accessToken,
                    heightAvatar: widget.heightAvatar,
                    widthAvatar: widget.widthAvatar,
                    viewHourRegister: widget.viewHourRegister,
                    margin: widget.margin,
                  );
                },
              ),
            )
            : Container(
              margin: widget.margin?.add(
                const EdgeInsets.symmetric(horizontal: 8),
              ),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: TinyColor.fromString('#88163a').color,
              ),
              child: Center(
                child: TextFrave(
                  text: 'No hay asistencias registradas',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: TinyColor.fromString('#f5e8ec').color,
                  maxLines: 3,
                ),
              ),
            )
        : const Center(child: CircularProgressIndicator());
  }
}
