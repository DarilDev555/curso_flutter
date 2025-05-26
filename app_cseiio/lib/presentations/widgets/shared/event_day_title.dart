import 'package:flutter/material.dart';
import 'package:tinycolor2/tinycolor2.dart';

import '../../../config/helpers/human_formats.dart';
import '../../../domain/entities/event_day.dart';
import 'attendace_title.dart';

class EventDayTile extends StatelessWidget {
  final EventDay eventDay;
  final Color colorBackground;

  const EventDayTile({
    super.key,
    required this.eventDay,
    required this.colorBackground,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = TinyColor.fromColor(
      colorBackground,
    ).toColor().lighten(20);

    return ExpansionTile(
      shape: RoundedRectangleBorder(
        // Forma cuando está expandido
        borderRadius: BorderRadius.circular(16.0),
      ),
      collapsedShape: RoundedRectangleBorder(
        // Forma cuando está colapsado
        borderRadius: BorderRadius.circular(8.0),
      ),
      backgroundColor: color,
      collapsedBackgroundColor: color,
      title: Text(
        'Día ${eventDay.numDay} - ${HumanFormats.formatDate(eventDay.dateDayEvent, nameDay: true)}',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        'Horario: ${HumanFormats.timeStringToDateTimeFormat(eventDay.startTime)} - ${HumanFormats.timeStringToDateTimeFormat(eventDay.endTime)}',
      ),
      children: [
        if (eventDay.attendances != null && eventDay.attendances!.isNotEmpty)
          ...eventDay.attendances!.map(
            (att) => AttendanceTile(
              attendance: att,
              colorBackground: colorBackground,
            ),
          )
        else
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Sin asistencias registradas'),
          ),
      ],
    );
  }
}
