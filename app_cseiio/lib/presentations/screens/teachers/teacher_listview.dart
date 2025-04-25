import 'package:animate_do/animate_do.dart';
import '../../providers/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/teacher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TeachersListVew extends StatefulWidget {
  final ColorScheme colors;
  final TextTheme textStyle;
  final VoidCallback? loadNextPage;
  final List<Teacher> teachers;

  const TeachersListVew({
    super.key,
    required this.colors,
    required this.textStyle,
    this.loadNextPage,
    required this.teachers,
  });

  @override
  State<TeachersListVew> createState() => _TeachersListVewState();
}

class _TeachersListVewState extends State<TeachersListVew> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (widget.loadNextPage == null) return;
      if ((scrollController.position.pixels + 200) >=
          scrollController.position.maxScrollExtent) {
        widget.loadNextPage!();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teachers = widget.teachers;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        itemCount: teachers.length,
        itemBuilder: (BuildContext context, int index) {
          final teacher = teachers[index];
          return FadeInUp(
            duration: Duration(milliseconds: 150 + (index * 50)),
            child: _TeacherCard(
              teacher: teacher,
              colors: widget.colors,
              textStyle: widget.textStyle,
            ),
          );
        },
      ),
    );
  }
}

class _TeacherCard extends ConsumerWidget {
  final Teacher teacher;
  final ColorScheme colors;
  final TextTheme textStyle;

  const _TeacherCard({
    required this.teacher,
    required this.colors,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String accessToken = ref.watch(authProvider).user!.token;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push('/teacher-detail-screen/${teacher.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            child: Row(
              children: [
                Hero(
                  tag: 'teacher-${teacher.id}',
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colors.primary.withValues(alpha: 0.2),
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        teacher.avatar ??
                            'https://static.thenounproject.com/png/1669490-200.png',
                        fit: BoxFit.cover,
                        headers: {"Authorization": "Bearer $accessToken"},
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress != null) {
                            return Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                              ),
                            );
                          }
                          return child;
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.person,
                            size: 30,
                            color: colors.primary,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${teacher.firstName} ${teacher.paternalLastName} ${teacher.maternalLastName}',
                        style: textStyle.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        teacher.email,
                        style: textStyle.bodySmall?.copyWith(
                          color: colors.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: colors.onSurface.withValues(alpha: 0.3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
