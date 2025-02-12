import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movil_app_uesa/presentations/providers/teachers/institutionTeacher_provider.dart';
import 'package:movil_app_uesa/presentations/screens/dashboard/menu_dashboard/teacher/teacher_listview.dart';

import '../../../../providers/teachers/teachers_provider.dart';

class TeachersDashboardScreen extends ConsumerStatefulWidget {
  static const name = 'teachers-dashboard-screen';

  const TeachersDashboardScreen({super.key});

  @override
  TeachersDashboardScreenState createState() => TeachersDashboardScreenState();
}

class TeachersDashboardScreenState
    extends ConsumerState<TeachersDashboardScreen> {
  @override
  void initState() {
    super.initState();
    final getInstitutionTeacher = ref.read(getinstitutionTeacherProvider);
    if (getInstitutionTeacher.isEmpty) {
      ref.read(getTeachersProvider.notifier).loadTeachers();
    }
  }

  @override
  Widget build(BuildContext context) {
    final getTeachers = ref.watch(getTeachersProvider);
    final getInstitutionTeacher = ref.watch(getinstitutionTeacherProvider);
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    for (var teacher in getTeachers) {
      ref
          .read(getinstitutionTeacherProvider.notifier)
          .loadInstitution('${teacher.id}');
    }

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
          TeachersListVew(
            colors: colors,
            textStyle: textStyle,
            size: size,
            loadNextPage: () {
              // ref.read(upcomingMoviesProvider.notifier).loadNetPage();
              ref.read(getTeachersProvider.notifier).loadTeachers();
            },
            teachers: getTeachers,
            institutionTeacher: getInstitutionTeacher,
          )
        ],
      ),
    );
  }
}
