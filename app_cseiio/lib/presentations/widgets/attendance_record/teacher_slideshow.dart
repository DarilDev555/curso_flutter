// import 'package:animate_do/animate_do.dart';
import '../../providers/auth/auth_provider.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/teacher.dart';
import '../../providers/storage/local_teachers_provider.dart';
import '../shared/text_frave.dart';

class TeacherSlideshow extends ConsumerStatefulWidget {
  final int idAttendance;

  const TeacherSlideshow({super.key, this.idAttendance = -1});

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
        autoplay: true,
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
          return _TeacherCard(
            teacher: teachers[index],
            accessToken: accessToken,
          );
        },
      ),
    );
  }
}

class _TeacherCard extends StatelessWidget {
  final Teacher teacher;
  final String accessToken;

  const _TeacherCard({required this.teacher, required this.accessToken});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
          boxShadow: [
            const BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  teacher.avatar ?? '',
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                  headers: {"Authorization": "Bearer $accessToken"},
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFrave(
                      text:
                          '${teacher.firstName} ${teacher.paternalLastName} ${teacher.maternalLastName}',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                    const SizedBox(height: 5),
                    TextFrave(
                      text: teacher.email,
                      fontSize: 15,
                      color: Colors.grey[700] ?? Colors.grey,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
