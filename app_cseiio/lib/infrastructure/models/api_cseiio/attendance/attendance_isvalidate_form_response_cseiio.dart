class AttendanceIsValidateFormResponseCseiio {
  final bool valid;
  final AttendanceCheckErrorsResponceCseiio? errors;

  AttendanceIsValidateFormResponseCseiio({
    required this.valid,
    required this.errors,
  });

  factory AttendanceIsValidateFormResponseCseiio.fromJson(
    Map<String, dynamic> json,
  ) {
    if (json["valid"]) {
      return AttendanceIsValidateFormResponseCseiio(
        valid: json["valid"],
        errors: null,
      );
    }

    return AttendanceIsValidateFormResponseCseiio(
      valid: json["valid"],
      errors: AttendanceCheckErrorsResponceCseiio.fromJson(json["errors"]),
    );
  }

  Map<String, dynamic> toJson() => {"valid": valid, "errors": errors!.toJson()};
}

class AttendanceCheckErrorsResponceCseiio {
  final String name;
  final String descripcion;
  final String attendanceTime;

  AttendanceCheckErrorsResponceCseiio({
    required this.name,
    required this.descripcion,
    required this.attendanceTime,
  });

  factory AttendanceCheckErrorsResponceCseiio.fromJson(
    Map<String, dynamic> json,
  ) => AttendanceCheckErrorsResponceCseiio(
    name: json["name"],
    descripcion: json["descripcion"],
    attendanceTime: json["attendance_time"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "descripcion": descripcion,
    "attendance_time": attendanceTime,
  };
}
