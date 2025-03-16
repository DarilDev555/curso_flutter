import 'package:animate_do/animate_do.dart';
import 'package:app_cseiio/presentations/providers/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:app_cseiio/domain/entities/teacher.dart';
import 'package:app_cseiio/presentations/widgets/shared/text_frave.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeachersListVew extends StatefulWidget {
  final ColorScheme colors;
  final TextTheme textStyle;
  final Size size;
  final VoidCallback? loadNextPage;
  final List<Teacher> teachers;

  const TeachersListVew({
    super.key,
    required this.colors,
    required this.textStyle,
    required this.size,
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
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: SizedBox(
        height: widget.size.height * 0.85,
        width: double.infinity,
        child: ListView.builder(
          controller: scrollController,
          scrollDirection: Axis.vertical,
          itemCount: teachers.length,
          itemBuilder: (BuildContext context, int index) {
            final teacher = teachers[index];

            return SizedBox(
              height: 100,
              child: _ItemList(
                teacher: teacher,
                colors: widget.colors,
                textStyle: widget.textStyle,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ItemList extends ConsumerWidget {
  final Teacher teacher;
  final ColorScheme colors;
  final TextTheme textStyle;
  const _ItemList({
    required this.teacher,
    required this.colors,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String accessToken = ref.watch(authProvider).user!.token;
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
              decoration: BoxDecoration(color: colors.surfaceContainer),
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
                        vertical: 8.0,
                        horizontal: 4.0,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          height: 50,
                          width: 50,
                          teacher.avatar ??
                              'https://static.thenounproject.com/png/1669490-200.png',
                          fit: BoxFit.cover,
                          headers: {"Authorization": "Bearer $accessToken"},
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress != null) {
                              return const DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                ),
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
                            text: teacher.email,
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
