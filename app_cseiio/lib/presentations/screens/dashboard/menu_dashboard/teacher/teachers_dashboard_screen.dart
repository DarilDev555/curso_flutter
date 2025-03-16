import 'package:app_cseiio/presentations/widgets/shared/custom_avatar_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_cseiio/presentations/screens/dashboard/menu_dashboard/teacher/teacher_listview.dart';

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
    ref.read(getTeachersProvider.notifier).loadTeachers();
  }

  @override
  Widget build(BuildContext context) {
    final getTeachers = ref.watch(getTeachersProvider);
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: CustomAvatarAppbar(),
        title: const Text('Asistentes', textAlign: TextAlign.center),
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
          ),
        ],
      ),
    );
  }
}
