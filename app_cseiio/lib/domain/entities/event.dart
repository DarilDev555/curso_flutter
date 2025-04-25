import 'event_day.dart';
import 'package:flutter/material.dart';

class Event {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final List<EventDay>? eventdays;
  final Color background;

  Event({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.description,
    this.eventdays,
  }) : background = _generateColor(id); // Se genera el color a partir del ID

  static final List<Color> _accentColors = [
    Colors.redAccent,
    Colors.pinkAccent,
    Colors.purpleAccent,
    Colors.deepPurpleAccent,
    Colors.indigoAccent,
    Colors.blueAccent,
    Colors.lightBlueAccent,
    Colors.cyanAccent,
    Colors.tealAccent,
    Colors.greenAccent,
    Colors.lightGreenAccent,
    Colors.limeAccent,
    Colors.amberAccent,
    Colors.orangeAccent,
    Colors.deepOrangeAccent,
  ];

  static Color _generateColor(String input) {
    final int hash = input.hashCode;
    final int index = hash.abs() % _accentColors.length;
    return _accentColors[index];
  }
}
