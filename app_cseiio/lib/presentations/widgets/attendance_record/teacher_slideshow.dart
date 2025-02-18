import 'package:animate_do/animate_do.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_cseiio/domain/entities/institution.dart';
import 'package:app_cseiio/domain/entities/teacher.dart';
import 'package:app_cseiio/presentations/providers/storage/local_teachers_provider.dart';
import 'package:app_cseiio/presentations/providers/teachers/institutionTeacher_provider.dart';
import 'package:app_cseiio/presentations/widgets/shared/text_frave.dart';

class TechearSlideshow extends ConsumerStatefulWidget {
  const TechearSlideshow({super.key});

  @override
  TechearSlideshowState createState() => TechearSlideshowState();
}

class TechearSlideshowState extends ConsumerState<TechearSlideshow> {
  @override
  void initState() {
    super.initState();

    ref.read(localTecahersProvider.notifier).loadTeachers();
  }

  @override
  Widget build(BuildContext context) {
    final getTeachers = ref.watch(localTecahersProvider);
    final getInstitutionTeacher = ref.watch(getinstitutionTeacherProvider);
    final colors = Theme.of(context).colorScheme;

    for (var teacher in getTeachers.values) {
      ref
          .read(getinstitutionTeacherProvider.notifier)
          .loadInstitution('${teacher.id}');
    }

    return SizedBox(
      height: 250,
      width: double.infinity,
      child: Swiper(
        viewportFraction: 0.8,
        scale: 0.9,
        autoplay: true,
        pagination: SwiperPagination(
          margin: const EdgeInsets.only(top: 0),
          builder: DotSwiperPaginationBuilder(
            activeColor: colors.primary,
            color: colors.secondary,
          ),
        ),
        itemCount: getTeachers.length,
        itemBuilder: (context, index) {
          final teacher = getTeachers.values.toList()[index];

          Institution? institution = getInstitutionTeacher['${teacher.id}'];
          return _Slide(teacher, institution);
        },
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Teacher teacher;
  final Institution? institution;

  const _Slide(this.teacher, this.institution);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 15)),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: DecoratedBox(
        decoration: decoration,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 200,
            decoration: const BoxDecoration(color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      height: 100,
                      width: 100,
                      teacher.avatar ??
                          'https://static.thenounproject.com/png/1669490-200.png',
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress != null) {
                          return const DecoratedBox(
                            decoration: BoxDecoration(color: Colors.black12),
                          );
                        }
                        return FadeIn(child: child);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                    child: SizedBox(
                      width: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFrave(
                            text: 'Nombre',
                            maxLines: 1,
                            color: colors.secondary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          TextFrave(
                            text:
                                '${teacher.firstName} ${teacher.paternalLastName} ${teacher.maternalLastName}',
                            maxLines: 1,
                            color: colors.secondary,
                            fontSize: 15,
                          ),
                          TextFrave(
                            text: 'Institucción',
                            maxLines: 1,
                            color: colors.secondary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          TextFrave(
                            text: institution?.name ?? 'null',
                            maxLines: 2,
                            color: colors.secondary,
                            fontSize: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
