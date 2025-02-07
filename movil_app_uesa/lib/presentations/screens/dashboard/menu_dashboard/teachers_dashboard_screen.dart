import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movil_app_uesa/domain/entities/teacher.dart';
import 'package:movil_app_uesa/domain/entities/institution.dart';
import 'package:movil_app_uesa/presentations/providers/teachers/institutionTeacher_provider.dart';
import 'package:movil_app_uesa/presentations/widgets/shared/text_frave.dart';

import '../../../providers/teachers/teachers_provider.dart';

class TeachersDashboardScreen extends StatelessWidget {
  static const name = 'teachers-dashboard-screen';

  const TeachersDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(4.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://media.licdn.com/dms/image/v2/D4E03AQG9vivTumsTUQ/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1729615646699?e=1741824000&v=beta&t=AmdFYtf9vHHVlFQg9hB0Q--c2zUxvvTMpAdjb7gxUSs'),
          ),
        ),
        title: const Text(
          'Asistentes',
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        children: [
          _TeachersListVew(
            colors: colors,
            textStyle: textStyle,
            size: size,
          )
        ],
      ),
    );
  }
}

class _TeachersListVew extends ConsumerStatefulWidget {
  final ColorScheme colors;
  final TextTheme textStyle;
  final Size size;

  const _TeachersListVew({
    required this.colors,
    required this.textStyle,
    required this.size,
  });

  @override
  _TeachersListVewState createState() => _TeachersListVewState();
}

class _TeachersListVewState extends ConsumerState<_TeachersListVew> {
  @override
  void initState() {
    super.initState();
    ref.read(getTeachersProvider.notifier).loadTeachers();
  }

  @override
  Widget build(BuildContext context) {
    final getTeachers = ref.watch(getTeachersProvider);
    final getInstitutionTeacher = ref.watch(getinstitutionTeacherProvider);

    for (var teacher in getTeachers) {
      ref
          .read(getinstitutionTeacherProvider.notifier)
          .loadInstitution('${teacher.id}');
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: SizedBox(
        height: widget.size.height * 0.85,
        width: double.infinity,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: getTeachers.length,
          itemBuilder: (BuildContext context, int index) {
            final teacher = getTeachers[index];

            return SizedBox(
              height: 100,
              child: _ItemList(
                teacher: teacher,
                colors: widget.colors,
                textStyle: widget.textStyle,
                institution: getInstitutionTeacher['${teacher.id}'],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ItemList extends StatelessWidget {
  final Teacher teacher;
  final Institution? institution;
  final ColorScheme colors;
  final TextTheme textStyle;
  const _ItemList({
    required this.teacher,
    required this.colors,
    required this.textStyle,
    this.institution,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      // boxShadow: const [
      //   BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 15)),
      // ],
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: decoration,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GestureDetector(
            onTap: () {
              // context.push(link); Cambiar a la vista de Asistente individual
            },
            child: Container(
              decoration: BoxDecoration(
                color: colors.surfaceContainer,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Wrap(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  direction: Axis.vertical,
                  alignment: WrapAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          height: 50,
                          width: 50,
                          teacher.avatar ??
                              'https://static.thenounproject.com/png/1669490-200.png',
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress != null) {
                              return const DecoratedBox(
                                decoration:
                                    BoxDecoration(color: Colors.black12),
                              );
                            }
                            return FadeIn(child: child);
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFrave(
                            text:
                                '${teacher.firstName} ${teacher.paternalLastName} ${teacher.maternalLastName}',
                            maxLines: 2,
                            color: colors.secondary,
                            fontSize: 15,
                            textAlign: TextAlign.left,
                          ),
                          TextFrave(
                            text: institution?.name ?? 'null',
                            maxLines: 2,
                            color: colors.secondary,
                            fontSize: 12,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
