import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import '../../../config/helpers/human_formats.dart';
import '../../../domain/entities/attendance.dart';
import '../../inputs/inputs.dart';
import 'attendance_repository_provider.dart';

final attendanceCreateFormProvider = StateNotifierProvider.autoDispose
    .family<AttendanceFormNotifier, AttendanceFormState, Attendance>((
      ref,
      attendance,
    ) {
      final checkAttendance =
          ref.watch(attendanceRepositoryProvider).checkAttendance;

      return AttendanceFormNotifier(
        id: attendance.id,
        checkAttendance,
        inicialName: attendance.name,
        inicialDescription: attendance.descripcion,
        inicialTimeAttendance:
            (attendance.attendanceTime.year != 999)
                ? attendance.attendanceTime
                : null,
      );
    });

typedef CheckAttendanceOnApi =
    Future<Map<String, dynamic>?> Function(
      String name,
      String description,
      String attendanceTime,
    );

class AttendanceFormNotifier extends StateNotifier<AttendanceFormState> {
  final CheckAttendanceOnApi checkAttendanceOnApi;
  final String id;
  final String? inicialName;
  final String? inicialDescription;
  final DateTime? inicialTimeAttendance;
  AttendanceFormNotifier(
    this.checkAttendanceOnApi, {
    required this.id,
    this.inicialName,
    this.inicialDescription,
    this.inicialTimeAttendance,
  }) : super(
         AttendanceFormState(
           id: id,
           name: Name.pure(inicialName),
           description: Description.pure(inicialDescription),
           timeAttendance: TimeInput.pure(
             inicialTimeAttendance != null
                 ? TimeOfDay.fromDateTime(inicialTimeAttendance)
                 : null,
           ),
         ),
       );

  // posible function para varificar el estado de este attendance

  void onNameChange(String value) {
    final newName = Name.dirty(value);
    state = state.copyWith(
      name: newName,
      isValid: Formz.validate([
        newName,
        state.description,
        state.timeAttendance,
      ]),
    );
  }

  void onDescriptionChange(String value) {
    final newDescription = Description.dirty(value);
    state = state.copyWith(
      description: newDescription,
      isValid: Formz.validate([
        state.name,
        newDescription,
        state.timeAttendance,
      ]),
    );
  }

  void onTimeAttendanceChange(
    TimeOfDay value, {
    required List<TimeOfDay>? times,
  }) {
    final newTimeAttendance = TimeInput.dirty(value, times);
    state = state.copyWith(
      timeAttendance: newTimeAttendance,
      isValid: Formz.validate([
        state.name,
        state.description,
        newTimeAttendance,
      ]),
    );
  }

  Future<Attendance?> onFormSumit(
    DateTime dateOfEventDay, {
    required List<TimeOfDay>? times,
  }) async {
    _touchEveryField(times: times);

    if (!state.isValid && !(state.isSumit)) return null;

    state = state.copyWith(isSumit: true);

    final errors = await checkAttendanceOnApi(
      state.name.value,
      state.description.value,
      HumanFormats.formatTimeAttendanceToSumit(state.timeAttendance.value!),
    );
    if (errors != null && errors['isValid'] == false) {
      state = state.copyWith(errors: errors.cast(), isSumit: false);
      return null;
    }

    final Attendance attendance = Attendance(
      id: state.id,
      name: state.name.value,
      descripcion: state.description.value,
      attendanceTime: dateOfEventDay.copyWith(
        hour: state.timeAttendance.value!.hour,
        minute: state.timeAttendance.value!.minute,
        second: 0,
      ),
    );

    state = state.copyWith(
      errors: {},
      isValidAttendance: true,
      isCheckingUser: false,
      isSumit: false,
    );
    return attendance;
  }

  _touchEveryField({required List<TimeOfDay>? times}) {
    final name = Name.dirty(state.name.value);
    final description = Description.dirty(state.description.value);
    final timeAttendance = TimeInput.dirty(state.timeAttendance.value, times);

    state = state.copyWith(
      isFormPosted: true,
      name: name,
      description: description,
      timeAttendance: timeAttendance,
      isValid: Formz.validate([name, description, timeAttendance]),
    );
  }
}

class AttendanceFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final bool isValidAttendance;
  final bool isCheckingUser;
  final bool isSumit;
  final String id;
  final Name name;
  final Description description;
  final TimeInput timeAttendance;
  final Map<String, String>? errors;

  const AttendanceFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.isValidAttendance = false,
    this.isCheckingUser = false,
    this.isSumit = false,
    required this.id,
    this.name = const Name.pure(),
    this.description = const Description.pure(),
    this.timeAttendance = const TimeInput.pure(),
    this.errors,
  });

  AttendanceFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    bool? isValidAttendance,
    bool? isCheckingUser,
    bool? isSumit,
    String? id,
    Name? name,
    Description? description,
    TimeInput? timeAttendance,
    Map<String, String>? errors,
  }) {
    return AttendanceFormState(
      isPosting: isPosting ?? this.isPosting,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      isValid: isValid ?? this.isValid,
      isValidAttendance: isValidAttendance ?? this.isValidAttendance,
      isCheckingUser: isCheckingUser ?? this.isCheckingUser,
      isSumit: isSumit ?? this.isSumit,
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      timeAttendance: timeAttendance ?? this.timeAttendance,
      errors: errors ?? this.errors,
    );
  }

  @override
  String toString() {
    return '''
    isPosting: $isPosting,
    isFormPosted: $isFormPosted,
    isValid: $isValid,
    isValidUser: $isValidAttendance,
    isCheckingUser: $isCheckingUser,
    isSumit: $isSumit,
    id: $id,
    name: $name,
    description: $description,
    timeAttendance: $timeAttendance
    ''';
  }
}
