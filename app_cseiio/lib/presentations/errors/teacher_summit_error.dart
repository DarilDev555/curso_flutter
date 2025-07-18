import '../../domain/entities/teacher.dart';

class TeacherSummitError implements Exception {
  final String message;
  final Teacher teahcer;
  final String errorCode;

  TeacherSummitError({
    required this.message,
    required this.teahcer,
    required this.errorCode,
  });
}
