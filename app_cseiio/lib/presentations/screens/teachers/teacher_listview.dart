import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/teacher.dart';

import '../../widgets/shared/teacher_card_list_view.dart';

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
            child: TeacherCardListView(
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
