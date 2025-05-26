import 'package:flutter/material.dart';
import 'package:tinycolor2/tinycolor2.dart';

import '../../../config/helpers/human_formats.dart';
import '../../../domain/entities/attendance.dart';

class AttendanceTile extends StatelessWidget {
  final Attendance attendance;
  final int toleranceMinutes = 10; // Tolerancia de 10 minutos
  final Color colorBackground;
  final bool isUser;

  const AttendanceTile({
    super.key,
    required this.attendance,
    required this.colorBackground,
    this.isUser = true,
  });

  // Método para determinar el estado de la asistencia
  String _getAttendanceStatus() {
    if (attendance.register == null) return 'no_registered';

    final registerTime = attendance.register!.registerTime;
    final attendanceTime = attendance.attendanceTime;
    final difference = registerTime.difference(attendanceTime).inMinutes;

    if (difference <= toleranceMinutes && difference >= -toleranceMinutes) {
      return 'on_time';
    } else if (registerTime.isAfter(
      attendanceTime.add(Duration(minutes: toleranceMinutes)),
    )) {
      return 'late';
    } else {
      return 'on_time'; // Llegó antes del tiempo con tolerancia
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = _getAttendanceStatus();
    final formattedAttendanceTime = HumanFormats.formateHour(
      attendance.attendanceTime.toString(),
    );
    final formattedRegisterTime =
        attendance.register != null
            ? HumanFormats.formateHour(
              attendance.register!.registerTime.toString(),
            )
            : null;
    final Color color = TinyColor.fromColor(
      colorBackground,
    ).toColor().lighten(30);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 1,
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icono según estado
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getStatusIcon(status),
                    color: _getStatusColor(status),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    attendance.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (attendance.descripcion.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  attendance.descripcion,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hora programada',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      formattedAttendanceTime,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                (isUser)
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          status == 'no_registered'
                              ? 'Estado'
                              : 'Hora de registro',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (status == 'no_registered')
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Sin registro',
                              style: TextStyle(color: Colors.red[500]),
                            ),
                          )
                        else
                          Text(
                            formattedRegisterTime!,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: _getStatusColor(status),
                            ),
                          ),
                      ],
                    )
                    : const SizedBox.shrink(),
              ],
            ),
            const SizedBox(height: 4),
            if (status != 'no_registered')
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status == 'on_time' ? 'A tiempo' : 'Con retraso',
                    style: TextStyle(
                      color: _getStatusColor(status),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Métodos auxiliares
  Color _getStatusColor(String status) {
    switch (status) {
      case 'on_time':
        return Colors.green;
      case 'late':
        return Colors.orange;
      case 'no_registered':
      default:
        return Colors.red;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'on_time':
        return Icons.check_circle;
      case 'late':
        return Icons.watch_later;
      case 'no_registered':
      default:
        return Icons.error_outline;
    }
  }
}
