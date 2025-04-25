import '../../widgets/shared/custom_avatar_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'teacher_listview.dart';
import '../../providers/teachers/teachers_provider.dart';

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

    return Scaffold(
      appBar: AppBar(
        leading: const CustomAvatarAppbar(),
        title: const Text(
          'Asistentes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colors.primary.withValues(alpha: 0.05),
              colors.surface.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar asistente...',
                  prefixIcon: Icon(Icons.search, color: colors.primary),
                  filled: true,
                  fillColor: colors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
            Expanded(
              child: TeachersListVew(
                colors: colors,
                textStyle: textStyle,
                loadNextPage: () {
                  ref.read(getTeachersProvider.notifier).loadTeachers();
                },
                teachers: getTeachers,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
